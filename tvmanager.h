#ifndef TVMANAGER_H
#define TVMANAGER_H

#include <QObject>

class tvManager : public QObject
{
    Q_OBJECT
public:
    explicit tvManager(QObject *parent = nullptr);
};

#endif // TVMANAGER_H
