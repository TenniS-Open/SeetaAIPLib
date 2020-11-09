cmake_minimum_required(VERSION 3.6)
project(SeetaAIPLib)

set(CMAKE_CXX_STANDARD 11)

# ======================== Load plugin cmake ========================== #
FILE(GLOB PLUGIN_CMAKES
        ${CMAKE_CURRENT_SOURCE_DIR}/cmake/plugin/*.cmake)
foreach (plugin ${PLUGIN_CMAKES})
    string(REGEX MATCH "[^/\\]*$" plugin_name ${plugin})
    message(STATUS "[plugin] ${plugin_name}")
    include(${plugin})
endforeach()
# ===================================================================== #


# ======================== Those are global options ========================== #
# Global option dot not edit, only if very needed.
# Output library name
set(AIP_NAME ${PROJECT_NAME})
# SeetaAIP API header store path
set(AIP_ROOT .api)
# SeetaAIP API header git
set(AIP_GIT https://gitlab.seetatech.com/SeetaAIoTBase/SeetaAIP.git)
# SeetaAIP API header tag
set(AIP_TAG "" CACHE STRING "Give git tag/branch. Set branch for check each time, tag for init first time.")
# Omega API header store path
set(OMEGA_ROOT .omega)
# Omega API header git
set(OMEGA_GIT https://gitlab.seetatech.com/SeetaFace7/omega.git)
# Omega API header tag
set(OMEGA_TAG "" CACHE STRING "Give git tag/branch. Set branch for check each time, tag for init first time.")
# ======================== Above are global options ========================== #
mark_as_advanced(AIP_TAG)
mark_as_advanced(OMEGA_TAG)

# ======================== Those are local options ========================== #
option(AIP_OMEGA "[Optional] If include Omega." ON)
option(AIP_TENNIS "[Optional] If link TenniS." ON)
option(AIP_OPENCV "[Optional] If link OpenCV." OFF)
option(AIP_OPENMP "[Optional] If use OpenMP, used by image converting." ON)
option(AIP_TEST "[Optional] If built test executable binary." OFF)
set(AIP_TYPE "SHARED" CACHE STRING "In SHARED or STATIC. Do ==NOT== Edit!")
# ======================== Above are local options ========================== #
mark_as_advanced(AIP_TYPE)

message(STATUS "========[ Configuring \"${AIP_NAME}\"")
message(STATUS "========[ (${AIP_NAME}): Library type: ${AIP_TYPE}")
message(STATUS "========[ (${AIP_NAME}): Link TenniS: ${AIP_TENNIS}")
message(STATUS "========[ (${AIP_NAME}): Link OpenCV: ${AIP_OPENCV}")
message(STATUS "========[ (${AIP_NAME}): Build test: ${AIP_TEST}")

# add cmake sub script root
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# init submodule
include(use_submodule)
use_submodule(SeetaAIP "${AIP_ROOT}" "${AIP_GIT}" "${AIP_TAG}")
if (AIP_OMEGA)
    use_submodule(Omega "${OMEGA_ROOT}" "${OMEGA_GIT}" "${OMEGA_TAG}")
endif ()

if (NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${AIP_ROOT}/include)
    message(FATAL_ERROR "There exists folder .api, but no include header found in .api/include.")
endif ()

# check AIP_NAME
string(REGEX MATCH "^[A-Za-z_][A-Za-z0-9_]*$" MATCHED_AIP_NAME "${AIP_NAME}")
if (NOT MATCHED_AIP_NAME)
    message(FATAL_ERROR "The AIP_NAME must be a valid variable name, but got \"${AIP_NAME}\"")
endif ()
unset(MATCHED_AIP_NAME)

# generate this library header
string(TIMESTAMP DATETIME "%Y/%m/%d")
configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/template/module_aip_load.h.in
        ${CMAKE_CURRENT_SOURCE_DIR}/include/${AIP_NAME}.h
)
configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/template/this_aip_load.h.in
        ${CMAKE_CURRENT_SOURCE_DIR}/src/this_aip_load.h
)

# set default flag
IF(CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
        OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
    set(CMAKE_CXX_CREATE_SHARED_LIBRARY "${CMAKE_CXX_CREATE_SHARED_LIBRARY} -fPIC")
    set(CMAKE_CXX_CREATE_SHARED_MODULE "${CMAKE_CXX_CREATE_SHARED_MODULE} -fPIC")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    # set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W3")
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "NVIDIA")
endif()

if (WIN32)
elseif (ANDROID)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fexceptions -frtti")
elseif (IOS)
elseif (APPLE)
elseif (UNIX)
    link_libraries(dl)
else ()
endif ()

# Find library
if (AIP_OPENCV)
    find_package(OpenCV REQUIRED)
endif ()

if (AIP_TENNIS)
    find_package(TenniS REQUIRED)
endif ()

if (AIP_OPENMP)
    find_package(OpenMP REQUIRED)
    if (OpenMP_FOUND)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        include_directories(${OpenMP_CXX_INCLUDE_DIRS})
        link_libraries(${OpenMP_CXX_LIBRARIES})
    endif()
endif ()

# glob source files
FILE(GLOB_RECURSE ${PROJECT_NAME}_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c
        )

FILE(GLOB_RECURSE ${PROJECT_NAME}_PUBLIC_HEADER
        ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hh
        ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
        )

FILE(GLOB_RECURSE ${PROJECT_NAME}_PRIVATE_HEADER
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hh
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
        )

if (NOT ${PROJECT_NAME}_SOURCE)
    message(FATAL_ERROR "Can not found any source files in \"${CMAKE_CURRENT_SOURCE_DIR}/src\".")
endif()

add_library(${PROJECT_NAME}_LIB ${AIP_TYPE}
        ${${PROJECT_NAME}_SOURCE} ${${PROJECT_NAME}_PRIVATE_HEADER} ${${PROJECT_NAME}_PUBLIC_HEADER})

if (WIN32)
    set_target_properties(${PROJECT_NAME}_LIB PROPERTIES PREFIX "")
endif ()

target_include_directories(${PROJECT_NAME}_LIB
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${AIP_ROOT}/include
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src
        )

target_compile_definitions(${PROJECT_NAME}_LIB PRIVATE SEETA_AIP_EXPORTS)

if (AIP_OMEGA)
    target_include_directories(${PROJECT_NAME}_LIB
            PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${OMEGA_ROOT}/include)
endif()

if (AIP_OPENCV AND OpenCV_FOUND)
    target_include_directories(${PROJECT_NAME}_LIB PRIVATE ${OpenCV_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME}_LIB ${OpenCV_LIBS})
endif ()

if (AIP_TENNIS AND TenniS_FOUND)
    target_include_directories(${PROJECT_NAME}_LIB PRIVATE ${TenniS_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME}_LIB ${TenniS_LIBS})
endif ()

set_target_properties(${PROJECT_NAME}_LIB PROPERTIES OUTPUT_NAME ${AIP_NAME})
set_target_properties(${PROJECT_NAME}_LIB PROPERTIES
         RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin"
         LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin"
         ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib"
         )

install(TARGETS ${PROJECT_NAME}_LIB
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        FRAMEWORK DESTINATION framework
        )

install(FILES ${${PROJECT_NAME}_PUBLIC_HEADER}
        DESTINATION include)

if (AIP_TEST)
    FILE(GLOB_RECURSE ${PROJECT_NAME}_TEST_SOURCE
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.c
            )
    if (${PROJECT_NAME}_TEST_SOURCE)
        add_executable(${PROJECT_NAME}_TEST ${${PROJECT_NAME}_TEST_SOURCE})
        target_include_directories(${PROJECT_NAME}_TEST
                PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${AIP_ROOT}/include
                PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
                )
        if (AIP_OMEGA)
            target_include_directories(${PROJECT_NAME}_TEST
                    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${OMEGA_ROOT}/include)
        endif()
        target_link_libraries(${PROJECT_NAME}_TEST ${PROJECT_NAME}_LIB)

        if (AIP_OPENCV AND OpenCV_FOUND)
            target_include_directories(${PROJECT_NAME}_TEST PRIVATE ${OpenCV_INCLUDE_DIRS})
            target_link_libraries(${PROJECT_NAME}_TEST ${OpenCV_LIBS})
        endif ()

        set_target_properties(${PROJECT_NAME}_TEST PROPERTIES OUTPUT_NAME test_${AIP_NAME})
        set_target_properties(${PROJECT_NAME}_TEST PROPERTIES
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin"
                LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin"
                ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib"
                )
    endif()
endif()
