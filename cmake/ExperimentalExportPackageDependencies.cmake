if(DEFINED PROJECT_NAME)
  if(NOT ExperimentalExportPackageDependencies_APPLIED)
    message(FATAL_ERROR "ExperimentalExportPackageDependencies must be included before project()! "
      "When this is a subproject, include it in the top-level project instead.")
  endif()
  # a parent scope (usually the top-level project) already applied this module
  return()
endif()

set(ExperimentalExportPackageDependencies_APPLIED ON)

if(CMAKE_VERSION VERSION_LESS "3.29.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_DEPENDENCIES requires CMake 3.29.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "3.29.0")
  set(CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_DEPENDENCIES "1942b4fa-b2c5-4546-9385-83f254070067")
endif()
