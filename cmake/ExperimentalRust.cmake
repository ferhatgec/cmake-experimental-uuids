if(DEFINED PROJECT_NAME)
  if(NOT ExperimentalRust_APPLIED)
    message(FATAL_ERROR "ExperimentalRust must be included before project()! "
      "When this is a subproject, include it in the top-level project instead.")
  endif()
  # a parent scope (usually the top-level project) already applied this module
  return()
endif()

set(ExperimentalRust_APPLIED ON)

if(CMAKE_VERSION VERSION_LESS "4.3.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_RUST requires CMake 4.3.0 or newer.")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.4.0")
  set(CMAKE_EXPERIMENTAL_RUST "b6fdddce-bf66-41a5-bc5f-077f6fa4d2a1")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  set(CMAKE_EXPERIMENTAL_RUST "3cc9b32c-47d3-4056-8953-d74e69fc0d6c")
endif()
