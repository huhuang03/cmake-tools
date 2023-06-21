cmake_minimum_required(VERSION 3.12)

function(is_main_cmake_file IS_MAIN)
    get_filename_component(CURRENT_DIR "${CMAKE_CURRENT_LIST_DIR}" ABSOLUTE)
    get_filename_component(PROJECT_DIR "${CMAKE_SOURCE_DIR}" ABSOLUTE)

    if (CURRENT_DIR STREQUAL PROJECT_DIR)
        set(${IS_MAIN} TRUE PARENT_SCOPE)
    else()
        set(${IS_MAIN} FALSE PARENT_SCOPE)
    endif()
endfunction()

is_main_cmake_file(IS_MAIN_CMAKE)
if (IS_MAIN_CMAKE)
    project(cmake_tools)
endif()

include(PythonModule.cmake)
include(FindVcpkg.cmake)
include(BetterOpencvTarget.cmake)