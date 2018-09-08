#ifndef TVMANAGER_H
#define TVMANAGER_H

#include <QObject>
#include <QDir>

class tvManager : public QObject
{
    Q_OBJECT
public:
    explicit tvManager(QObject *parent = nullptr);
    QStringList getTvList();
    QDir getTvPath();
    void addTv(QString name, QString ip);
private:

};

#endif // TVMANAGER_H
