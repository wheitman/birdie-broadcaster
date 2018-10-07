#ifndef PACKAGE_H
#define PACKAGE_H

#include <QObject>
#include <QSettings>
#include <QJsonObject>
#include <QJsonArray>

class Package : public QObject
{
    Q_OBJECT

public:
    Package(QString fileName);
    Package(QString fileName, QString title);
    QString getPackageFileName() const {return mPackageFileName;}
    QString getPackageTitle() const {return mPackageTitle;}
    void open();
    void close();
    void remove();
    bool isOpened();
    void updateManifest();
    QStringList getSlideFilenames();
private:
    QString getPackageFolderDirectory();
    QString mPackageFileName;
    QString mPackageTitle;
    QJsonArray mSlideArray;
};

#endif // PACKAGE_H
