cmake_minimum_required(VERSION 3.20)
project(test_template)


set(SOURCE_FILE_ALL
    ${CMAKE_CURRENT_LIST_DIR}/test.c
)

set(HEADER_FILE_ALL
    ${CMAKE_CURRENT_LIST_DIR}/
)

include_directories(${HEADER_FILE_ALL})

set(CMAKE_POLICY_DEFAULT_CMP0077 NEW) # CMP0077 new behavior
set(UNITY_EXTENSION_MEMORY ON) # Enable unity memory extension
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/Unity)
add_compile_definitions(UNITY_INCLUDE_CONFIG_H) # Use unity_config.h

add_executable(test_template ${SOURCE_FILE_ALL}) # add test source files here
 
target_link_libraries(test_template unity) # add other libraries

add_test(test_template test_template)
