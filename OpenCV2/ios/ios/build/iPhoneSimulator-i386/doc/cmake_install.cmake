# Install script for directory: /Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneSimulator-i386/install")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "Release")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/doc" TYPE FILE FILES
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/haartraining.htm"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/check_docs_whitelist.txt"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/CMakeLists.txt"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/license.txt"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/packaging.txt"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv.jpg"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/acircles_pattern.png"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv-logo-white.png"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv-logo.png"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv-logo2.png"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/pattern.png"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv2manager.pdf"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv2refman.pdf"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv_cheatsheet.pdf"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv_tutorials.pdf"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/opencv_user.pdf"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/doc/vidsurv" TYPE FILE FILES
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/vidsurv/Blob_Tracking_Modules.doc"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/vidsurv/Blob_Tracking_Tests.doc"
    "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/doc/vidsurv/TestSeq.doc"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")

