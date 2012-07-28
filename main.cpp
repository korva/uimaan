#include <QtGui/QApplication>
#include "qdeclarative.h"
#include "qmlapplicationviewer.h"
#include "spotfinder.h"
#include <QDebug>
#include <QtDeclarative/QDeclarativeContext>
#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<SpotFinder>("SpotFinder", 1, 0, "SpotFinder");
    qmlRegisterType<SpotModel>("SpotModel", 1, 0, "SpotModel");

    QmlApplicationViewer viewer;

#if defined(MEEGO_EDITION_HARMATTAN) //|| defined(Q_WS_SIMULATOR)
    viewer.setMainQmlFile(QLatin1String("qml/uimaan/harmattan/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/uimaan/symbian/main.qml"));
#endif
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    viewer.showExpanded();

    return app.exec();
}


