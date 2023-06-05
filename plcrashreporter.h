#ifndef PLCRASHREPORTER_H
#define PLCRASHREPORTER_H

#include <QObject>

class plcrashreporter : public QObject
{
    Q_OBJECT
public:
    explicit plcrashreporter(QObject *parent = nullptr);

signals:

};

#endif // PLCRASHREPORTER_H
