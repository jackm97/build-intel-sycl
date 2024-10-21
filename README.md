# Build Open-DPC++ in Three Commands

**Open-DPC++** is an open-source toolkit based on LLVM with SYCL support,
designed as a counterpart to Intel's OneAPI DPC++. Building it, especially when
using Conda as a package and development environment manager, can be
challenging. Deploying it as a proper installation can be even more unclear.

This repository simplifies the process, enabling you to build Open-DPC++ with
just two commands. If you already use `pixi`, you can reduce this to a single
command.

<!--toc:start-->

- [What's Included in the Toolkit?](#whats-included-in-the-toolkit)
- [First-Class Support for Conda/Pixi](#first-class-support-for-condapixi)
- [Building Open-DPC++](#building-open-dpc)
- [Using the Installed Toolkit](#using-the-installed-toolkit)
  - [Environment Variables](#environment-variables)
  - [Using OneMKL](#using-onemkl)
  - [Using in a Conda Environment](#using-in-a-conda-environment)

<!--toc:end-->

## What's Included in the Toolkit?

This installation provides the following features:

- Support for Nvidia GPUs
- Native CPU support
- FPGA emulation via OpenCL
- OpenCL support for x86-64
- SPIR-V support
- Key LLVM tools:
  - `clang-tidy`
  - `clang-format`
  - Tools in `clang-tools-extra`
- Open-source OneMKL with BLAS and LAPACK support

## First-Class Support for Conda/Pixi

The Conda ecosystem is a powerful environment manager for package management and
isolating development environments. By using `conda` or `pixi`, you gain the
following advantages:

- **Reproducibility** of builds
- Access to the latest packages and libraries on any platform
- Virtual packages for system dependencies like sysroot, CUDA, libc, etc.,
  enabling binaries to be compatible across platforms without Conda
- Conda-forge packages are compiled with strict requirements, ensuring ABI
  compatibility
- Packages on `conda-forge` are never purged, guaranteeing long-term build
  support even for outdated projects

However, building a complex compiler toolkit like Open-DPC++ requires careful
configuration to ensure the compiler uses the correct Conda environment. The
installed Open-DPC++ toolkit is designed to offer seamless integration with
Conda. It includes an activation script that simplifies compiler setup when
working inside a Conda environment by setting necessary environment variables.

## Building Open-DPC++

### Step 1: Install `pixi`

To get started, install `pixi`:

```bash
curl -fsSL https://pixi.sh/install.sh | bash
source ~/.bashrc
```

### Step 2: Build Open-DPC++

Once `pixi` is installed, you can build Open-DPC++:

```bash
# Uncomment and modify the following line if
# you want to change the default installation path
# export DPCPP_ROOT=~/intel/dpcpp
pixi run --environment dpcpp-build install && pixi run --environment onemkl-build install
```

## Using the Installed Toolkit

After building the toolkit, you can activate it using the included activation
script:

```bash
export DPCPP_ROOT=~/intel/dpcpp  # Modify if using a custom installation path
source "$DPCPP_ROOT/setvars.sh"
```

With the toolkit activated, you can compile SYCL programs normally, provided the
necessary dependencies from `pixi.toml` are available on your system.

### Environment Variables

The following environment variables are defined when you activate the toolkit to
ensure tools like `clangd` work correctly in non-standard installations:

- `DPCPP_CXXFLAGS`
- `DPCPP_LDFLAGS`

For example, to compile a file called `main.cpp`, you would run:

```bash
export DPCPP_ROOT=~/intel/dpcpp  # Modify if using a custom installation path
source "$DPCPP_ROOT/setvars.sh"
clang++ -fsycl $DPCPP_CXXFLAGS main.cpp $DPCPP_LDFLAGS -o main
```

### Using OneMKL

If your SYCL program depends on OneMKL, make sure to include the appropriate
flags for successful compilation:

```bash
clang++ -fsycl $ONEMKL_CXXFLAGS main.cpp -o main $ONEMKL_LDFLAGS -lonemkl
```

### Using in a Conda Environment

When using Open-DPC++ within a Conda environment, ensure the Conda environment
is activated before activating Open-DPC++. The required compilation and linking
flags will be automatically set via the activation script.

For example, compiling `main.cpp` using the DPC++ toolchain would look like
this:

```bash
clang++ -fsycl $CXXFLAGS main.cpp -o main
```

To compile with OneMKL support, use:

```bash
clang++ -fsycl $CXXFLAGS main.cpp -o main $LDFLAGS -lonemkl
```

______________________________________________________________________

This improved ReadMe emphasizes clarity and reduces verbosity while keeping all
the necessary technical details. It uses consistent formatting and section flow
for easier navigation.
