#ifndef ALKOMODEL_H
#define ALKOMODEL_H

#include <QAbstractListModel>
#include "alko.h"
#include <qgeocoordinate.h>
#include <QFile>
#include <QTextStream>

QTM_USE_NAMESPACE

class AlkoModel : public QAbstractListModel
{
    Q_OBJECT

    public:

    enum AlkoRoles {
        NameRole = Qt::UserRole + 1,
        AddressRole
    };

    AlkoModel();

    bool initialize(QString filename);

    void sortByLocation(QGeoCoordinate *location);
    void sortByName();

    // return Alko pointer at index
    Alko* alkoAt(int index);

    // updates info if an Alko with same ID is found
    // updated fields: times, additional info
    void updateInfo(Alko *newInfo);

    // From QAbstractListModel
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;



    private:
    QList<Alko*> m_alkos;

};

#endif // ALKOMODEL_H
