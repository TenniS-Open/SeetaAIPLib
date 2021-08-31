# this file provide function to init and check module

# find git for function usage
find_package(Git QUIET)

if (GIT_FOUND)
    message(STATUS "========[ (${PROJECT_NAME}): Found git: ${GIT_EXECUTABLE}")
else ()
    execute_process(
        COMMAND git --version
        RESULT_VARIABLE if_failed)
    if (not if_failed)
        set(GIT_EXECUTABLE git)
        set(GIT_FOUND TRUE)
    endif ()
endif ()

function(git_checkout root tag)
    if (NOT GIT_FOUND)
        message(FATAL_ERROR "Can not found any git in environment.")
    endif ()

    execute_process(
            COMMAND ${GIT_EXECUTABLE} fetch
            WORKING_DIRECTORY "${root}")

    if (if_failed)
        message(WARNING "Git fetch failed, executable return ${if_failed}")
    endif ()

    execute_process(
            COMMAND ${GIT_EXECUTABLE} checkout "${tag}"
            WORKING_DIRECTORY "${root}"
            RESULT_VARIABLE if_failed)

    if (if_failed)
        message(WARNING "Can not find any branch or tag named ${tag}. git checkout return ${if_failed}")
        unset(if_failed)
        return()
    endif ()

    execute_process(
            COMMAND ${GIT_EXECUTABLE} pull origin ${tag}
            ERROR_QUIET
            WORKING_DIRECTORY "${root}")

    unset(if_failed)
endfunction()

function(add_submodule module path url tag)
    if (NOT GIT_FOUND)
        message(FATAL_ERROR "Can not found any git in environment.")
    endif ()
    if ("${tag}" STREQUAL "")
        message(STATUS "========[ (${PROJECT_NAME})<${module}>: git submodule add -f \"${url}\" \"${path}\"")
        execute_process(
                COMMAND ${GIT_EXECUTABLE} submodule add -f "${url}" "${path}"
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    else ()
        message(STATUS "========[ (${PROJECT_NAME})<${module}>: git submodule add -b ${tag} -f \"${url}\" \"${path}\"")
        execute_process(
                COMMAND ${GIT_EXECUTABLE} submodule add -b "${tag}" -f "${url}" "${path}"
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endif ()
endfunction()

# use_submodule(<name> <path> <url> <tag>)
function(use_submodule module path url tag)
    # if submodule not exist, add it.
    # else check submodule's tag if match.

    # if not git found or submodule init failed, fatal.
    # if tag not match, log warning

    # tag can be empty, means no tag given
    set(full_path  ${CMAKE_CURRENT_SOURCE_DIR}/${path})

    # check if path exist
    if (NOT EXISTS "${full_path}")
        # add submodule
        add_submodule("${module}" "${path}" "${url}" "${tag}")
    elseif (EXISTS "${full_path}/.git")
        # ok, there is submodule, check tag if match
        if (NOT "${tag}" STREQUAL "")
            message(STATUS "========[ (${PROJECT_NAME})<${module}>: git checkout ${tag}")
            git_checkout("${full_path}" "${tag}")
        endif()
    endif ()

    if (NOT EXISTS "${full_path}/.git")
        message(WARNING "There exists folder \"${path}\", but is not a git module.")
    endif()

    if (NOT EXISTS "${full_path}")
        message(FATAL_ERROR "Submodule ${module} init failed in ${path}.")
    endif ()

    unset(full_path)
endfunction()