if(DEFINED PROJECT_NAME)
  if(NOT ExperimentalSycl_APPLIED)
    message(FATAL_ERROR "ExperimentalSycl must be included before project()! "
      "When this is a subproject, include it in the top-level project instead.")
  endif()
  # a parent scope (usually the top-level project) already applied this module
  return()
endif()

set(ExperimentalSycl_APPLIED ON)

if(CMAKE_VERSION VERSION_LESS "4.5.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_SYCL requires CMake 4.5.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.5.0")
  # PROVISIONAL: only 4.5.0-rc2 exists so far; regenerate after the release.
  set(CMAKE_EXPERIMENTAL_SYCL "c0d1fb10-2ece-420e-9d29-7d7f2b300f25")
endif()
