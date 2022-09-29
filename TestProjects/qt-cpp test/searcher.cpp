#include "searcher.h"
#include <QDebug>
#include <QDesktopServices>
#include <QUrl>

searcher::searcher(QObject *parent) : QObject{parent}
{

}

void searcher::openUrl(QString searchTerm) {

    // Runs a search on Bing for "Windows Phone".
    // I was lazy so I just looked at the SO
    // page for this even though I could've looked
    // for the docs:
    // https://stackoverflow.com/a/17896113
    // TODO: Escape the HTML.
    QDesktopServices::openUrl(QUrl("https://bing.com/?q=" + searchTerm));

}
