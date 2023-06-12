# this will find opencv as lib
# will create a target OpenCV::OpenCV
function(find_opencv_lib)
    set(EXPORT_NAME opencv)
    find_package(OpenCV REQUIRED)
    add_library(${EXPORT_NAME} INTERFACE)

    set_property(TARGET ${EXPORT_NAME} PROPERTY INTERFACE_LINK_LIBRARIES ${OpenCV_LIBS})
    set_property(TARGET ${EXPORT_NAME} PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${OpenCV_INCLUDE_DIRS})
#    target_link_directories(${EXPORT_NAME} INTERFACE ${OpenCV_INCLUDE_DIRS})
#    target_link_libraries(${LIB_NAEM} INTERFACE ${OpenCV_LIBS})

#     install(TARGETS OpenCV::OpenCV EXPORT OpenCVTargets)
endfunction()