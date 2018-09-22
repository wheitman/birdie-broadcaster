#ifndef PACKAGEMANAGER_H
#define PACKAGEMANAGER_H

#include <QObject>
#include <QDir>
#include "package.h"

class packageManager : public QObject
{
    Q_OBJECT
public:
    explicit packageManager(QObject *parent = nullptr);
    QDir getDirectory() const {return mDirectory;}
    QString getDirectoryPath() const {return mDirectory.absolutePath();}
    QString getFilePath(QString fileName) const {return mDirectory.absoluteFilePath(fileName);}
    QStringList getPackageFilenames();
    QString getCurrentPackageName();
    void setCurrentPackage(QString packageIp);
    void initSettings();
private:
    void checkDirectory();
    QDir mDirectory;

signals:

public slots:
};

#endif // PACKAGEMANAGER_H
