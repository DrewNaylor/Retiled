#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "searcher.h"


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
    searcher *Searcher = new searcher;

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Connect the Searcher as a context property.
    engine.rootContext()->setContextProperty("searcher", Searcher);

    const QUrl url(u"qrc:/untitled/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
