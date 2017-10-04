##--------------------------------------------------------------------------
## SFOP CMake file
##--------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.8)
project(SFOP VERSION 1.0 LANGUAGES CXX)
set(BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})

find_package(OpenCL REQUIRED) # yields OpenCL::OpenCL target


##--------------------------------------------------------------------------
## Library: libsfop
##--------------------------------------------------------------------------
add_library(libsfop
    src/CImageCl.cpp
    src/CImageCpu.cpp
    src/CLayer.cpp
    src/COctave.cpp
    src/COpenCl.cpp
    src/CSfop.cpp
    #src/CImageClTest.cpp
    #src/CImageCpuTest.cpp
    #src/CImageTest.cpp
    #src/CLayerTest.cpp
    #src/CSfopTest.cpp
)

target_include_directories(libsfop 
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
    $<INSTALL_INTERFACE:include/libsfop>
)

target_link_libraries(libsfop
    OpenCL::OpenCL
)

target_compile_definitions(libsfop
    PRIVATE NOMINMAX  # Disable Win32 MIN/MAX macros
)

install(TARGETS libsfop EXPORT libsfopConfig
    ARCHIVE  DESTINATION ${BUILD_DIR}/lib
    LIBRARY  DESTINATION ${BUILD_DIR}/lib
    RUNTIME  DESTINATION ${BUILD_DIR}/bin
)

install(DIRECTORY src/
  DESTINATION ${BUILD_DIR}/include/sfop 
  FILES_MATCHING PATTERN "*.h"
)
install(EXPORT libsfopConfig DESTINATION ${BUILD_DIR}/share/libsfop/cmake)
export(TARGETS libsfop FILE libsfopConfig.cmake)


##--------------------------------------------------------------------------
## Executable: sfop
##--------------------------------------------------------------------------
add_executable(sfop
    src/main.cpp
)
target_link_libraries(sfop
    libsfop
)
install(TARGETS sfop RUNTIME DESTINATION ${BUILD_DIR}/bin)
