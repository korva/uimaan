import QtQuick 1.1
import com.nokia.meego 1.0
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
            //console.log("calib: " + reading.calibrationLevel)

            //compassPointer.angle = -reading.azimuth + spot.azimuth + 270

//            headingText.text = reading.azimuth + " (" + reading.calibrationLevel + ")"
//            distanceDebugText.text = spot.distance + "m (" + spot.azimuth + ")"

        }
    }

    SpotModel {
        id: spotModel
    }

    SpotFinder {
        id: spot
        model: spotModel
        locationEnabled: false // by default, don't allow location updates

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
