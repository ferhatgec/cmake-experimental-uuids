if(DEFINED PROJECT_NAME)
  message(FATAL_ERROR "ExperimentalInstrumentation must be included before project()!")
endif()

if(CMAKE_VERSION VERSION_LESS "4.0.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_INSTRUMENTATION requires CMake 4.0.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  # Graduated in 4.3.0: no experimental gate needed.
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.2.0")
  set(CMAKE_EXPERIMENTAL_INSTRUMENTATION "ec7aa2dc-b87f-45a3-8022-fe01c5f59984")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.0.0")
  set(CMAKE_EXPERIMENTAL_INSTRUMENTATION "a37d1069-1972-4901-b9c9-f194aaf2b6e0")
endif()
