#include <QGuiApplication>
#include <QQmlApplicationEngine>


    // NOTE: When running this program, you need to
    // have the working directory be the source directory.
    // So what this means is, change the working directory
    // in Qt Creator's Projects>Build & Run>Run page to
    // be the folder that contains "main.cpp".
    // On Linux, if the build directory is "./build",
    // "cd" into the folder with "main.cpp", then do
    // "./build/appclean", or whatever the path to the
    // executable is. Otherwise, Qt can't find the
    // QML files correctly.
    // There will be a script that handles the working
    // directory properly in the future, and in fact,
    // the plan is to install the compiled binaries
    // in the same folders as the Python ones currently
    // get copied to.

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
