cmake_minimum_required(VERSION 3.20)

set(SOURCE_FILE_ALL
    ${CMAKE_CURRENT_LIST_DIR}/main.c
)

set(HEADER_FILE_ALL
    ${CMAKE_CURRENT_LIST_DIR}/
)

# Library
add_library(library_template OBJECT)
target_sources(library_template PRIVATE ${SOURCE_FILE_ALL})
target_include_directories(library_template PUBLIC ${HEADER_FILE_ALL}/)

# Executable
# add_executable(executable_template ${SOURCE_FILE_ALL})

add_dependencies(library_template generate_config)
