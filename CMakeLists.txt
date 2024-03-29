cmake_minimum_required(VERSION 3.1)
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
# Output library version
set(AIP_VERSION "0.0.1")
# SeetaAIP API header store path
set(AIP_ROOT .api)
# SeetaAIP API header git
set(AIP_GIT https://github.com/TenniS-Open/SeetaAIP.git CACHE STRING "Git URL to clone SeetaAIP.")
# SeetaAIP API header tag
set(AIP_TAG "" CACHE STRING "Give git tag/branch. Set branch for check each time, tag for init first time.")
# Omega API header store path
set(OMEGA_ROOT .omega)
# Omega API header git
set(OMEGA_GIT https://github.com/TenniS-Open/omega.git CACHE STRING "Git URL to clone omega.")
# Omega API header tag
set(OMEGA_TAG "" CACHE STRING "Give git tag/branch. Set branch for check each time, tag for init first time.")
# ======================== Above are global options ========================== #
mark_as_advanced(AIP_TAG)
mark_as_advanced(OMEGA_TAG)

# ============================= Common flags ================================ #
set(PLATFORM "auto" CACHE STRING "auto, x86, x64, arm-*")
if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set(CONFIGURATION "Release")
else ()
    set(CONFIGURATION ${CMAKE_BUILD_TYPE})
endif ()
# ============================= Common flags ================================ #

# ======================== Those are local options ========================== #
option(AIP_OMEGA "[Optional] If include Omega." ON)
option(AIP_TENNIS "[Optional] If link TenniS." ON)
option(AIP_OPENCV "[Optional] If link OpenCV." OFF)
option(AIP_OPENMP "[Optional] If use OpenMP, used by image converting." OFF)
option(AIP_TEST "[Optional] If built test executable binary." OFF)
option(AIP_FAKE_TENNIS "[Optional] If link fake TenniS. Be carefully, it's only used for CI." OFF)
set(AIP_TYPE "SHARED" CACHE STRING "In SHARED or STATIC. Do ==NOT== Edit!")
# ======================== Above are local options ========================== #
mark_as_advanced(AIP_TYPE)

# Check if there is an fake option
if (AIP_FAKE_TENNIS)
    set(AIP_TENNIS OFF)
endif()

message(STATUS "========[ Configuring \"${AIP_NAME}\"")

message(STATUS "========[ (${AIP_NAME}): Platform: ${PLATFORM}")
message(STATUS "========[ (${AIP_NAME}): Configuration: ${CONFIGURATION}")

message(STATUS "========[ (${AIP_NAME}): Library type: ${AIP_TYPE}")
message(STATUS "========[ (${AIP_NAME}): Link TenniS: ${AIP_TENNIS}")
message(STATUS "========[ (${AIP_NAME}): Link OpenCV: ${AIP_OPENCV}")
message(STATUS "========[ (${AIP_NAME}): Build test: ${AIP_TEST}")
if (AIP_FAKE_TENNIS)
    message(STATUS "========[ (${AIP_NAME}): Link fake TenniS: ${AIP_FAKE_TENNIS}")
endif()

# add cmake sub script root
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# setup flags and env
include(LOCAL_FLAGS)
include(LOCAL_ENV)

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

if (WIN32)
elseif (ANDROID)
    link_libraries(log)
elseif (IOS)
    set(CMAKE_MACOSX_RPATH 1)
elseif (APPLE)
    set(CMAKE_MACOSX_RPATH 1)
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
    include(use_openmp)
    link_libraries("${OPENMP_LIBRARY}")
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

set_target_properties(${PROJECT_NAME}_LIB PROPERTIES
        BUILD_RPATH "$ORIGIN"
        INSTALL_RPATH "$ORIGIN")

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

if (AIP_FAKE_TENNIS)
    add_subdirectory(fake/tennis)
    target_include_directories(${PROJECT_NAME}_LIB PRIVATE ${FAKE_TENNIS_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME}_LIB ${FAKE_TENNIS_LIBS})
    set_target_properties(${PROJECT_NAME}_LIB PROPERTIES INSTALL_RPATH "$ORIGIN")
endif()

set_target_properties(${PROJECT_NAME}_LIB PROPERTIES OUTPUT_NAME ${AIP_NAME}${ENV_SUFFIX})
set_target_properties(${PROJECT_NAME}_LIB PROPERTIES
         RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${ENV_RUNTIME_DIR}"
         LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${ENV_LIBRARY_DIR}"
         ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${ENV_ARCHIVE_DIR}"
         )

include(strip)
if (ANDROID)
    STRIP_LIBRARY(${PROJECT_NAME}_LIB)
endif ()

# install now version aip headers
FILE(GLOB_RECURSE ${PROJECT_NAME}_AIP_HEADER
    ${CMAKE_CURRENT_SOURCE_DIR}/${AIP_ROOT}/include/*.hpp
    ${CMAKE_CURRENT_SOURCE_DIR}/${AIP_ROOT}/include/*.hh
    ${CMAKE_CURRENT_SOURCE_DIR}/${AIP_ROOT}/include/*.h
    )

# build ios framework
if (IOS)
    if ("${IOS_DEPLOYMENT_TARGET}" STREQUAL "")
        set(IOS_DEPLOYMENT_TARGET "9")
    endif()
    set_target_properties(${PROJECT_NAME}_LIB PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        MACOSX_FRAMEWORK_IDENTIFIER "top.leval.${PROJECT_NAME}"
        MACOSX_FRAMEWORK_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/template/Info.plist.in"
        # "current version" in semantic format in Mach-O binary file
        VERSION "${AIP_VERSION}"
        # "compatibility version" in semantic format in Mach-O binary file
        SOVERSION "${AIP_VERSION}"
        PUBLIC_HEADER "${${PROJECT_NAME}_AIP_HEADER}"
        XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
    )
    install(FILES ${${PROJECT_NAME}_AIP_HEADER}
            DESTINATION "framework/${PROJECT_NAME}.framework/Headers/aip")
    install(FILES ${${PROJECT_NAME}_PUBLIC_HEADER}
            DESTINATION "framework/${PROJECT_NAME}.framework/Headers")
endif()

install(FILES ${${PROJECT_NAME}_AIP_HEADER}
        DESTINATION ${ENV_HEADER_DIR}/aip)

# install aip library
install(TARGETS ${PROJECT_NAME}_LIB
        RUNTIME DESTINATION ${ENV_RUNTIME_DIR}
        LIBRARY DESTINATION ${ENV_LIBRARY_DIR}
        ARCHIVE DESTINATION ${ENV_ARCHIVE_DIR}
        FRAMEWORK DESTINATION framework
        )

install(FILES ${${PROJECT_NAME}_PUBLIC_HEADER}
        DESTINATION ${ENV_HEADER_DIR})

if (AIP_TEST)
    FILE(GLOB_RECURSE ${PROJECT_NAME}_TEST_SOURCE
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/test/*.c
            )
    LIST(LENGTH ${PROJECT_NAME}_TEST_SOURCE ${PROJECT_NAME}_TEST_NUMBER)

    foreach (path ${${PROJECT_NAME}_TEST_SOURCE})
        string(REGEX MATCH "[^/]*.[(c)|(cc)|(cpp)]$" file_ext ${path})
        string(REGEX MATCH "^[^.]*" file ${file_ext})

        if (${${PROJECT_NAME}_TEST_NUMBER} EQUAL 1)
            set(TEST_NAME ${PROJECT_NAME}_test)
        else()
            set(TEST_NAME ${PROJECT_NAME}_test_${file})
        endif()

        add_executable(${TEST_NAME} ${path})

        target_include_directories(${TEST_NAME}
                PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${AIP_ROOT}/include
                PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
                PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src
                )

        if (AIP_OMEGA)
            target_include_directories(${TEST_NAME}
                    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${OMEGA_ROOT}/include)
        endif()

        target_link_libraries(${TEST_NAME} ${PROJECT_NAME}_LIB)

        if (AIP_OPENCV AND OpenCV_FOUND)
            target_include_directories(${TEST_NAME} PRIVATE ${OpenCV_INCLUDE_DIRS})
            target_link_libraries(${TEST_NAME} ${OpenCV_LIBS})
        endif ()

        set_target_properties(${TEST_NAME} PROPERTIES OUTPUT_NAME ${TEST_NAME})
        set_target_properties(${TEST_NAME} PROPERTIES
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${ENV_RUNTIME_DIR}"
                LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${ENV_LIBRARY_DIR}"
                ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${ENV_ARCHIVE_DIR}"
                )

        unset(TEST_NAME)
    endforeach ()
endif()
