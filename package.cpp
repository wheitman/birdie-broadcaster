#include "package.h"
#include "lib/quazip/JlCompress.h"

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
