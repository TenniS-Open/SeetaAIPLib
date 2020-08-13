# FindConfig.cmake

# This config name
set(TCN TenniS)

# Set needed files
set(${TCN}_MARK_HEADER "api/tennis.h")
set(${TCN}_MARK_LIBRARY "tennis")
set(${TCN}_MARK_DEBUG "")
set(${TCN}_ARCH "" CACHE STRING "Give library arch in finding, empty for default.")
set(${TCN}_HOME "" CACHE STRING "Tell where headers and libraries are.")
mark_as_advanced(${TCN}_ARCH)

# =============== There are notices ================ #
# Set CMAKE_LIBRARY_ARCHITECTURE to find library in <prefix>/lib/<arch>.
# ENV_LIBRARY_DIR ENV_HEADER_DIR was set by Seeta Compilation Scripts
# =============== Above are notices ================ #

# Set tip paths
set(${TCN}_PATHS)
if (NOT "${${TCN}_HOME}" STREQUAL "")
    list(APPEND ${TCN}_PATHS "${${TCN}_HOME}")
endif()
list(APPEND ${TCN}_PATHS
        "${CMAKE_CURRENT_LIST_DIR}"
        "${CMAKE_CURRENT_LIST_DIR}/.."
        )
if (NOT "${${TCN}_DIR}" STREQUAL "")
    list(APPEND ${TCN}_PATHS
            "${${TCN}_DIR}"
            "${${TCN}_DIR}/.."
            )
endif()
if (NOT "${${TCN}_ROOT}" STREQUAL "")
    list(APPEND ${TCN}_PATHS
            "${${TCN}_ROOT}"
            "${${TCN}_ROOT}/.."
            )
endif()
list(APPEND ${TCN}_PATHS
        ENV ${TCN}_DIR
        ENV ${TCN}_ROOT
        )
# Set suffix
set(${TCN}_INCLUDE_SUFFIXES)
list(APPEND ${TCN}_INCLUDE_SUFFIXES
        include
        "${CMAKE_INSTALL_INCLUDEDIR}"
        "${ENV_HEADER_DIR}"
        )
set(${TCN}_LIB_SUFFIXES)
if (NOT "${${TCN}_ARCH}" STREQUAL "")
    list(APPEND ${TCN}_LIB_SUFFIXES
            "lib/${${TCN}_ARCH}"
            "${${TCN}_ARCH}/lib"
            "${${TCN}_ARCH}"
            )
endif()
list(APPEND ${TCN}_LIB_SUFFIXES
        lib
        "${CMAKE_INSTALL_LIBDIR}"
        "${ENV_LIBRARY_DIR}"
        )

find_library(${TCN}_LIBRARY_RELEASE
        NAMES ${${TCN}_MARK_LIBRARY}
        PATHS
            ${${TCN}_PATHS}
        PATH_SUFFIXES
            ${${TCN}_LIB_SUFFIXES}
        )

if ("${${TCN}_MARK_DEBUG}" STREQUAL "")
    if (${TCN}_LIBRARY_RELEASE)
        set(${TCN}_LIBRARY_DEBUG ${${TCN}_LIBRARY_RELEASE})
    else ()
        set(${TCN}_LIBRARY_DEBUG "${TCN}_LIBRARY_DEBUG-NOTFOUND")
    endif ()
else ()
    string(REGEX REPLACE "\(.*\)/\([^/]*\)" "\\1" ${TCN}_LIBRARY_RELEASE_HINT "${${TCN}_LIBRARY_RELEASE}")
    find_library(${TCN}_LIBRARY_DEBUG
            NAMES ${${TCN}_MARK_LIBRARY}${${TCN}_MARK_DEBUG}
            HINTS
                "${${TCN}_LIBRARY_RELEASE_HINT}"
            PATHS
                ${${TCN}_PATHS}
            PATH_SUFFIXES
                ${${TCN}_LIB_SUFFIXES}
            )
    unset(${TCN}_LIBRARY_RELEASE_HINT)
endif ()

find_path(${TCN}_INCLUDE_DIR
        NAMES ${${TCN}_MARK_HEADER}
        PATHS
            ${${TCN}_PATHS}
        PATH_SUFFIXES
            ${${TCN}_INCLUDE_SUFFIXES}
        )

