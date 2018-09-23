#include "packagemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QtGlobal>
#include <QSettings>

packageManager::packageManager(QObject *parent) : QObject(parent)
{
    checkDirectory();
    mDirectory = QDir(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages");
    mCurrentPackage = new Package("NULL");
}

void packageManager::checkDirectory(){
    qInfo("Package Manager is checking the package directory");
    QDir dir(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages");
    if (!dir.exists()) {
        dir.mkpath(".");
        qInfo("Package Manager is creating the package directory.");
    }
}

QStringList packageManager::getPackageFilenames(){
    QStringList filenameList = QDir(getDirectoryPath()).entryList(QStringList() << "*.bpak", QDir::Files);
    return filenameList;
}

QString packageManager::getCurrentPackageName(){
    Package package("EXDEE");
    return package.getPackageFileName();
}

void packageManager::initSettings(){
    QSettings settings("Heitman","Birdie Broadcaster");
    settings.setValue("packageRoot",mDirectory.absolutePath());
}

Package* packageManager::getCurrentPackage(){
    return mCurrentPackage;
}
