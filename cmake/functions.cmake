# 
# CMake Versioning with GIT
#
# Author: Martin Bauernschmitt

# This file is providing helper functions for the CMake
# project.

# ---------------------------------------------------------
# Functions
# -- DO NOT EDIT --

#
# Copy file function, which only copies files if they don't
# already exists at the destination
#
function(COPY_FILE FILENAME SOURCE DESTINATION)
  if(NOT EXISTS "${DESTINATION}/${FILENAME}")
    file(COPY ${SOURCE} DESTINATION ${DESTINATION})
  else()
    message(STATUS "File not copied because destination already exists ${DESTINATION}")
  endif()
endfunction()


#
# Function to generate class with header, source and test file
#
function(GENERATE_CLASS PROJECT_NS MODULE_NAME CLASS_NAME CLASS_NAME_FILE)

  # Set variables

  # Author identification
  set(GEN_AUTHOR  ${AUTHOR})
  set(GEN_MAIL    ${E_MAIL})
  set(GEN_COMPANY ${COMPANY})

  # Project identification
  set(GEN_PROJ ${PROJECT_NAME})
  set(GEN_PROJ_NS ${PROJECT_NS})

  # Module and class identification
  set(GEN_MODULE      ${MODULE_NAME})
  set(GEN_CLASS       ${CLASS_NAME})
  set(GEN_CLASS_FILE  ${CLASS_NAME_FILE})

  # Set date and time
  string(TIMESTAMP GEN_YEAR  "%Y")
  string(TIMESTAMP GEN_TODAY "%Y-%m-%d")

  # Generate file path
  set(GEN_DOX_PATH "docs/details")
  set(GEN_INC_PATH "include/${GEN_PROJ}/${GEN_MODULE}")
  set(GEN_SRC_PATH "src/${GEN_MODULE}")
  set(GEN_TEST_SRC_PATH "tests/src/${GEN_MODULE}")

  # Generate detailed documentation file
  configure_file(cmake/templates/module_details.dox.in ${GEN_DOX_PATH}/${GEN_MODULE}_details.dox)

  # Generate header file
  configure_file(cmake/templates/module_class.h.in ${GEN_INC_PATH}/${GEN_CLASS_FILE}.h)

  # Generate source file
  configure_file(cmake/templates/module_class.cpp.in ${GEN_SRC_PATH}/${GEN_CLASS_FILE}.cpp)

  # Generate test file
  configure_file(cmake/templates/module_class_tests.cpp.in ${GEN_TEST_SRC_PATH}/${GEN_CLASS_FILE}_tests.cpp)

  # Copy files
  COPY_FILE("${GEN_MODULE}_details.dox"   build/${GEN_DOX_PATH}/${GEN_MODULE}_details.dox ${CMAKE_CURRENT_SOURCE_DIR}/${GEN_DOX_PATH})
  COPY_FILE("${GEN_CLASS_FILE}.h"         build/${GEN_INC_PATH}/${GEN_CLASS_FILE}.h ${CMAKE_CURRENT_SOURCE_DIR}/${GEN_INC_PATH})
  COPY_FILE("${GEN_CLASS_FILE}.cpp"       build/${GEN_SRC_PATH}/${GEN_CLASS_FILE}.cpp ${CMAKE_CURRENT_SOURCE_DIR}/${GEN_SRC_PATH})
  COPY_FILE("${GEN_CLASS_FILE}_tests.cpp" build/${GEN_TEST_SRC_PATH}/${GEN_CLASS_FILE}_tests.cpp ${CMAKE_CURRENT_SOURCE_DIR}/${GEN_TEST_SRC_PATH})
  
endfunction()

#
# Function to generate class with header, source and test file
#
function(GENERATE_FILE PROJECT_NS FILENAME FILE_SRC_PATH FILE_DST_PATH)
   # Set variables

  # Author identification
  set(GEN_AUTHOR  ${AUTHOR})
  set(GEN_MAIL    ${E_MAIL})
  set(GEN_COMPANY ${COMPANY})

  # Project identification
  set(GEN_PROJ ${PROJECT_NAME})
  set(GEN_PROJ_NS ${PROJECT_NS})

  # Set date and time
  string(TIMESTAMP GEN_YEAR  "%Y")
  string(TIMESTAMP GEN_TODAY "%Y-%m-%d")

  configure_file(${FILE_SRC_PATH}/${FILENAME}.in ${FILE_DST_PATH}/${FILENAME})
  COPY_FILE(${FILENAME} build/${FILE_DST_PATH}/${FILENAME} ${CMAKE_CURRENT_SOURCE_DIR}/${FILE_DST_PATH})

endfunction()