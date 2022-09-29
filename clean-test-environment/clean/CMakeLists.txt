cmake_minimum_required(VERSION 3.20)

project(clean VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(appclean
    main.cpp
)

qt_add_qml_module(appclean
    URI clean
    VERSION 1.0
    QML_FILES main.qml 
)

set_target_properties(appclean PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_compile_definitions(appclean
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(appclean
    PRIVATE Qt6::Quick)

# NOTE: This commented-out block probably won't work the way
# I'm importing QML files, because Qt Creator says it's fine,
# but the program can't find the files when it runs.
# Maybe this is related to not having my QML files in a real
# module and just being in a folder, I don't know.
 
# Import RetiledStyles QML files.
# Change these paths in your CMakeCache as necessary.
# Got this code from:
# https://stackoverflow.com/a/62202304
# Directories where Qt Creator can find QML files.
# (Not needed for builds, but makes Qt Creator code completion happy.)
# Need to get the correct path:
# https://stackoverflow.com/a/66305778
# Actually, we need to run cmake_path as its own function:
# https://cmake.org/cmake/help/v3.20/command/cmake_path.html#get-parent-path
#set(sourcePath "${CMAKE_CURRENT_SOURCE_DIR}")
#cmake_path(GET sourcePath PARENT_PATH sourceParent)
#list(APPEND QML_IMPORT_PATH "${sourceParent}/styles")

## Prevent adding duplicate values at each run of CMake.
#list(REMOVE_DUPLICATES QML_IMPORT_PATH)

## The variable is cached in ${BUILD_DIR}/CMakeCache.txt. We need FORCE to
## change it there immediately. Also, add a comment to the cache file.
#set(QML_IMPORT_PATH ${QML_IMPORT_PATH}
#    CACHE STRING "Qt Creator 7.0.0 RetiledStyles import path"
#    FORCE
#)
