if(DEFINED PROJECT_NAME)
  message(FATAL_ERROR "ExperimentalSycl must be included before project()!")
endif()

if(CMAKE_VERSION VERSION_LESS "4.5.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_SYCL requires CMake 4.5.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.5.0")
  # PROVISIONAL: only 4.5.0-rc1 exists so far; regenerate after the release.
  set(CMAKE_EXPERIMENTAL_SYCL "c0d1fb10-2ece-420e-9d29-7d7f2b300f25")
endif()
