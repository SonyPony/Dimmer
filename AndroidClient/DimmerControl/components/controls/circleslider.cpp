#include "circleslider.h"
#include <QtMath>

CircleSlider::CircleSlider(QQuickItem *parent) :
    QQuickPaintedItem(parent)
{
}

void CircleSlider::paint(QPainter *painter)
{
    QPainterPath path;
    QRectF innerRect = boundingRect().adjusted(m_grooveWidth, m_grooveWidth, -m_grooveWidth, -m_grooveWidth);

    path.moveTo(boundingRect().center());
    path.arcTo(boundingRect(), 90, 180);
    path.moveTo(innerRect.center());
    path.arcTo(innerRect, 90, 180);

    painter->setRenderHint(QPainter::Antialiasing);
    painter->setPen(QPen(m_grooveColor));
    painter->setBrush(QBrush(m_grooveColor));
    painter->drawPath(path);
}


void CircleSlider::mouseMove(QPoint arg)
{
    m_data = atan2(arg.x() +x()+ width() / 2.0, arg.y() +y() + height() / 2.0);
    qDebug() << m_data / M_PI * 180;
}

QColor CircleSlider::grooveColor() const
{
    return m_grooveColor;
}

QColor CircleSlider::toggleColor() const
{
    return m_toggleColor;
}

qreal CircleSlider::data() const
{
    return m_data;
}

int CircleSlider::grooveWidth() const
{
    return m_grooveWidth;
}

void CircleSlider::setGrooveColor(QColor arg)
{
    if (m_grooveColor == arg)
        return;

    m_grooveColor = arg;
    emit grooveColorChanged(arg);
}

void CircleSlider::setToggleColor(QColor arg)
{
    if (m_toggleColor == arg)
        return;

    m_toggleColor = arg;
    emit toggleColorChanged(arg);
}

void CircleSlider::setData(qreal arg)
{
    if (m_data == arg)
        return;

    m_data = arg;
    emit dataChanged(arg);
}

void CircleSlider::setGrooveWidth(int arg)
{
    if (m_grooveWidth == arg)
        return;

    m_grooveWidth = arg;
    emit grooveWidthChanged(arg);
}
