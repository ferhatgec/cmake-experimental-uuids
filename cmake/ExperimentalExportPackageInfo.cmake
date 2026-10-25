if(DEFINED PROJECT_NAME)
  if(NOT ExperimentalExportPackageInfo_APPLIED)
    message(FATAL_ERROR "ExperimentalExportPackageInfo must be included before project()! "
      "When this is a subproject, include it in the top-level project instead.")
  endif()
  # a parent scope (usually the top-level project) already applied this module
  return()
endif()

set(ExperimentalExportPackageInfo_APPLIED ON)

if(CMAKE_VERSION VERSION_LESS "3.31.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_INFO requires CMake 3.31.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  # Graduated in 4.3.0: no experimental gate needed.
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "3.31.0")
  set(CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_INFO "b80be207-778e-46ba-8080-b23bba22639e")
endif()
