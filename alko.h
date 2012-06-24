#ifndef ALKO_H
#define ALKO_H

#include <QObject>
#include <QTime>
#include <QGeoCoordinate>

QTM_USE_NAMESPACE

class Alko : public QObject
{
    Q_OBJECT

    //Q_PROPERTY(QString name READ name NOTIFY nameChanged)

public:
    Alko(QObject *parent = 0);

    bool operator<(const Alko *other ) const;

    enum alkoSortMode {SortByName, SortByLocation};

    bool initialize(QString data);

    QString name() const;
    QString address() const;
    QString postcode() const;
    QString city() const;
    QString phone() const;
    QString email() const;
    QString additionalInfo() const;
    QString storeId() const;
    qreal latitude() const;
    qreal longitude() const;
    qreal distance() const;

    void setDistance(qreal amount);

    QTime opens(int day) const;
    QTime closes(int day) const;

    alkoSortMode sortMode;

signals:
    void nameChanged();


private:

    QString m_name;
    QString m_address;
    QString m_postcode;
    QString m_city;
    QString m_phone;
    QString m_email;
    QString m_additionalInfo;
    QString m_storeId;
    qreal m_latitude;
    qreal m_longitude;
    qreal m_distance;

    QList<QTime> m_openingHours;
    QList<QTime> m_closingHours;

    void parseTime(QString time);




};

#endif // ALKO_H
