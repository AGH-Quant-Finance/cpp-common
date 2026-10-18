#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
fixture="$(mktemp -d)"
trap 'rm -rf -- "$fixture"' EXIT

# Exercise the documented FetchContent/copy integration against this checkout.
cat > "$fixture/CMakeLists.txt" <<'CMAKE'
cmake_minimum_required(VERSION 3.24)
project(CppCommonConsumer LANGUAGES NONE)
include(FetchContent)
FetchContent_Declare(cpp_common SOURCE_DIR "${CPP_COMMON_SOURCE_DIR}")
FetchContent_MakeAvailable(cpp_common)
file(COPY "${cpp_common_SOURCE_DIR}/config/" DESTINATION "${CMAKE_SOURCE_DIR}")
CMAKE

cmake -S "$fixture" -B "$fixture/build" -G Ninja -DCPP_COMMON_SOURCE_DIR="$repo_root"
for config in .clang-format .clang-tidy .clangd .editorconfig .gitattributes; do
    cmake -E compare_files "$repo_root/config/$config" "$fixture/$config"
done

# Ask the actual consumers to reject unsupported formatting options/checks.
# The pinned CI image provides these versioned binaries, without unversioned aliases.
clang-format-22 --style="file:$fixture/.clang-format" --dump-config > /dev/null
clang-tidy-22 --config-file="$fixture/.clang-tidy" --verify-config
printf 'Shared configurations and CMake integration validated.\n'
