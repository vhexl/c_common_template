cmake_minimum_required(VERSION 3.20)

project(c_common_template)

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(SRC_DIR ${ROOT_DIR}/src)
set(BUILD_DIR ${ROOT_DIR}/build)
set(GIT_DIR ${ROOT_DIR}/.git)
set(VENV_DIR ${ROOT_DIR}/.venv)
set(TOOLS_DIR ${ROOT_DIR}/tools)
set(TESTS_DIR ${ROOT_DIR}/tests)

set(REQUIREMENTS_FILE ${ROOT_DIR}/requirements.txt)

set(UNITTEST_FRAMEWORK_REPO https://github.com/ThrowTheSwitch/Unity.git)

# initialize git
if(NOT EXISTS ${ROOT_DIR}/.git)
    execute_process(
        COMMAND git init
        WORKING_DIRECTORY ${ROOT_DIR}
        RESULT_VARIABLE git_init_result
    )
    if(git_init_result)
        message(FATAL_ERROR "Failed to initialize git repository")
    else()
        message(STATUS "Initialized git repository")
    endif()
endif()

# add unittest framework
if(NOT EXISTS ${TESTS_DIR}/Unity)
    execute_process(
        COMMAND git submodule add ${UNITTEST_FRAMEWORK_REPO}
        WORKING_DIRECTORY ${TESTS_DIR}
        RESULT_VARIABLE add_submodule_result
    )
    if(add_submodule_result)
        message(FATAL_ERROR "Failed to add submodule")
    else()
        message(STATUS "Added submodule")
    endif()
endif()

# create python virtual environment
if(NOT EXISTS ${VENV_DIR}/bin/python)
    find_package(Python3 COMPONENTS Interpreter)
    execute_process(
        COMMAND ${Python3_EXECUTABLE} -m venv .venv
        WORKING_DIRECTORY ${ROOT_DIR}
        RESULT_VARIABLE venv_result
    )
    if(venv_result)
        message(FATAL_ERROR "Failed to create virtual environment")
    else()
        message(STATUS "Created virtual environment")
    endif()
endif()

# set python virtual environment
set(ENV{VIRTUAL_ENV} ${VENV_DIR})
set(Python3_FIND_VIRTUALENV FIRST)
unset(Python3_EXECUTABLE)
find_package(Python3 COMPONENTS Interpreter)

# install dependencies in virtual environment
if(NOT EXISTS ${GIT_DIR}/hooks/pre-commit)
    execute_process(
        COMMAND ${Python3_EXECUTABLE} -m pip install -r ${REQUIREMENTS_FILE}
        RESULT_VARIABLE pip_result
    )
    if(pip_result)
        message(FATAL_ERROR "Failed to install requirements.txt")
    else()
        message(STATUS "Installed requirements.txt")
    endif()
    execute_process(
        COMMAND ${Python3_EXECUTABLE} -m pre_commit install
        RESULT_VARIABLE precommit_result
      )
    if(precommit_result)
        message(FATAL_ERROR "Failed to install pre-commit hooks")
    else()
        message(STATUS "Installed pre-commit hooks")
    endif()
endif()


# MSVC compiler definitions
if(CMAKE_C_COMPILER_ID MATCHES "MSVC")
    # add_compile_definitions(/w35045)
    add_compile_options(/wd5045)
endif()

# add source directory
add_subdirectory(src/)

# add kconfig support
# add_custom_command(
#     OUTPUT ${BUILD_DIR}/.config ${BUILD_DIR}/config.h
#     COMMAND ${Python3_EXECUTABLE} ${TOOLS_DIR}/kconfig/kconfig.py
#     DEPENDS ${ROOT_DIR}/Kconfig
# )

add_custom_command(
    OUTPUT ${ROOT_DIR}/.config ${BUILD_DIR}/config.h
    COMMAND ${Python3_EXECUTABLE} ${TOOLS_DIR}/kconfig/kconfig.py
    WORKING_DIRECTORY ${ROOT_DIR}
)

add_custom_target(
    config ALL
    DEPENDS ${ROOT_DIR}/.config ${BUILD_DIR}/config.h
    COMMENT "Generating configuration"
)

# add test
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include(CTest)
endif()
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND BUILD_TESTING)
    add_subdirectory(tests)
endif()
