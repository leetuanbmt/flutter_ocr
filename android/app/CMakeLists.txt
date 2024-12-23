cmake_minimum_required(VERSION 3.6.0)

find_library(PADDLE_LIGHT_API_SHARED libpaddle_light_api_shared PATHS ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/paddle_light)
find_library(CPP_SHARED_LIB c++_shared PATHS ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/c++_shared)

# message(STATUS "OpenCV_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")
# # Define path variables
# set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
# set(LIB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lib)
# set(MODELS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/models)

# # Include header directories
# include_directories(${INCLUDE_DIR})

# # Add C++ source files
# set(SOURCES 
#     ${INCLUDE_DIR}/pipeline.h
#     ${INCLUDE_DIR}/cls_process.h
#     ${INCLUDE_DIR}/db_post_process.h
#     ${INCLUDE_DIR}/det_process.h
#     ${INCLUDE_DIR}/rec_process.h
#     ${INCLUDE_DIR}/utils.h
# )

# # Specify that the header files are C++ source files
# set_source_files_properties(
#     ${SOURCES}
#     PROPERTIES LANGUAGE CXX
# )

# # Create shared library libpipeline.so
# add_library(pipeline SHARED ${SOURCES})

# Link the libraries
# target_link_libraries(pipeline ${PADDLE_LIGHT_API_SHARED} ${CPP_SHARED_LIB})

# # Create the pipeline executable
# # add_executable(pipeline_executable ${LIB_DIR}/pipeline) # Assuming 'pipeline' is the main executable file
# # target_link_libraries(pipeline_executable pipeline) # Link with libpipeline.so

# # Copy models to the build directory
# # add_custom_command(TARGET pipeline_executable POST_BUILD
# #     COMMAND ${CMAKE_COMMAND} -E copy_directory
# #     ${MODELS_DIR}
# #     $<TARGET_FILE_DIR:pipeline_executable>/models)