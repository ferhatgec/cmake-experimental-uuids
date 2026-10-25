# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Ferhat Geçdoğan.
#
import http.client
import os
import re
import time
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor

BASE_URL = "https://raw.githubusercontent.com/Kitware/CMake/refs/tags/v{version}/Help/dev/experimental.rst"
FEATURE_REGEX = re.compile(
  r"[Vv]ariable:?\s+``(CMAKE_EXPERIMENTAL_[A-Z0-9_]+)``(?:\s+to)?\s+(?:\*\s+)?[Vv]alue:?\s+``([0-9a-fA-F-]+)``"
)
MENTION_REGEX = re.compile(r"``(CMAKE_EXPERIMENTAL_[A-Z0-9_]+)``")


def parse_features(version_str, content):
  features = dict(FEATURE_REGEX.findall(content))
  # guard for unattended runs: if upstream changes the doc format, FEATURE_REGEX
  # would silently match nothing and every feature would look "graduated".
  # every variable the doc mentions must have been parsed together with a UUID.
  missed = set(MENTION_REGEX.findall(content)) - features.keys()
  if missed:
    raise RuntimeError(
      f"{version_str}: experimental.rst mentions {sorted(missed)} but "
      "FEATURE_REGEX found no UUID for them; the doc format probably changed."
    )
  return features


def fetch_tag(version_str, retries=3):
  url = BASE_URL.format(version=version_str)
  req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
  for attempt in range(retries):
    try:
      with urllib.request.urlopen(req, timeout=10) as response:
        content = response.read().decode("utf-8", errors="ignore")
        if "CMake Experimental Features Guide" not in content:
          return None
        return parse_features(version_str, content)
    except urllib.error.HTTPError as e:
      if e.code == 404:
        return None
      if attempt == retries - 1:
        raise
    except (OSError, http.client.HTTPException):
      # OSError covers URLError and TimeoutError; IncompleteRead is only an
      # HTTPException. none of these may be mistaken for "tag doesn't exist",
      # otherwise a transient failure silently punches a hole in the history.
      if attempt == retries - 1:
        raise
    time.sleep(1 + attempt)

  raise RuntimeError(f"{version_str}: fetch failed without an error")


def scan_all_versions(start_major=3, start_minor=29):
  major = start_major
  minor = start_minor
  raw_versions = []

  with ThreadPoolExecutor(max_workers=6) as executor:
    while True:
      patch = 0
      minor_found = False

      while True:
        base_ver = f"{major}.{minor}.{patch}"
        candidates = [f"{base_ver}-rc{i}" for i in range(1, 6)] + [base_ver]
        results = list(executor.map(fetch_tag, candidates))

        valid_results = [
          (ver, res) for ver, res in zip(candidates, results) if res is not None
        ]

        if not valid_results:
          break

        minor_found = True
        raw_versions.append((base_ver, valid_results))
        features_found = ", ".join(valid_results[-1][1].keys()) or "None"
        print(f"[+] {base_ver}: {features_found}")
        patch += 1

      if not minor_found:
        if minor == 0:
          break
        major += 1
        minor = 0
      else:
        minor += 1

  return raw_versions


def var_to_module_name(var_name):
  parts = var_name.removeprefix("CMAKE_").split("_")
  return "".join(p.capitalize() for p in parts)


