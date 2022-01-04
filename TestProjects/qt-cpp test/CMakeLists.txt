cmake_minimum_required(VERSION 3.16)

project(test2 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

qt_add_executable(test2
    main.cpp
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
