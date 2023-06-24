set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_COMPILER "/usr/bin/g++")
cmake_minimum_required(VERSION 3.25.2)
project(native_opencv)

include_directories(.)
include_directories(../include)
include_directories(../include/opencv2)
include_directories(../include/opencv2/core)
include_directories(../sources)

add_library(lib_opencv SHARED IMPORTED)

set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libopencv_java4.so)

find_library(log-lib log)

add_library(native_opencv SHARED
        ../sources/NativeOpencvPlugin.cpp
        ../sources/DetectChars.cpp
        ../sources/DetectPlates.cpp
        ../sources/Preprocess.cpp
        ../sources/PossiblePlate.cpp
        ../sources/PossibleChar.cpp
        ../sources/DetectChars.cpp)


target_link_libraries(native_opencv lib_opencv ${log-lib})