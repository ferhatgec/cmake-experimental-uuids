if(DEFINED PROJECT_NAME)
  message(FATAL_ERROR "ExperimentalFindCpsPackages must be included before project()!")
endif()

if(CMAKE_VERSION VERSION_LESS "4.0.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_FIND_CPS_PACKAGES requires CMake 4.0.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  # Graduated in 4.3.0: no experimental gate needed.
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.0.0")
  set(CMAKE_EXPERIMENTAL_FIND_CPS_PACKAGES "e82e467b-f997-4464-8ace-b00808fff261")
endif()
