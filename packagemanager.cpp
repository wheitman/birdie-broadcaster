#include "packagemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QtGlobal>
#include <QSettings>

Package* packageManager::mCurrentPackage = new Package("NULL");

packageManager::packageManager(QObject *parent) : QObject(parent)
{
    checkDirectory();
    mDirectory = QDir(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages");
    resetPackages();
    defaultExtension = ".bpak";
}

void packageManager::resetPackages(){
    mPackages.clear(); //start fresh
    QStringList filenameList = getPackageFilenames();
    for(int i = 0; i<filenameList.length(); i++){
        mPackages.append(new Package(filenameList.at(i)));
    }
    defaultExtension = ".bpak";
}

void packageManager::addPackage(QString fileName){
    if (!fileName.endsWith(".bpak")){
        mPackages.append(new Package(fileName+".bpak"));
        qWarning("packageManager: Invalid file name. Attempting to fix...");
    }
    else
        mPackages.append(new Package(fileName));
}

bool packageManager::removePackage(QString fileName){
    for(int i=0; i<mPackages.length();i++){
        if(mPackages.at(i)->getPackageFileName()==fileName){
            mPackages.at(i)->remove();
            mPackages.removeAt(i);
            return true;
        }
    }
    return false;
}

void packageManager::checkDirectory(){
    //qInfo("Package Manager is checking the package directory");
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
    return mCurrentPackage->getPackageFileName();
}

void packageManager::initSettings(){
    QSettings settings("Heitman","Birdie Broadcaster");
    settings.setValue("packageRoot",mDirectory.absolutePath());
}

Package* packageManager::getCurrentPackage(){
    return mCurrentPackage;
}

void packageManager::setCurrentPackage(QString fileName){
    mCurrentPackage = new Package(fileName);
    emit currentPackageNameChanged();
}
