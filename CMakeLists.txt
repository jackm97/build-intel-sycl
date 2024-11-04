cmake_minimum_required(VERSION 3.14)

project(build-dpcpp)

option(BUILD_ONEMKL "Build ONEMKL" OFF)

if(BUILD_ONEMKL)
  add_subdirectory(${CMAKE_SOURCE_DIR}/onemkl)
endif()
