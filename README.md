# ghaction-conan-cmake

This is a github action for projects that use conan and cmake. It builds, tests
and installs the project. It can also be used to to run the tests with
valgrind and clang sanitizers, and to run clang-tidy and clang-format
on the source.

Based on [ghaction-cmake](https://github.com/lpenz/ghaction-cmake).

## Inputs

### `dependencies`

Project dependencies as Debian packages to install in the container.

### `cc`

Compiler to use

### `cflags`, `cxxflags`

CFLAGS and CXXFLAGS environment variables. They can be used to enable
sanitizers, coverage, etc.

### `cmakeflags`

Flags for ccmake. They can be used to properly configure the application being built.

### `ctestflags`

Flags for ctest. `-D ExperimentalMemCheck`, for instance, enable test
execution under valgrind.

### `coverage`

Set to the coverage service where data should be sent.

Only `codecov` is supported at the moment.

### `analyzer`

When set, perform the specified analysis instead of the regular build+test+install task.

Supported options: `clang-tidy` and `clang-format`.


## Example:

The workflow below is a part of the one in [concore](https://github.com/lucteo/concore):

```yml
---
name: CI
on: push
jobs:
  build:
    strategy:
        matrix:
          cc: [ gcc, clang ]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: docker://lucteo/ghaction-conan-cmake:latest
        with:
          cc: ${{ matrix.cc }}
  coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: docker://lucteo/ghaction-conan-cmake:latest
        with:
          coverage: codecov
  valgrind:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: docker://lucteo/ghaction-conan-cmake:latest
        with:
          ctestflags: '-D ExperimentalMemCheck'
  clang-sanitizers:
    name: build with clang -fsanitize
    strategy:
        matrix:
          cflags:
            - -fsanitize=address
            - -fsanitize=memory
            - -fsanitize=undefined
            - -fsanitize=dataflow
            - -fsanitize=safe-stack
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: docker://lucteo/ghaction-conan-cmake:latest
        with:
          cc: clang
          cflags: ${{ matrix.cflags }}
  clang-format:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: docker://lucteo/ghaction-conan-cmake:latest
        with:
          analyzer: clang-format
  clang-analyzers:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: docker://lucteo/ghaction-conan-cmake:latest
        with:
          analyzer: clang-tidy
```
