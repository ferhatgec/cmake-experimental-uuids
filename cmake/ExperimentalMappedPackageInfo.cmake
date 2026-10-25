if(DEFINED PROJECT_NAME)
  message(FATAL_ERROR "ExperimentalMappedPackageInfo must be included before project()!")
endif()

if(CMAKE_VERSION VERSION_LESS "4.3.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_MAPPED_PACKAGE_INFO requires CMake 4.3.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  set(CMAKE_EXPERIMENTAL_MAPPED_PACKAGE_INFO "ababa1b5-7099-495f-a9cd-e22d38f274f2")
endif()
