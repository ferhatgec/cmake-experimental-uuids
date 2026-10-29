if(DEFINED PROJECT_NAME)
  if(NOT ExperimentalCxxImportStd_APPLIED)
    message(FATAL_ERROR "ExperimentalCxxImportStd must be included before project()! "
      "When this is a subproject, include it in the top-level project instead.")
  endif()
  # a parent scope (usually the top-level project) already applied this module
  return()
endif()

set(ExperimentalCxxImportStd_APPLIED ON)

if(CMAKE_VERSION VERSION_LESS "3.30.0")
  message(FATAL_ERROR "CMAKE_EXPERIMENTAL_CXX_IMPORT_STD requires CMake 3.30.0 or newer.")
elseif(CMAKE_VERSION STREQUAL "4.4.0-rc2")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "451f2fe2-a8a2-47c3-bc32-94786d8fc91b")
elseif(CMAKE_VERSION STREQUAL "4.4.0-rc1")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "451f2fe2-a8a2-47c3-bc32-94786d8fc91b")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.5.0")
  # PROVISIONAL: only 4.5.0-rc2 exists so far; regenerate after the release.
  # Graduated in 4.5.0: no experimental gate needed.
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.4.0")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "f35a9ac6-8463-4d38-8eec-5d6008153e7d")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.3.0")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "451f2fe2-a8a2-47c3-bc32-94786d8fc91b")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.0.3")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "4.0.0")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "a9e1cf81-9932-4810-974b-6eccaf14e457")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "3.31.8")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
elseif(CMAKE_VERSION VERSION_GREATER_EQUAL "3.30.0")
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")
endif()
