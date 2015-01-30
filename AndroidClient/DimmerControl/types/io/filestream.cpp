#include "filestream.h"
#include <QFile>

FileStream::FileStream(QQuickItem *parent): QQuickItem(parent) {}

QString FileStream::read() {
    QFile file(p_source);
    QString content;

    if(file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        content = in.readLine();

        file.close();
        return content;
    }

    else
        return "";
}

bool FileStream::write(const QString &data) {
    QFile file(p_source);

    if(!file.open(QIODevice::WriteOnly))
        return false;

    QTextStream out(&file);
    out<<data;

    file.close();

    return true;
}

QString FileStream::source() const {
    return p_source;
}

void FileStream::setSource(QString &value) {
    if(p_source != value) {
        p_source = value;
         emit sourceChanged();
    }
}