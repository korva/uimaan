#include <QtGui/QApplication>
#include "qdeclarative.h"
#include "qmlapplicationviewer.h"
#include "alkofinder.h"
#include <QDebug>
#include <QtDeclarative/QDeclarativeContext>
#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<AlkoFinder>("AlkoFinder", 1, 0, "AlkoFinder");
    qmlRegisterType<AlkoModel>("AlkoModel", 1, 0, "AlkoModel");

    QmlApplicationViewer viewer;

#if defined(MEEGO_EDITION_HARMATTAN) //|| defined(Q_WS_SIMULATOR)
    viewer.setMainQmlFile(QLatin1String("qml/alko/harmattan/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/alko/symbian/main.qml"));
#endif
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    viewer.showExpanded();

    return app.exec();
}


