#include "packagemanifest.h"

PackageManifest::PackageManifest(){

}

PackageManifest::PackageManifest(QString packageName)
{
    if(packageName.contains('.'))
        mPackageName = packageName.split('.').first(); //filter out file extensions
    else
        mPackageName = packageName;
    mManifestFile = new QFile(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages/"+packageName);
}

void PackageManifest::setPackageName(QString packageName){
    if(packageName.contains('.'))
        mPackageName = packageName.split('.').first(); //filter out file extensions
    else
        mPackageName = packageName;
    mManifestFile = new QFile(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first()+"/packages/"+packageName);
}

QStringList PackageManifest::getSlideNames(){
    QStringList slideNames;
    slideNames.append(mManifestFile->fileName());
    return slideNames;
}
