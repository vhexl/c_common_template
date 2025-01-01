cmake_minimum_required(VERSION 3.20)

project(c_common_template)

# initialize git
if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/.git)
    execute_process(
        COMMAND git init
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        RESULT_VARIABLE git_init_result
    )
    if(git_init_result)
        message(FATAL_ERROR "Failed to initialize git repository")
    else()
        message(STATUS "Initialized git repository")
    endif()
endif()

# add unittest framework
if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/test/Unity)
    set(UNITTEST_FRAMEWORK_REPO https://github.com/ThrowTheSwitch/Unity.git)
    execute_process(
        COMMAND git submodule add ${UNITTEST_FRAMEWORK_REPO} test/Unity
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        RESULT_VARIABLE add_submodule_result
    )
    if(add_submodule_result)
        message(FATAL_ERROR "Failed to add submodule")
    else()
        message(STATUS "Added submodule")
    endif()
endif()

# create python virtual environment
if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/.venv/bin/python)
    find_package(Python3 COMPONENTS Interpreter)
    execute_process(
        COMMAND ${Python3_EXECUTABLE} -m venv ${CMAKE_CURRENT_LIST_DIR}/.venv
        RESULT_VARIABLE venv_result
    )
    if(venv_result)
        message(FATAL_ERROR "Failed to create virtual environment")
    else()
        message(STATUS "Created virtual environment")
    endif()
endif()

# install dependencies in virtual environment
if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/.git/hooks/pre-commit)
    set(ENV{VIRTUAL_ENV} ${CMAKE_CURRENT_LIST_DIR}/.venv)
    set(Python3_FIND_VIRTUALENV FIRST)
    unset(Python3_EXECUTABLE)
    find_package(Python3 COMPONENTS Interpreter)

    set(REQUIREMENTS_FILE ${CMAKE_CURRENT_LIST_DIR}/requirements.txt)

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

add_subdirectory(src/)

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include(CTest)
endif()
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME AND BUILD_TESTING)
    add_subdirectory(test)
endif()

# even commented it, coverage utils still works great
configure_file("./CTestCustom.cmake.in"
                ${CMAKE_BINARY_DIR}/CTestCustom.cmake
                @ONLY)
