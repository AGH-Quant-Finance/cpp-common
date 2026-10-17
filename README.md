# cpp-common

Common tool configurations for agh-quant-finance C++ repositories

## Overview

This repository contains configs that are meant to be used across all agh-quant-finance C++ repositories. Preconfigured tools are:

* `clang-tidy`
* `clangd`
* `clang-format`
* `editorconfig`
* `git`

Using these configs will lead to easier review process across repositories, consistent format and naming conventions.

## Integrating the configurations

These configs should be installed as a step in `CMake` configuration. 

>[!WARNING]
> Do not include the configs directly in repositories. Put the config file names in `.gitignore`

Example of usage could look like this:

```cmake
cmake_minimum_required(VERSION 3.24)
project(MyProject LANGUAGES CXX)

include(FetchContent)

FetchContent_Declare(
    cpp_common
    GIT_REPOSITORY https://github.com/AGH-Quant-Finance/cpp-common.git
    GIT_TAG v0.1.0
)

FetchContent_MakeAvailable(cpp_common)

file(
    COPY "${cpp_common_SOURCE_DIR}/config/"
    DESTINATION "${CMAKE_SOURCE_DIR}"
)
```

## Semantic Versioning workflow

In this repository you can also find a [`semver.yml`](./.github/workflows/semver.yml) workflow. Every C++ repository in agh-quant-finance should utilize this workflow to keep consistent versioning strategy. [`semver.yml`](./.github/workflows/semver.yml) can be easily integrated with CI by calling it remotely:

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

## Pull-request validation and releases

Pull requests run the CMake integration and configuration checks in `scripts/validate.sh`, using the existing toolchain image version `0.1.3` (Clang 22). The check verifies that FetchContent makes this checkout available, that all five configuration files reach the consumer, and that clang-format and clang-tidy accept their configurations. It does not validate clangd settings at runtime; clangd is not included in the toolchain image.

Run the same validation locally from the repository root:

```bash
docker run --rm --network none --volume "$PWD:/workspace:ro" --workdir /workspace ghcr.io/agh-quant-finance/cpp-toolchain-image:0.1.3 bash scripts/validate.sh
```

The PR workflow has read-only repository access and never publishes tags. Release automation remains in `.github/workflows/release.yml`, calls the existing reusable workflow at `@v1`, and runs only on pushes to `main`. The reusable workflow and existing tags are unchanged.

On SELinux hosts, the local bind mount may need `:ro,Z` instead of `:ro`. Relabel only your working copy; this is not needed on the Ubuntu GitHub runner.

Use `[MAJOR]`, `[MINOR]`, or `[PATCH]` followed by a space in the PR title. When merging, keep that prefix in the final commit subject (for example, use the PR title as the squash-merge title), because the existing release workflow reads the main-branch commit subject. The PR title check also reruns when the title is edited.

The CMake example pins the published `v0.1.0` configuration release; the `@v1` reference above selects the existing reusable-workflow channel. These references serve different purposes. Review version updates explicitly in consuming repositories.

## Contributing

Propose configuration changes through a pull request, explaining their effect on repositories that consume cpp-common.

If there is no reaction to your pull request for more than 2 days, contact [Piotr Walczak](https://github.com/piti83) directly via GitHub, email or Discord.

