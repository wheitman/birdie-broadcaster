#include "package.h"
#include "lib/quazip/JlCompress.h"
#include <QDir>

QSettings settings("Heitman","Birdie Broadcaster");

Package::Package(QString fileName){
    mPackageFileName = fileName;
    if(!QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName.toLatin1()).exists()){ //if the package file doesn't already exist
        QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the folder if it exists
        QDir().mkdir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a fresh package folder
        QFile manifest(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()+"/"+mPackageFileName.split(".").first().toLatin1()+".manifest"); //create the manifest in the package folder
        manifest.open(QFile::WriteOnly);
        manifest.close();
        close();
    }
}

Package::Package(QString fileName, QString title){
    mPackageFileName = fileName;
    mPackageTitle = title;
}

void Package::open(){
    JlCompress::extractDir(settings.value("packageRoot").toString()+"/"+mPackageFileName,settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first());
}

void Package::close(){
    if(!isOpened()){
        qWarning("Package: cannot close an unopen package.");
    }
    QDir().remove(settings.value("packageRoot").toString()+"/"+mPackageFileName); //delete the old bpak
    JlCompress::compressDir(settings.value("packageRoot").toString()+"/"+mPackageFileName,settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()); //create a new bpak
    QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the temporary directory
}

void Package::remove(){
    if(isOpened())
        close();
    QFile(settings.value("packageRoot").toString()+"/"+mPackageFileName).remove();
    qDebug("Removing "+mPackageFileName.toLatin1());
}

bool Package::isOpened(){
    return QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).exists();
}
