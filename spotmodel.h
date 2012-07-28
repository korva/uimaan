#ifndef SPOTMODEL_H
#define SPOTMODEL_H

#include <QAbstractListModel>
#include "spot.h"
#include <qgeocoordinate.h>
#include <QFile>
#include <QTextStream>

QTM_USE_NAMESPACE

class SpotModel : public QAbstractListModel
{
    Q_OBJECT

    public:

    enum SpotRoles {
        NameRole = Qt::UserRole + 1,
        AddressRole
    };

    SpotModel();

    bool initialize(QString filename);

    void sortByLocation(QGeoCoordinate *location);
    void sortByName();

    // return Spot pointer at index
    Spot* spotAt(int index);

    // updates info if an Spot with same ID is found
    // updated fields: times, additional info
    void updateInfo(Spot *newInfo);

    // From QAbstractListModel
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;



    private:
    QList<Spot*> m_spots;

};

#endif // SPOTMODEL_H
