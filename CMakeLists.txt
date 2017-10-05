##--------------------------------------------------------------------------
## SFOP CMake file
##--------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.8)
project(SFOP VERSION 1.0 LANGUAGES CXX)
set(BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})

find_package(OpenCL REQUIRED) # yields OpenCL::OpenCL target

option(WITH_GPU "Enable GPU support in sfop executable" ON)


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
)

target_include_directories(libsfop 
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
    $<INSTALL_INTERFACE:include/libsfop>
)

set(LIBSFOP_PLATFORM_SPECIFIC_LIBS)
if(UNIX)    
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)
    list(APPEND LIBSFOP_PLATFORM_SPECIFIC_LIBS Threads::Threads)
endif()

target_link_libraries(libsfop
    OpenCL::OpenCL
    ${LIBSFOP_PLATFORM_SPECIFIC_LIBS}
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
install(FILES src/sfopKernels.cl DESTINATION ${BUILD_DIR}/bin)
export(TARGETS libsfop FILE libsfopConfig.cmake)

##--------------------------------------------------------------------------
## Executable: sfop
##--------------------------------------------------------------------------
add_executable(sfop
    src/main.cpp
)

set(SFOP_PLATFORM_SPECIFIC_LIBS)
if(UNIX)
    find_package(X11 REQUIRED)
    list(APPEND SFOP_PLATFORM_SPECIFIC_LIBS X11)
endif()

target_link_libraries(sfop
    libsfop
    ${SFOP_PLATFORM_SPECIFIC_LIBS}
)

target_compile_definitions(sfop
    PRIVATE $<$<BOOL:${WITH_GPU}>:GPU>
)
install(TARGETS sfop RUNTIME DESTINATION ${BUILD_DIR}/bin)
