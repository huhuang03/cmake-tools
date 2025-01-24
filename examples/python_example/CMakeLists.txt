ensure_vcpkg()

# why you so stupid?
#find_package(Python3 3.11 COMPONENTS Development REQUIRED)
find_package(Python3 COMPONENTS Development REQUIRED)

add_executable(python_example main.cc)
#target_link_libraries(python_example PRIVATE Python3::Python)