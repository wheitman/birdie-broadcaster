#ifndef PACKAGEMANAGER_H
#define PACKAGEMANAGER_H

#include <QObject>
#include <QDir>
#include "package.h"

class packageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPackageName READ getCurrentPackageName NOTIFY currentPackageNameChanged)
public:
    explicit packageManager(QObject *parent = nullptr);
    QDir getDirectory() const {return mDirectory;}
    QString getDirectoryPath() const {return mDirectory.absolutePath();}
    QString getFilePath(QString fileName) const {return mDirectory.absoluteFilePath(fileName);}
    Q_INVOKABLE QStringList getPackageFilenames();
    QString getCurrentPackageName();
    Package* getCurrentPackage();
    int count() const {return mPackages.length();}
    Q_INVOKABLE void setCurrentPackage(QString fileName);
    void initSettings();
    Q_INVOKABLE void resetPackages();
private:
    void checkDirectory();
    QDir mDirectory;
    Package *mCurrentPackage;
    QList<Package*> mPackages;
signals:
    void currentPackageNameChanged();
public slots:
};

#endif // PACKAGEMANAGER_H
