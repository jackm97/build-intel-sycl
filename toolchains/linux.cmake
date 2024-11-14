# this one is important
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_PLATFORM Linux)

# where is the target environment
set(CMAKE_FIND_ROOT_PATH $ENV{PREFIX} $ENV{PREFIX}/${HOST}/sysroot)

set(CUDA_TOOLKIT_ROOT_DIR $ENV{CUDA_ROOT})
