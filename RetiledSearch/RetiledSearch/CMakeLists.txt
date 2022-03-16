cmake_minimum_required(VERSION 3.16)

project(retiledsearch VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(retiledsearch
    main.cpp
    searcher.cpp
    searcher.h
)

qt_add_qml_module(retiledsearch
    URI retiledsearch
    VERSION 1.0
    QML_FILES MainWindow.qml
)

target_compile_definitions(retiledsearch
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(retiledsearch
    PRIVATE Qt6::Quick)
