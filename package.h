#ifndef PACKAGE_H
#define PACKAGE_H

#include <QObject>

class Package : public QObject
{
    Q_OBJECT

public:
    Package();
    QString getPackageName() const {return mPackageName;}
private:
    QString mPackageName;
};

#endif // PACKAGE_H
