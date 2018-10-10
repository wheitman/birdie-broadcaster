#include "packagemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QtGlobal>
#include <QSettings>

Package* packageManager::mCurrentPackage;

packageManager::packageManager(QObject *parent) : QObject(parent)
{
    checkDirectory();
    mDirectory = QDir(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages");
    resetPackages();
    if(mPackages.isEmpty())
        packageManager::mCurrentPackage = new Package("NULL");
    else
        packageManager::mCurrentPackage = mPackages.first();
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

void packageManager::addPackage(QString fileName, QString title){
    if (!fileName.endsWith(".bpak")){
        mPackages.append(new Package(fileName+".bpak",title));
        qWarning("packageManager: Invalid file name. Attempting to fix...");
    }
    else
        mPackages.append(new Package(fileName,title));
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

QString packageManager::getPackageTitle(QString fileName){
    QSettings settings("Heitman","Birdie Broadcaster");
    return settings.value(fileName).toString();
}

QString packageManager::getCurrentPackageName(){
    return mCurrentPackage->getPackageFileName();
}

QString packageManager::getCurrentPackageTitle(){
    return mCurrentPackage->getPackageTitle();
}

QStringList packageManager::getCurrentSlideSources(){
    if(!mCurrentPackage->isOpened()){
        qWarning("Current package not already open. Opening...");
        mCurrentPackage->open();
    }
    QStringList slideSources = mCurrentPackage->getSlideFilenames();
    return slideSources;
}

void packageManager::setCurrentPackageTitle(QString title){
    mCurrentPackage->setPackageTitle(title);
    emit currentPackageTitleChanged();
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
