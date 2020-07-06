#
# CMakeList for Standard Projects
#
# Author: Martin Bauernschmitt

# ---------------------------------------------------------
# Project settings 
# -- DO NOT EDIT --

message("")
message("--------------------------------------------------")
message("Config: ${PROJECT_NAME}-Unit-tests")
message("--------------------------------------------------")
message("")

# Check if GTest is installed
find_package(GTest REQUIRED)

# Enable compile commands json generation for clang
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Setup executable name from project name
set(TEST_TARGET_NAME "${PROJECT_NAME}-tests")

# Add source files

# Application sources
file(GLOB_RECURSE TEST_APP_SRCS  ../src/*.c*)

# Remove main.cpp
list(FILTER TEST_APP_SRCS EXCLUDE REGEX ".*main.cpp$")

message(STATUS "List: ${TEST_APP_SRCS}")

# Test sources
file(GLOB_RECURSE TEST_SRCS src/*.c*)

# Add executable
add_executable(${TEST_TARGET_NAME} ${TEST_APP_SRCS} ${TEST_SRCS})

# Set include directories
target_include_directories(
    ${TEST_TARGET_NAME} PUBLIC
    include
    ../include
)

# Link GTEST
target_link_libraries(${TEST_TARGET_NAME}
  PRIVATE GTest::GTest
  PRIVATE GTest::Main
)