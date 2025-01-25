# This find python python as the python lib
function(th_config_system_python_dir)
    find_program(PYTHON_EXECUTABLE python)
    get_filename_component(Python3_ROOT_DIR ${PYTHON_EXECUTABLE} DIRECTORY)
    set(Python3_ROOT_DIR ${Python3_ROOT_DIR} CACHE PATH "the python hint for FindPython3")

    set(manually_script_path "${Python3_ROOT_DIR}/Lib/site-packages")
    string(REPLACE "/" "\\\\" manually_script_path "${manually_script_path}")
    message("manually_script_path: ${manually_script_path}")

    set(_script "
import sys
sys.path.append(\"${manually_script_path}\")
import numpy
print(numpy.get_include())
")
    execute_process(
            COMMAND "${PYTHON_EXECUTABLE}" "-c" ${_script}
            OUTPUT_VARIABLE _OUTPUT_VARIABLE
            RESULT_VARIABLE RESULT
            ERROR_VARIABLE _ERROR_VARIABLE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message("_OUTPUT_VARIABLE: ${_OUTPUT_VARIABLE}")
    message("_ERROR_VARIABLE: ${_ERROR_VARIABLE}")
    set(Python3_NumPy_INCLUDE_DIR ${_OUTPUT_VARIABLE} CACHE INTERNAL "the numpy hint for FindPython3")
endfunction()

function(_debug_python_environ)
    set(manually_script_path "${Python3_ROOT_DIR}/Lib/site-packages")
    string(REPLACE "/" "\\\\" manually_script_path "${manually_script_path}")

    set(_script "
import sys
import os
sys.path.append(\"${manually_script_path}\")
print(sys.path)
")
    execute_process(
            COMMAND "${PYTHON_EXECUTABLE}" "-c" ${_script}
            OUTPUT_VARIABLE _OUTPUT_VARIABLE
            RESULT_VARIABLE RESULT
            ERROR_VARIABLE _PYTHON_ERROR_VALUE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    message("env: ${_OUTPUT_VARIABLE}")
endfunction()

function(init_python)
    th_config_system_python_dir()
    if (DEFINED CMAKE_TOOLS_PYTHON_INITED)
        return()
    endif ()
    if (NOT WIN32)
        message(FATAL_ERROR "for now, only work on windows")
    endif ()
    set(CMAKE_TOOLS_PYTHON_INITED true)
    find_package(Python REQUIRED COMPONENTS Interpreter)

    if (NOT DEFINED PYTHON_EXECUTABLE)
        if (DEFINED ENV{VIRTUAL_ENV})
            find_program(
                    PYTHON_EXECUTABLE python
                    PATHS "$ENV{VIRTUAL_ENV}" "$ENV{VIRTUAL_ENV}/bin"
                    NO_DEFAULT_PATH)
        elseif (DEFINED ENV{CONDA_PREFIX})
            find_program(
                    PYTHON_EXECUTABLE python
                    PATHS "$ENV{CONDA_PREFIX}" "$ENV{CONDA_PREFIX}/bin"
                    NO_DEFAULT_PATH)
        elseif (DEFINED ENV{pythonLocation})
            find_program(
                    PYTHON_EXECUTABLE python
                    PATHS "$ENV{pythonLocation}" "$ENV{pythonLocation}/bin"
                    NO_DEFAULT_PATH)
        endif ()
        if (NOT PYTHON_EXECUTABLE)
            unset(PYTHON_EXECUTABLE)
        endif ()
    endif ()

    function(execute_python COMMAND out)
        execute_process(
                COMMAND "${PYTHON_EXECUTABLE}" "-c" "${COMMAND}"
                OUTPUT_VARIABLE _OUTPUT_VARIABLE
                RESULT_VARIABLE RESULT
                ERROR_VARIABLE _PYTHON_ERROR_VALUE
                OUTPUT_STRIP_TRAILING_WHITESPACE
        )

        if (RESULT EQUAL 0)
            set(${out} ${_OUTPUT_VARIABLE} PARENT_SCOPE)
        else ()
            message(FATAL_ERROR "Failed to execute shell command '${COMMAND}'. ${${VARIABLE_NAME}} ${_PYTHON_ERROR_VALUE}")
        endif ()
    endfunction()


    set(PYTHON_MODULE_EXTENSION "")
    execute_python("
import sysconfig as s
print(s.get_config_var('EXT_SUFFIX') or s.get_config_var('SO'));
" PYTHON_MODULE_EXTENSION)

    set(PYTHON_MODULE_EXTENSION ${PYTHON_MODULE_EXTENSION} CACHE STRING "python module extension")
endfunction()

# python module 工具
function(py_add_module target_name module_name)
    init_python()
    set_target_properties(${target_name} PROPERTIES SUFFIX "${PYTHON_MODULE_EXTENSION}")
    set_target_properties(${target_name} PROPERTIES OUTPUT_NAME "${module_name}")
endfunction()