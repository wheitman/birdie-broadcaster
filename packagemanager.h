#ifndef PACKAGEMANAGER_H
#define PACKAGEMANAGER_H

#include <QObject>

class packageManager : public QObject
{
    Q_OBJECT
public:
    explicit packageManager(QObject *parent = nullptr);
private:
    void checkDirectory();
signals:

public slots:
};

#endif // PACKAGEMANAGER_H