if (NOT ${TCN}_INCLUDE_DIR OR
        NOT ${TCN}_LIBRARY_RELEASE OR
        NOT ${TCN}_LIBRARY_DEBUG)
    set(${TCN}_HINTS)
    if (${TCN}_INCLUDE_DIR)
        list(APPEND ${TCN}_HINTS
                "${${TCN}_INCLUDE_DIR}"
                "${${TCN}_INCLUDE_DIR}/..")
    endif ()
    if (${TCN}_LIBRARY_RELEASE)
        string(REGEX REPLACE "\(.*\)/\([^/]*\)" "\\1" ${TCN}_LIBRARY_HINT "${${TCN}_LIBRARY_RELEASE}")
        list(APPEND ${TCN}_HINTS
                "${${TCN}_LIBRARY_HINT}"
                "${${TCN}_LIBRARY_HINT}/..")
        unset(${TCN}_LIBRARY_HINT)
    endif ()
    if (${TCN}_LIBRARY_DEBUG)
        string(REGEX REPLACE "\(.*\)/\([^/]*\)" "\\1" ${TCN}_LIBRARY_HINT "${${TCN}_LIBRARY_DEBUG}")
        list(APPEND ${TCN}_HINTS
                "${${TCN}_LIBRARY_HINT}"
                "${${TCN}_LIBRARY_HINT}/..")
        unset(${TCN}_LIBRARY_HINT)
    endif ()
    if (NOT ${TCN}_INCLUDE_DIR)
        find_path(${TCN}_INCLUDE_DIR
                NAMES ${${TCN}_MARK_HEADER}
                HINTS
                    ${${TCN}_HINTS}
                PATH_SUFFIXES
                    ${${TCN}_INCLUDE_SUFFIXES}
                )
    endif()
    if (NOT ${TCN}_LIBRARY_RELEASE)
        find_library(${TCN}_LIBRARY_RELEASE
                NAMES ${${TCN}_MARK_LIBRARY}
                HINTS
                    ${${TCN}_HINTS}
                PATH_SUFFIXES
                    ${${TCN}_LIB_SUFFIXES}
                )
    endif()
    if (NOT ${TCN}_LIBRARY_DEBUG)
        find_library(${TCN}_LIBRARY_DEBUG
                NAMES ${${TCN}_MARK_LIBRARY}${${TCN}_MARK_DEBUG}
                HINTS
                    ${${TCN}_HINTS}
                PATH_SUFFIXES
                    ${${TCN}_LIB_SUFFIXES}
                )
    endif()
    unset(${TCN}_HINTS)
endif()

# delete temp vars
unset(${TCN}_PATHS)
unset(${TCN}_INCLUDE_SUFFIXES)
unset(${TCN}_LIB_SUFFIXES)

if (NOT ${TCN}_INCLUDE_DIR OR
        NOT ${TCN}_LIBRARY_RELEASE)
    if (NOT ${TCN}_INCLUDE_DIR)
        message(FATAL_ERROR "Could not find header ${${TCN}_MARK_HEADER}! Try to set ${TCN}_ROOT to the package root.")
    endif ()
    if (NOT ${TCN}_LIBRARY_RELEASE)
        message(FATAL_ERROR "Could not find library ${${TCN}_MARK_LIBRARY}! Try to set ${TCN}_ROOT to the package root.")
    endif ()
endif()
if (NOT ${TCN}_LIBRARY_DEBUG)
    message(WARNING "Could not find debug library ${${TCN}_MARK_LIBRARY}${${TCN}_MARK_DEBUG}, use ${${TCN}_MARK_LIBRARY} instead.")
endif ()

if ("${${TCN}_LIBRARY_RELEASE}" STREQUAL "${${TCN}_LIBRARY_DEBUG}")
    set(${TCN}_LIBRARY ${${TCN}_LIBRARY_RELEASE})
else ()
    set(${TCN}_LIBRARY
            debug ${${TCN}_LIBRARY_DEBUG}
            optimized ${${TCN}_LIBRARY_RELEASE}
            )
endif()

find_package(PackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(${TCN}
        FOUND_VAR
            ${TCN}_FOUND
        REQUIRED_VARS
            ${TCN}_LIBRARY
            ${TCN}_INCLUDE_DIR
        FAIL_MESSAGE
            "Could not find ${TCN}! Try to set ${TCN}_ROOT to the package root."
        )

if(${TCN}_FOUND)
    set(${TCN}_LIBRARIES ${${TCN}_LIBRARY})
    set(${TCN}_LIBS ${${TCN}_LIBRARY})
    set(${TCN}_INCLUDE_DIRS ${${TCN}_INCLUDE_DIR})
endif()
