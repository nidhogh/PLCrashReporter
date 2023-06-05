#include "widget.h"

#include <QApplication>
#include "plcrashreporter.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    plcrashreporter plc;
    Widget w;
    w.show();
    return a.exec();
}
