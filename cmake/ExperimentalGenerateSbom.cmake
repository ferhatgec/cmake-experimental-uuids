if(DEFINED PROJECT_NAME)
  if(NOT ExperimentalGenerateSbom_APPLIED)
    message(FATAL_ERROR "ExperimentalGenerateSbom must be included before project()! "
      "When this is a subproject, include it in the top-level project instead.")
  endif()
  # a parent scope (usually the top-level project) already applied this module
  return()
endif()

set(ExperimentalGenerateSbom_APPLIED ON)

if(CMAKE_VERSION VERSION_LESS "4.3.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_GENERATE_SBOM requires CMake 4.3.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.5.0")
  # PROVISIONAL: only 4.5.0-rc1 exists so far; regenerate after the release.
  # Graduated in 4.5.0: no experimental gate needed.
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.4.0")
  set(CMAKE_EXPERIMENTAL_GENERATE_SBOM "2d856d6d-53e8-488b-a17f-d486d2cac317")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  set(CMAKE_EXPERIMENTAL_GENERATE_SBOM "ca494ed3-b261-4205-a01f-603c95e4cae0")
endif()
