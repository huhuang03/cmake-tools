find_package(Python REQUIRED COMPONENTS Interpreter)

set(PYTHON_EXECUTABLE ${Python_EXECUTABLE})

if(NOT DEFINED PYTHON_EXECUTABLE)
    if(DEFINED ENV{VIRTUAL_ENV})
        find_program(
                PYTHON_EXECUTABLE python
                PATHS "$ENV{VIRTUAL_ENV}" "$ENV{VIRTUAL_ENV}/bin"
                NO_DEFAULT_PATH)
    elseif(DEFINED ENV{CONDA_PREFIX})
        find_program(
                PYTHON_EXECUTABLE python
                PATHS "$ENV{CONDA_PREFIX}" "$ENV{CONDA_PREFIX}/bin"
                NO_DEFAULT_PATH)
    elseif(DEFINED ENV{pythonLocation})
        find_program(
                PYTHON_EXECUTABLE python
                PATHS "$ENV{pythonLocation}" "$ENV{pythonLocation}/bin"
                NO_DEFAULT_PATH)
    endif()
    if(NOT PYTHON_EXECUTABLE)
        unset(PYTHON_EXECUTABLE)
    endif()
endif()


function(execute_python COMMAND out)
    execute_process(
            COMMAND "${PYTHON_EXECUTABLE}" "-c" "${COMMAND}"
            OUTPUT_VARIABLE _OUTPUT_VARIABLE
            RESULT_VARIABLE RESULT
            ERROR_VARIABLE _PYTHON_ERROR_VALUE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if(RESULT EQUAL 0)
        set(${out} ${_OUTPUT_VARIABLE} PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Failed to execute shell command '${COMMAND}'. ${${VARIABLE_NAME}} ${_PYTHON_ERROR_VALUE}")
    endif()
endfunction()


set(PYTHON_MODULE_EXTENSION "")
execute_python("
import sysconfig as s
print(s.get_config_var('EXT_SUFFIX') or s.get_config_var('SO'));
" PYTHON_MODULE_EXTENSION)

set(PYTHON_MODULE_EXTENSION ${PYTHON_MODULE_EXTENSION} CACHE STRING "python module extension")

# python module 工具
function(py_add_module target_name module_name)
    # .cpython-311-darwin.so
    set_target_properties(${target_name} PROPERTIES SUFFIX "${PYTHON_MODULE_EXTENSION}")
    set_target_properties(${target_name} PROPERTIES OUTPUT_NAME "${module_name}")
endfunction()