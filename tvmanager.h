#ifndef TVMANAGER_H
#define TVMANAGER_H

#include <QObject>
#include <QDir>

class tvManager : public QObject
{
    Q_OBJECT
public:
    explicit tvManager(QObject *parent = nullptr);
    Q_INVOKABLE QStringList getTvList();
    Q_INVOKABLE QStringList getIpList();
    Q_INVOKABLE QDir getTvPath();
    Q_INVOKABLE void addTv(QString name, QString ip);
private:

};

#endif // TVMANAGER_H
