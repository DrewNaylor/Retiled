cmake_minimum_required(VERSION 3.16)

project(test2 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(test2
    main.cpp
    searcher.cpp
    searcher.h
)

qt_add_qml_module(test2
    URI test2
    VERSION 1.0
    QML_FILES main.qml 
    QML_FILES MainWindow.qml
    QML_FILES ./pages/About.qml
)

target_compile_definitions(test2
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(test2
    PRIVATE Qt6::Quick)

# NOTE: When running this program, you need to
# have the working directory be the source directory.
# So what this means is, change the working directory
# in Qt Creator's Projects>Build & Run>Run page to
# be the folder that contains "main.cpp".
# On Linux, if the build directory is "./build",
# "cd" into the folder with "main.cpp", then do
# "./build/test2", or whatever the path to the
# executable is. Otherwise, Qt can't find the
# QML files correctly.
# There will be a script that handles the working
# directory properly in the future, and in fact,
# the plan is to install the compiled binaries
# in the same folders as the Python ones currently
# get copied to.
