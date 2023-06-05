#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::Widget)
{
    ui->setupUi(this);

    int *ptr = nullptr;
    *ptr = 10;
}

Widget::~Widget()
{
    delete ui;
}

