#include "package.h"
#include "lib/quazip/JlCompress.h"
#include <QDir>

QSettings settings("Heitman","Birdie Broadcaster");

Package::Package(QString fileName){
    mPackageFileName = fileName;
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

bool Package::isOpened(){
    return QDir(settings.value("packageRoot").toString()+"/"+mPackageFileName.split(".").first()).exists();
}
