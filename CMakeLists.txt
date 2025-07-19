cmake_minimum_required(VERSION 3.20)

project(c_common_template
        VERSION 0.0.1
        DESCRIPTION "A template project for C development"
        LANGUAGES C)

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(SRC_DIR ${ROOT_DIR}/src)
set(BUILD_DIR ${ROOT_DIR}/build)
set(VENV_DIR ${ROOT_DIR}/.venv)
set(TOOLS_DIR ${ROOT_DIR}/tools)

# set python virtual environment
set(ENV{VIRTUAL_ENV} ${VENV_DIR})
set(Python3_FIND_VIRTUALENV ONLY)
unset(Python3_EXECUTABLE)
find_package(Python3 COMPONENTS Interpreter)

# MSVC compiler definitions
if(CMAKE_C_COMPILER_ID MATCHES "MSVC")
    # add_compile_definitions(/w35045)
    add_compile_options(/wd5045)
endif()

add_custom_target(
    config ALL
    COMMAND ${Python3_EXECUTABLE} ${TOOLS_DIR}/kconfig/kconfig.py
    WORKING_DIRECTORY ${ROOT_DIR}
    DEPENDS ${ROOT_DIR}/.config
    COMMENT "Generating configuration header"
)

add_custom_target(
    coverage
    COMMAND ${CMAKE_COMMAND} -E remove -f ${BUILD_DIR}/coverage.*
    COMMAND ${Python3_EXECUTABLE} -m gcovr
    WORKING_DIRECTORY ${ROOT_DIR}
    COMMENT "Generating code coverage report"
)

# add source directory
add_subdirectory(src/)

# add test
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include(CTest)
endif()
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND BUILD_TESTING)
    add_subdirectory(tests)
endif()
