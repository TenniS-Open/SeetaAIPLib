cmake_minimum_required(VERSION 3.0)
project(SeetaAIPLib)

set(CMAKE_CXX_STANDARD 11)

# ======================== Those are global options ========================== #
# Global option dot not edit, only if very needed.
# Output library name
set(AIP_NAME ${PROJECT_NAME})
# SeetaAIP API header store path
set(AIP_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/.api)
# SeetaAIP API header git
set(AIP_GIT https://gitlab.seetatech.com/SeetaAIoTBase/SeetaAIP)
# SeetaAIP API header tag
set(AIP_TAG "" CACHE STRING "Give git tag. If set, AIP_UPDATE will disabled.")
# ======================== Above are global options ========================== #
mark_as_advanced(AIP_TAG)

# ======================== Those are local options ========================== #
option(AIP_UPDATE "[Optional] Auto check if AIP header updated." ON)
option(AIP_TEST "[Optional] If built test executable binary." OFF)
option(AIP_TENNIS "[Optional] If link TenniS." ON)
option(AIP_OPENCV "[Optional] If link OpenCV." OFF)
set(AIP_TYPE "SHARED" CACHE STRING "In SHARED or STATIC. Do ==NOT== Edit!")
# ======================== Above are local options ========================== #
mark_as_advanced(AIP_UPDATE)
mark_as_advanced(AIP_TYPE)

message(STATUS "========[ Configuring \"${AIP_NAME}\"")
message(STATUS "========[ (${AIP_NAME}): Library type: ${AIP_TYPE}")
message(STATUS "========[ (${AIP_NAME}): Link TenniS: ${AIP_TENNIS}")
message(STATUS "========[ (${AIP_NAME}): Link OpenCV: ${AIP_OPENCV}")
message(STATUS "========[ (${AIP_NAME}): Build test: ${AIP_TEST}")

# add cmake sub script root
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# check SeetaAIP headers
find_package(Git QUIET)

if (GIT_FOUND)
    message(STATUS "========[ (${AIP_NAME}): Found git: ${GIT_EXECUTABLE}")
endif ()

set(AIP_GIT_NEW_CLONE OFF)
if (NOT EXISTS ${AIP_ROOT})
    if (GIT_FOUND)
        if ("${AIP_TAG}" STREQUAL "")
            message(STATUS "========[ (${AIP_NAME})<SeetaAIP>: git clone \"${AIP_GIT}\"")
            execute_process(
                    COMMAND ${GIT_EXECUTABLE} clone "${AIP_GIT}" "${AIP_ROOT}"
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
        else ()
            message(STATUS "========[ (${AIP_NAME})<SeetaAIP>: git clone \"${AIP_GIT}\" -b \"${AIP_TAG}\"")
            execute_process(
                    COMMAND ${GIT_EXECUTABLE} clone "${AIP_GIT}" "${AIP_ROOT}" -b "${AIP_TAG}"
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
        endif ()
        set(AIP_GIT_NEW_CLONE ON)
    else ()
        message(FATAL_ERROR "There is no folder .api and can not found git.")
    endif ()
endif ()

if (NOT EXISTS ${AIP_ROOT}/include)
    message(FATAL_ERROR "There exists folder .api, but no include header found in .api/include.")
endif ()

if (EXISTS ${AIP_ROOT}/.git
        AND AIP_UPDATE
        AND GIT_FOUND
        AND "${AIP_TAG}" STREQUAL ""
        AND NOT AIP_GIT_NEW_CLONE)
    message(STATUS "========[ (${AIP_NAME})<SeetaAIP>: git pull")
    execute_process(
            COMMAND ${GIT_EXECUTABLE} pull
            ERROR_QUIET
            WORKING_DIRECTORY ${AIP_ROOT})
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

# Find library
if (AIP_OPENCV)
    find_package(OpenCV REQUIRED)
endif ()

if (AIP_TENNIS)
    find_package(TenniS REQUIRED)
endif ()

# glob source files
FILE(GLOB_RECURSE ${PROJECT_NAME}_SOURCE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c
        )

FILE(GLOB_RECURSE ${PROJECT_NAME}_HEADER
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hh
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
        ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/include/*.hh
        ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h
        )

if (NOT ${PROJECT_NAME}_SOURCE)
    message(FATAL_ERROR "Can not found any source files in \"${CMAKE_CURRENT_SOURCE_DIR}/src\".")
endif()

add_library(${PROJECT_NAME}_LIB ${AIP_TYPE}
        ${${PROJECT_NAME}_SOURCE} ${${PROJECT_NAME}_HEADER})

target_include_directories(${PROJECT_NAME}_LIB
        PRIVATE ${AIP_ROOT}/include
        PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
        )

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
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
        FRAMEWORK DESTINATION framework
        )

if (AIP_TEST)
    FILE(GLOB_RECURSE ${PROJECT_NAME}_TEST_SOURCE
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.c
            )
    if (${PROJECT_NAME}_TEST_SOURCE)
        add_executable(${PROJECT_NAME}_TEST ${${PROJECT_NAME}_TEST_SOURCE})
        target_include_directories(${PROJECT_NAME}_TEST
                PRIVATE ${AIP_ROOT}/include
                PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
                )
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