def build_feature_history(raw_versions, var_name):
  version_states = []
  rc_overrides = []
  ever_seen = False

  for base_ver, valid_results in raw_versions:
    if not ever_seen:
      if not any(var_name in feat_map for _, feat_map in valid_results):
        continue
      ever_seen = True

    tag_states = []
    for tag_ver, feat_map in valid_results:
      if var_name in feat_map:
        tag_states.append((tag_ver, ("EXPERIMENTAL", feat_map[var_name])))
      else:
        tag_states.append((tag_ver, ("GRADUATED", None)))

    last_tag, canonical_state = tag_states[-1]

    for tag_ver, state in tag_states[:-1]:
      if state == canonical_state:
        continue
      # an rc that doesn't list the variable while the final release does is
      # an rc that predates the gate (e.g. 3.29.0-rc1...rc3).
      # it isn't "graduated" and setting the final UUID there is harmless, so no
      # special branch is needed.
      if state[0] == "GRADUATED" and canonical_state[0] == "EXPERIMENTAL":
        continue
      rc_overrides.append((tag_ver, state))

    # if the final tag doesn't exist yet, this version's state comes from an rc
    # and may still change (4.3.0-rc1 -> rc2 did exactly that for CMAKE_EXPERIMENTAL_CXX_IMPORT_STD).
    provisional_tag = last_tag if last_tag != base_ver else None
    version_states.append((base_ver, canonical_state, provisional_tag))

  transitions = []
  last_state = None
  for ver, state, provisional_tag in version_states:
    if state != last_state:
      transitions.append((ver, state, provisional_tag))
      last_state = state

  return transitions, rc_overrides


def generate_cmake_script(var_name, transitions, rc_overrides, output_dir="cmake"):
  if not transitions:
    return

  os.makedirs(output_dir, exist_ok=True)
  module_name = var_to_module_name(var_name)
  output_path = os.path.join(output_dir, f"{module_name}.cmake")
  min_version = transitions[0][0]

  lines = [
    "if(DEFINED PROJECT_NAME)",
    f'  message(FATAL_ERROR "{module_name} must be included before project()!")',
    "endif()",
    "",
    f'if(CMAKE_VERSION VERSION_LESS "{min_version}")',
    f'  message(FATAL_ERROR "{var_name} requires CMake {min_version} or newer.")',
  ]

  for ver, (status, uuid) in reversed(rc_overrides):
    lines.append(f'elseif(CMAKE_VERSION STREQUAL "{ver}")')
    if status == "EXPERIMENTAL":
      lines.append(f'  set({var_name} "{uuid}")')
    else:
      lines.append(f"  # {ver}: already graduated, no experimental gate needed.")

  for ver, (status, uuid), provisional_tag in reversed(transitions):
    lines.append(f'elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "{ver}")')
    if provisional_tag:
      lines.append(
        f"  # PROVISIONAL: only {provisional_tag} exists so far; regenerate after the release."
      )
    if status == "EXPERIMENTAL":
      lines.append(f'  set({var_name} "{uuid}")')
    else:
      # this branch must stay. without it, the older ">=" branches below would
      # match on new CMake and re-apply a stale UUID.
      lines.append(f"  # Graduated in {ver}: no experimental gate needed.")

  lines.append("endif()")
  lines.append("")

  with open(output_path, "w", encoding="utf-8", newline="\n") as f:
    f.write("\n".join(lines))

  print(f"[*] Generated {output_path}")


def generate_root_cmakelists(raw_versions, output_path="CMakeLists.txt"):
  if not raw_versions:
    return

  min_ver = raw_versions[0][0]
  max_ver = raw_versions[-1][0]

  lines = [
    f"cmake_minimum_required(VERSION {min_ver}...{max_ver})",
    "",
    "if(DEFINED PROJECT_NAME)",
    '  message(FATAL_ERROR "cmake-experimental-uuids must be fetched before project()!")',
    "endif()",
    "",
    'list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")',
    "",
    "if(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)",
    '  set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)',
    "endif()",
    "",
  ]

  with open(output_path, "w", encoding="utf-8", newline="\n") as f:
    f.write("\n".join(lines))

  print(f"[*] Generated {output_path} ({min_ver}...{max_ver})")


if __name__ == "__main__":
  raw_versions = scan_all_versions()

  all_features = sorted({
    var_name
    for _, valid_results in raw_versions
    for _, feat_map in valid_results
    for var_name in feat_map.keys()
  })

  for var_name in all_features:
    transitions, overrides = build_feature_history(raw_versions, var_name)
    generate_cmake_script(var_name, transitions, overrides)

  generate_root_cmakelists(raw_versions)