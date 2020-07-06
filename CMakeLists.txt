#
# CMakeList for Standard Projects
#
# Author: Martin Bauernschmitt

cmake_minimum_required(VERSION 3.0.0)

# ---------------------------------------------------------
# Configuration

# Project information
project(project_name)

# Include functions
include(cmake/functions.cmake)

# Author information
set(COMPANY "Your Company")
set(AUTHOR  "Max Mustermann")
set(E_MAIL  "max.mustermann@mustermail.de")

# License information
set(LICENSE "BSD 3-clause")

# Enable building version.h
set(GENERATE_VERSION_HEADER ON)

message("--------------------------------------------------")
message("Project: ${PROJECT_NAME}")
message("")
message("Author:  ${AUTHOR}")
message("E-Mail:  ${E_MAIL}")
message("License: ${LICENSE}")
message("--------------------------------------------------")
message("")


# ---------------------------------------------------------
# Generator settings

# Set namespace
set(PROJECT_NS "project_name_ns")

# Generate class (Namespace, ModuleName, ClassName, Filename of class)
GENERATE_CLASS("${PROJECT_NS}" "my_module" "MyClass" "my_class")

# ---------------------------------------------------------
# Project settings 
# -- DO NOT EDIT --

# Include versioning
include(cmake/version.cmake)

# Config C and Cpp standards
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable compile commands json generation for clang
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ---------------------------------------------------------
# Generate files
# -- DO NOT EDIT --

# Generate license file
GENERATE_FILE("${PROJECT_NS}" "LICENSE" "cmake/templates" "src/../")

# Generate main file
GENERATE_FILE("${PROJECT_NS}" "main.cpp" "cmake/templates" "src")

# Generate main test file
GENERATE_FILE("${PROJECT_NS}" "unit_tests.cpp" "cmake/templates" "tests/src")

# Generate namespace detailed doxygen documentation file
configure_file(cmake/templates/project_details.dox.in docs/details/project_details.dox)
COPY_FILE("project_details.dox" build/docs/details/project_details.dox ${CMAKE_CURRENT_SOURCE_DIR}/docs/details)

# Generate launch.json for VSCode & copy it
configure_file(cmake/templates/launch.json.in .vscode/launch.json)
file(COPY build/.vscode/launch.json DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/.vscode)

# ---------------------------------------------------------
# Build project
# -- DO NOT EDIT 

# Setup executable name from project name
set(TARGET_NAME ${PROJECT_NAME})

# Set output directories
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/)

# Add source files
file(GLOB_RECURSE APP_SRCS src/*.c*)

# Add executable
add_executable(${TARGET_NAME} ${APP_SRCS})

# Set include directories
target_include_directories(
    ${TARGET_NAME} PUBLIC
    include
)

# ---------------------------------------------------------
# Testing
# -- DO NOT EDIT --

# Check if testing is enabled
if(BUILD_TESTS)
  add_subdirectory(tests)
endif()

