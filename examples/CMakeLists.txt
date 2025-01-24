cmake_minimum_required(VERSION 3.14)

# I want debug where define method _find_package

add_subdirectory(.. cmake_tools)
ensure_vcpkg()

project(cmake-tools-examples)

add_subdirectory(python_example)