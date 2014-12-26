#ifndef CIRCLESLIDER_H
#define CIRCLESLIDER_H

#include <QQuickPaintedItem>
#include <QPainter>

class CircleSlider : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(QColor grooveColor READ grooveColor WRITE setGrooveColor NOTIFY grooveColorChanged)
    Q_PROPERTY(QColor toggleColor READ toggleColor WRITE setToggleColor NOTIFY toggleColorChanged)
    Q_PROPERTY(qreal data READ data WRITE setData NOTIFY dataChanged)
    Q_PROPERTY(int grooveWidth READ grooveWidth WRITE setGrooveWidth NOTIFY grooveWidthChanged)

    private:
        QColor m_grooveColor;
        QColor m_toggleColor;
        qreal m_data;
        int m_grooveWidth;

    public:
        explicit CircleSlider(QQuickItem *parent = 0);

        virtual void paint(QPainter *painter);

        QColor grooveColor() const;
        QColor toggleColor() const;
        qreal data() const;
        int grooveWidth() const;

    signals:
        void grooveColorChanged(QColor arg);
        void toggleColorChanged(QColor arg);
        void dataChanged(qreal arg);
        void grooveWidthChanged(int arg);

    public slots:
        void mouseMove(QPoint arg);

        void setGrooveColor(QColor arg);
        void setToggleColor(QColor arg);
        void setData(qreal arg);
        void setGrooveWidth(int arg);
};

#endif // CIRCLESLIDER_H
