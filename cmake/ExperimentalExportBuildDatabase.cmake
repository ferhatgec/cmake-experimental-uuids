if(DEFINED PROJECT_NAME)
  if(NOT ExperimentalExportBuildDatabase_APPLIED)
    message(FATAL_ERROR "ExperimentalExportBuildDatabase must be included before project()! "
      "When this is a subproject, include it in the top-level project instead.")
  endif()
  # a parent scope (usually the top-level project) already applied this module
  return()
endif()

set(ExperimentalExportBuildDatabase_APPLIED ON)

if(CMAKE_VERSION VERSION_LESS "3.31.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_EXPORT_BUILD_DATABASE requires CMake 3.31.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.4.0")
  set(CMAKE_EXPERIMENTAL_EXPORT_BUILD_DATABASE "70ef007e-b743-492d-9407-e35eeac03a40")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.1.0")
  set(CMAKE_EXPERIMENTAL_EXPORT_BUILD_DATABASE "73194a1d-c0b5-41b9-9190-a4512925e192")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "3.31.0")
  set(CMAKE_EXPERIMENTAL_EXPORT_BUILD_DATABASE "4bd552e2-b7fb-429a-ab23-c83ef53f3f13")
endif()
