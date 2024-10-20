# Build Open-DPC++ In Two Commands

Open-DPC++ is an llvm toolkit with SYCL support and is the open-source analogue
to OneAPI DPC++. Building it, especially when using conda as a package and dev
environment manager, is a challenge. Deploying it as a proper installation is
even less clear.

This repository aims to make doing the above as simple as running two commands
in your terminal. If you already use `pixi`, then this reduces to a single
command.

<!--toc:start-->
- [What's Included in the Installed Toolkit?](#whats-included-in-the-installed-toolkit)
- [Conda/Pixi First-Class Support](#condapixi-first-class-support)
- [Building Open-DPC++](#building-open-dpc)
- [Using the Installed Toolkit](#using-the-installed-toolkit)
  - [Helpful Environment Variables](#helpful-environment-variables)
  - [Using OneMKL](#using-onemkl)
  - [Using Within a Conda Environment](#using-within-a-conda-environment)
<!--toc:end-->

## What's Included in the Installed Toolkit?

- Nvidia support
- Native CPU support
- FPGA emulation support via OpenCL
- x86-64 OpenCL support
- SPIR-V support
- The most important LLVM tools:
- clang-tidy
  - clang-format
  - and everything else in clang-tools-extra
- Open-source OneMKL with blas and lapack support

## Conda/Pixi First-Class Support

When it comes to package management and isolating dev environments, the conda
ecosystem is quite powerful. Just some of the amazing benefits of using `conda`
or `pixi` for C++ development:

- reproducibility of builds
- latest packages and libraries on any platform
- virtual packages for things like sysroot, cuda, libc, etc. makes running code
  compiled within a conda environment executable on almost any platform without
  needing conda itself, as the binaries are guaranteed ABI compatible with
  minimally-supported system library versions
- binaries provided by `conda-forge` are compiled with strict requirements so
  that dependencies are ABI compatible with one another
- packages are never purged from `conda-forge`, guaranteeing projects with
  package versions that are rarely or never updated will build successfully,
  "forever"

That said, for something as complex as a compiler and supporting toolkit, it can
be difficult to ensure that the compiler uses the conda environment and not the
installed toolchains and libraries on the system itself, unless that compiler is
installed as a conda dependency.

So, the installed Open-DPC++ toolkit has first-class conda support. Similar to
OneAPI, the installed toolkit as an activation script. If the activation script
detects that it is being sourced within a conda environment, a number of extra
environment variables that makes using the compiler correctly, much easier.

## Building Open-DPC++

First, install `pixi`:

```bash
curl -fsSL https://pixi.sh/install.sh | bash
source ~/.bashrc
```

Now, run:

```bash
# export DPCPP_ROOT=~/intel/dpcpp  # uncomment to modify the default installation path
pixi run --environment dpcpp-build install && pixi run --environment onemkl-build install
```

## Using the Installed Toolkit

As mentioned, there is an activation script:

```bash
export DPCPP_ROOT=~/intel/dpcpp  # modify if custom installation path
source "$DPCPP_ROOT/setvars.sh"
```

Once activated, compiling any SYCL program should work normally, as long as the
packages listed under `[dependencies]` in `pixi.toml` are installed on the
system in a location that the compiler can find them.

### Helpful Environment Variables

Since the toolkit is installed in a non-standard location, tools such as
`clangd` might produce faulty output. For this reason, the following
`DPCPP_CXXFLAGS` and `DPCPP_LDFLAGS` are defined during activation to help with
this. For example, compiling a file called `main.cpp` could look like:

```bash
export DPCPP_ROOT=~/intel/dpcpp  # modify if custom installation path
source "$DPCPP_ROOT/setvars.sh"
clang++ -fsycl $DPCPP_CXXFLAGS main.cpp $DPCPP_LDFLAGS -o main
```

### Using OneMKL

If your SYCL program requires OneMKL, the flags `ONEMKL_CXXFLAGS` and
`ONEMKL_LDFLAGS` are necessary for successful compilation.

### Using Within a Conda Environment

When using the toolchain within a conda environment, make sure the environment
is activated before activating Open-DPC++.

A number of compilation and link flags are required for the DPC++ compilers to
behave as expected. When using `cmake`, this will be handled automatically
because of the environment variables defined in the toolchain activation.
However, if calling the compiler directly, the following is required using the
same `main.cpp` example:

```bash
clang++ -fsycl $CXXFLAGS main.cpp -o main
```

If using OneMKL, then the following is needed:

```bash
clang++ -fsycl $CXXFLAGS main.cpp -o main $LDFLAGS -lonemkl  # onemkl can be replaced with the static variants
```
