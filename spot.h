#ifndef SPOT_H
#define SPOT_H

#include <QObject>
#include <QTime>
#include <QGeoCoordinate>

QTM_USE_NAMESPACE

class Spot : public QObject
{
    Q_OBJECT

    //Q_PROPERTY(QString name READ name NOTIFY nameChanged)

public:
    Spot(QObject *parent = 0);

    bool operator<(const Spot *other ) const;

    enum spotSortMode {SortByName, SortByLocation};

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

    spotSortMode sortMode;

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

#endif // SPOT_H
