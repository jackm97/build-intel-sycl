# this one is important
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_PLATFORM Linux)
# this one not so much
set(CMAKE_SYSTEM_VERSION 1)

# where is the target environment
set(CMAKE_FIND_ROOT_PATH $ENV{DPCPP_ROOT} $ENV{CONDA_PREFIX}
                         $ENV{BUILD_PREFIX}/$ENV{HOST}/sysroot $ENV{CUDA_ROOT})

set(CUDA_TOOLKIT_ROOT_DIR $ENV{CUDA_ROOT})

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)

# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# god-awful hack because it seems to not run correct tests to determine this:
set(__CHAR_UNSIGNED___EXITCODE 1)
