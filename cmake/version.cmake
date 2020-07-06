# 
# CMake Versioning with GIT
#
# Author: Martin Bauernschmitt

# This file checks if a release or a developmen version
# is build and automatically extracts the version number
# If no version number is set 0.0.0 is set as project version
# and it is tagged as a development build
#
# If a version number (tag) is available formatted as
# "vMajor.Minor.Patch" the version number will be
# extracted and used for version detection. Furthermore
# it is checked if a "clean" tagged version is build
# (release build). If the commit has is not equal than
# the last tag-hash the build is marked as development build

# ---------------------------------------------------------
# Pre-Checks

# Check if git is installed
find_program(GIT git)

# ---------------------------------------------------------
# Get version info

# Run "git describe --tag --match "v*"" to get
# current version
execute_process(
  COMMAND ${GIT} describe --tags --match "v*"
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_OUT  
  ERROR_QUIET
)

# Run "git describe --tags --dirty"
# To check for devel and dirty versions
execute_process(
  COMMAND ${GIT} describe --tags --dirty
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_DIRTY_OUT  
  ERROR_QUIET
)

# Run "git rev-parse --short HEAD" to get
# short commit hash
execute_process(
  COMMAND ${GIT} rev-parse --short HEAD
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_HASH_OUT
  ERROR_QUIET
)

# ---------------------------------------------------------
# Process version string of git
# Check if version is provided
#string(SUBSTRING <string> <begin> <length> <output variable>)
string(LENGTH "${GIT_OUT}" GIT_OUT_LENGTH)

# Check if version is available
if (${GIT_OUT_LENGTH} EQUAL 0)
  # If no version is found set version to 0.0.0
  set(GIT_OUT "v0.0.0")
  message(WARNING "Git detected no version!")
  set(GIT_TAG_FOUND NO)
else()
  set(GIT_TAG_FOUND YES)
endif()

# Tag is shown as followed "v1.3.4" = "MAJOR.MINOR.PATCH"

# Remove unnecessary parts of string (v, ., -)
string(REGEX REPLACE "[v.-]" " " VER_STR "${GIT_OUT}")

# Strip string to get separated version numbers
string(STRIP ${VER_STR} VER_STR)
separate_arguments(VER_STR)

# Extract version numbers from version string "MAJOR;MINOR;PATCH"
list(GET VER_STR 0 PROJECT_VERSION_MAJOR)
list(GET VER_STR 1 PROJECT_VERSION_MINOR)
list(GET VER_STR 2 PROJECT_VERSION_PATCH)

# ---------------------------------------------------------
# Process hash string of git

# Remove new line
string(REGEX REPLACE "[\n]" "" PROJECT_COMMIT_ID "${GIT_HASH_OUT}")

# ---------------------------------------------------------
# Check if current build is release or devel build

# Check if a tag was found -> if not this is not a release
# build
if(GIT_TAG_FOUND)
  # Build expected release string
  set(RELEASE_TAG_STR "v${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}\n")

  # Check if "git describe  --tags --dirty" outputs the expected release string "vX.Y.Z"
  # If the output of the command is not equal "-dirty-xyz..." is appended and it is a
  # development build (untaggged version)
  string(COMPARE EQUAL ${RELEASE_TAG_STR} ${GIT_DIRTY_OUT} RELEASE_BUILD)
else()
  # No tag available so it is a devel build
  set(RELEASE_BUILD NO)
endif()

# ---------------------------------------------------------
# Generate version variables

# Show information depending on build type
if(RELEASE_BUILD)
  # Create project version string
  set(PROJECT_VERSION_STR "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

  # Set release build to true "for version.h file"
  set(RELEASE_BUILD true)

  message(STATUS "Release-Build")
  message(STATUS "Project-Version: ${PROJECT_VERSION_STR}")

else()
  # Create project version string
  set(PROJECT_VERSION_STR "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}-devel-${PROJECT_COMMIT_ID}")

   # Set release build to true "for version.h file"
   set(RELEASE_BUILD false)

  message(STATUS "Devel-Build")
  message(STATUS "Project-Version: ${PROJECT_VERSION_STR}")
endif()

# ---------------------------------------------------------
# Config version.h file

# Check if version.h shall be generated
if(GENERATE_VERSION_HEADER)

  # Delete file
  file(REMOVE "include/${PROJECT_NAME}/version.h")

  # Generate version header
  GENERATE_FILE("${PROJECT_NS}" "version.h" "cmake/templates" "include/${PROJECT_NAME}")

endif()
