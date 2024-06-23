cmake_minimum_required(VERSION 3.14)

add_subdirectory(.. cmake_tools)
ensure_vcpkg()

project(cmake-tools-examples)

th_config_system_python_dir()
find_package(Python3 REQUIRED COMPONENTS NumPy)