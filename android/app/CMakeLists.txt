cmake_minimum_required(VERSION 3.6.0)

include_directories(../include)

message(STATUS "OpenCV_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")

add_library(lib_opencv SHARED IMPORTED)

set_target_properties(lib_opencv PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libpipeline.so)

# # Define path variables
set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)

# # Add C++ source files
set(SOURCES 
    ${INCLUDE_DIR}/pipeline.h
    ${INCLUDE_DIR}/cls_process.h
    ${INCLUDE_DIR}/db_post_process.h
    ${INCLUDE_DIR}/det_process.h
    ${INCLUDE_DIR}/rec_process.h
    ${INCLUDE_DIR}/utils.h
)

message(STATUS "SOURCES: ${SOURCES}")


set_source_files_properties(
    ${SOURCES}
    PROPERTIES LANGUAGE CXX
)


add_library(pipeline SHARED ${SOURCES})

target_link_libraries(pipeline lib_opencv)