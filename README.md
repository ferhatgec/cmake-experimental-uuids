# cmake-experimental-uuids

[![Update CMake Experimental UUIDs](https://github.com/ferhatgec/cmake-experimental-uuids/actions/workflows/update-experimental-uuids.yml/badge.svg)](https://github.com/ferhatgec/cmake-experimental-uuids/actions/workflows/update-experimental-uuids.yml)

CMake modules that abstract away `CMAKE_EXPERIMENTAL_*` UUID changes between CMake versions (including release candidates and patch-level rotations). Automatically updated daily from upstream CMake tags.

When an experimental feature graduates in a newer CMake release, the corresponding module safely becomes a no-op.

## Usage

> **Note:** Experimental gates must always be fetched and included **before** `project()`.

### Via `FetchContent`

```cmake
cmake_minimum_required(VERSION 3.30)

include(FetchContent)
FetchContent_Declare(
  cmake-experimental-uuids
  GIT_REPOSITORY https://github.com/ferhatgec/cmake-experimental-uuids.git
  GIT_TAG main
)
FetchContent_MakeAvailable(cmake-experimental-uuids)

include(ExperimentalCxxImportStd)

project(example LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_MODULE_STD ON)
```

### Via `file(DOWNLOAD)` (Single Module)

```cmake
cmake_minimum_required(VERSION 3.30)

set(_uuid_module "${CMAKE_BINARY_DIR}/cmake/ExperimentalCxxImportStd.cmake")
file(
  DOWNLOAD
  "https://raw.githubusercontent.com/ferhatgec/cmake-experimental-uuids/main/cmake/ExperimentalCxxImportStd.cmake"
  "${_uuid_module}"
  TLS_VERIFY ON
  STATUS _uuid_status
)
list(GET _uuid_status 0 _uuid_code)
if(NOT _uuid_code EQUAL 0)
  message(FATAL_ERROR "Could not download ExperimentalCxxImportStd: ${_uuid_status}")
endif()
include("${_uuid_module}")

project(example LANGUAGES CXX)
```

## Available Modules
<!-- BEGIN GENERATED MODULES -->
| Module | CMake Variable |
| :--- | :--- |
| `include(ExperimentalCxxImportStd)` | `CMAKE_EXPERIMENTAL_CXX_IMPORT_STD` |
| `include(ExperimentalExportBuildDatabase)` | `CMAKE_EXPERIMENTAL_EXPORT_BUILD_DATABASE` |
| `include(ExperimentalExportPackageDependencies)` | `CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_DEPENDENCIES` |
| `include(ExperimentalExportPackageInfo)` | `CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_INFO` |
| `include(ExperimentalFindCpsPackages)` | `CMAKE_EXPERIMENTAL_FIND_CPS_PACKAGES` |
| `include(ExperimentalGenerateSbom)` | `CMAKE_EXPERIMENTAL_GENERATE_SBOM` |
| `include(ExperimentalInstrumentation)` | `CMAKE_EXPERIMENTAL_INSTRUMENTATION` |
| `include(ExperimentalMappedPackageInfo)` | `CMAKE_EXPERIMENTAL_MAPPED_PACKAGE_INFO` |
| `include(ExperimentalRust)` | `CMAKE_EXPERIMENTAL_RUST` |
| `include(ExperimentalSycl)` | `CMAKE_EXPERIMENTAL_SYCL` |
<!-- END GENERATED MODULES -->

## License

cmake-experimental-uuids licensed under the terms of the MIT License.
