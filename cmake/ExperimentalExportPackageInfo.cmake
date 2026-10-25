if(DEFINED PROJECT_NAME)
  message(FATAL_ERROR "ExperimentalExportPackageInfo must be included before project()!")
endif()

if(CMAKE_VERSION VERSION_LESS "3.31.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_INFO requires CMake 3.31.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  # Graduated in 4.3.0: no experimental gate needed.
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "3.31.0")
  set(CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_INFO "b80be207-778e-46ba-8080-b23bba22639e")
endif()
