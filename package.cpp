#include "package.h"
#include "lib/quazip/JlCompress.h"
#include <QDir>

Package::Package(QString fileName){
    mPackageFileName = fileName;
}

Package::Package(QString fileName, QString title){
    mPackageFileName = fileName;
    mPackageTitle = title;
}

void Package::open(){
    JlCompress::extractDir(manager.getDirectoryPath()+"/"+mPackageFileName,manager.getDirectoryPath()+"/"+mPackageFileName.split(".").first());
}

void Package::close(){
    if(!isOpened()){
        qWarning("Package: cannot close an unopen package.");
    }
    QDir().remove(manager.getDirectoryPath()+"/"+mPackageFileName); //delete the old bpak
    JlCompress::compressDir(manager.getDirectoryPath()+"/"+mPackageFileName,manager.getDirectoryPath()+"/"+mPackageFileName.split(".").first()); //create a new bpak
    QDir(manager.getDirectoryPath()+"/"+mPackageFileName.split(".").first()).removeRecursively(); //remove the temporary directory
}

bool Package::isOpened(){
    return QDir(manager.getDirectoryPath()+"/"+mPackageFileName.split(".").first()).exists();
}
