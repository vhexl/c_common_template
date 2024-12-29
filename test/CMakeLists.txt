cmake_minimum_required(VERSION 3.20)
project(test_template)

# Use unity config in unity_config.h
add_compile_definitions(UNITY_INCLUDE_CONFIG_H)

set(SOURCE_FILE_ALL
    ${CMAKE_CURRENT_LIST_DIR}/test.c
)

set(HEADER_FILE_ALL
    ${CMAKE_CURRENT_LIST_DIR}/
)

include_directories(${HEADER_FILE_ALL})

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/Unity)

add_executable(test_template ${SOURCE_FILE_ALL})  # add test source files here
 
target_link_libraries(test_template unity) # add other libraries

add_test(test_template test_template)
