#ifndef PACKAGE_H
#define PACKAGE_H

#include <QObject>
#include <QSettings>
#include <QJsonObject>
#include <QJsonArray>

class Package : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString packageTitle READ getPackageTitle WRITE setPackageTitle NOTIFY packageTitleChanged)
public:
    Package(QString fileName);
    Package(QString fileName, QString title);
    QString getPackageFileName() const {return mPackageFileName;}
    QString getPackageTitle();
    void setPackageTitle(QString title);
    void open();
    void open(bool overwrite);
    void close();
    void remove();
    bool isOpened();
    void updateManifest();
    Q_INVOKABLE void addSlide(QString location);
    QStringList getSlideFilenames();
private:
    QString getPackageFolderDirectory();
    QString mPackageFileName;
    QString mPackageTitle;
    QJsonArray mSlideArray;
signals:
    void packageTitleChanged();
};

#endif // PACKAGE_H
