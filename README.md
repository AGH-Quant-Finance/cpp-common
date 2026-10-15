# cpp-common

Common tool configurations for agh-quant-finance C++ repositories

## Overview

This repository contains configs that are meant to be used across all agh-quant-finance C++ repositories. Preconfigured tools are:

* `clang-tidy`
* `cland`
* `clang-format`
* `editorconfig`
* `git`

Using these configs will lead to easier review process across repositories, consistent format and naming conventions.

## How to integrate this configs in repositories

These configs should be installed as a step in `CMake` configuration. 

>[!WARNING]
> Do not include the configs directly in repositores. Put the config file names in `.gitignore`

Example of usage could look like this:

```cmake
cmake_minimum_required(VERSION 3.24)
project(MyProject LANGUAGES CXX)

include(FetchContent)

FetchContent_Declare(
    cpp_common
    GIT_REPOSITORY https://github.com/AGH-Quant-Finance/cpp-common.git
    GIT_TAG v1.0.0
)

FetchContent_MakeAvailable(cpp_common)

file(
    COPY "${cpp_common_SOURCE_DIR}/config/"
    DESTINATION "${CMAKE_SOURCE_DIR}"
)
```

## Semantic Versioning workflow

In this repository you can also find a [`semver.yml`](./github/workflows/semver.yml) workflow. Every C++ repository in agh-quant-finance should utilize this workflow to keep consistent versioning strategy. [`semver.yml`](./github/workflows/semver.yml) can be easily integrated with CI by calling it remotely:

```yaml
on:
  push:
    branches: [main]

permissions:
  contents: write

jobs:
  semver:
    uses: AGH-Quant-Finance/cpp-common/.github/workflows/semver.yml@v1
```

## Contributing

If You wish to add, modify or remove something from cpp-toolchain-image please do so via pull request, with good explanation of why and how it will affect all repositories that rely on this image.

If there is no reaction to your pull request for more than 2 days, contact [Piotr Walczak](https://github.com/piti83) directly via GitHub, email or Discord.

