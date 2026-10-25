cmake_minimum_required(VERSION 3.29.0...4.5.0)

if(DEFINED PROJECT_NAME)
  message(FATAL_ERROR "cmake-experimental-uuids must be fetched before project()!")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

if(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endif()
