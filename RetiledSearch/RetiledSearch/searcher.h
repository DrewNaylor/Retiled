#ifndef SEARCHER_H
#define SEARCHER_H

#include <QObject>

class searcher : public QObject
{
    Q_OBJECT
public:
    explicit searcher(QObject *parent = nullptr);

signals:

public slots:
    void doSearch(QString searchTerm);

};

#endif // SEARCHER_H
