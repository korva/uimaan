import QtQuick 1.1
import com.nokia.meego 1.0
import AlkoFinder 1.0
import AlkoModel 1.0
import QtMobility.sensors 1.1

PageStackWindow {
    id: appWindow

    // true id nearest Alko is selected; false if user selects Alko
    property bool nearest: true

    // true if compass is calibrated
    property bool compassEnabled: false

    property real compassAzimuth: 0.0
    property real compassCalibrationLevel: 0.0
    property real compassCalibrationTreshold: 1.0

    // true when Alko selected from list but no location available
    property bool alkoSelectedWithoutLocation: false

    property string alkoGreen: "#49b534"
    property string alkoRed: "#E63D2C"

    //initialPage: splashPage



    Compass {
        id: compass
        active: true

        onReadingChanged: {

            compassAzimuth = reading.azimuth
            compassCalibrationLevel = reading.calibrationLevel
            //console.log("calib: " + reading.calibrationLevel)

            //compassPointer.angle = -reading.azimuth + alko.azimuth + 270

//            headingText.text = reading.azimuth + " (" + reading.calibrationLevel + ")"
//            distanceDebugText.text = alko.distance + "m (" + alko.azimuth + ")"

        }
    }

    SplashPage {
        id: splashPage
    }


    AlkoModel {
        id: alkoModel
    }

    AlkoFinder {
        id: alko
        model: alkoModel

        Component.onCompleted: {
            console.log("init complete")
            if(compassCalibrationLevel < compassCalibrationTreshold) pageStack.push(Qt.resolvedUrl("CalibrationPage.qml"))
            else {
                compassEnabled = true
                pageStack.push(Qt.resolvedUrl("MainPage.qml"))
            }
        }

    }
}
