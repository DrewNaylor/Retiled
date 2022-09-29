#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "searcher.h"

#include <QLocale>
#include <QTranslator>

#include <iostream>

int main(int argc, char *argv[])
{

    // Create a Searcher to use to run the search.
    // This isn't very good, because this is a pointer
    // and it could leak memory if it needs to be accessed
    // somewhere else, but I don't think we're doing that
    // here.
    // Both this line and the context property I took and
    // modified from this video, but it's basically
    // boilerplate:
    // https://www.youtube.com/watch?v=Nma3c3YxsUo
    searcher *searchClass = new searcher;

    std::cout << "yo\n";

    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "test2_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;

    // Connect the Searcher as a context property.
    engine.rootContext()->setContextProperty("searchClass", searchClass);

    const QUrl url(u"./MainWindow.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
