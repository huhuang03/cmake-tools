function(find_vcpkg_root VCPKG_ROOT)
    # check is linux
    if (UNIX)
        execute_process(
                COMMAND "which" "vcpkg"
                OUTPUT_VARIABLE _VCPKG_PATH
        )

        if (_VCPKG_PATH)
            get_filename_component(_VCPKG_ROOT _VCPKG_PATH DIRECTORY)
            set(VCPKG_ROOT _VCPKG_ROOT PARENT_SCOPE)
        endif ()
    endif()
endfunction()

macro(ensure_vcpkg)
    # 如何比较智能的选中vcpkg
    if (DEFINED ENV{VCPKG_ROOT})
        set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
    else ()
        find_vcpkg_root(VCPKG_ROOT)
        if (VCPKG_ROOT)
            set(VCPKG_ROOT "${VCPKG_ROOT}//scripts/buildsystems/vcpkg.cmake")
        else ()
            message(FATAL_ERROR "can't find vcpkg root")
        endif ()
    endif ()
endmacro()
