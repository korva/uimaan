import QtQuick 1.1
import com.nokia.symbian 1.1
import SpotFinder 1.0
import SpotModel 1.0
import QtMobility.sensors 1.1

PageStackWindow {
    id: appWindow

    // true id nearest spot is selected; false if user selects spot
    property bool nearest: true

    // true if compass is calibrated
    property bool compassEnabled: false

    property real compassAzimuth: 0.0
    property real compassCalibrationLevel: 0.0
    property real compassCalibrationTreshold: 1.0

    // true when spot selected from list but no location available
    property bool spotSelectedWithoutLocation: false

    property string spotGreen: "#49b534"
    property string spotRed: "#E63D2C"

    //initialPage: splashPage




    Compass {
        id: compass
        active: true

        onReadingChanged: {

            compassAzimuth = reading.azimuth
            compassCalibrationLevel = reading.calibrationLevel

        }
    }

//    SplashPage {
//        id: splashPage
//    }


    SpotModel {
        id: spotModel
    }

    SpotFinder {
        id: spot
        model: spotModel

        Component.onCompleted: {
            console.log("init complete")
            if(compassCalibrationLevel < compassCalibrationTreshold) pageStack.push(Qt.resolvedUrl("CalibrationPage.qml"))
            else {
                compassEnabled = true
                pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
        }

    }

    Image {
        id: bottomLeftCorner
        anchors { bottom: parent.bottom; left: parent.left }
        source: "qrc:/corner.png"
        rotation: -90
    }

    Image {
        id: bottomRightCorner
        anchors { bottom: parent.bottom; right: parent.right }
        source: "qrc:/corner.png"
        rotation: 180
    }

}
