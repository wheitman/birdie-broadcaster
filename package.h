#ifndef PACKAGE_H
#define PACKAGE_H

#include <QObject>
#include <QSettings>

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
    bool isOpened();
private:
    QString mPackageFileName;
    QString mPackageTitle;
};

#endif // PACKAGE_H
