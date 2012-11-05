import QtQuick 1.1
import com.nokia.meego 1.0
import SpotFinder 1.0
import SpotModel 1.0
import QtMobility.sensors 1.1
import "Storage.js" as Storage

PageStackWindow {
    id: appWindow

    // true id nearest spot is selected; false if user selects spot
    property bool nearest: true

    // true if compass is calibrated
    property bool compassEnabled: false
    property bool locationEnabledPermanently: false

    property real compassAzimuth: 0.0
    property real compassCalibrationLevel: 0.0
    property real compassCalibrationTreshold: 1.0

    // true when spot selected from list but no location available
    property bool spotSelectedWithoutLocation: false

    property string spotGreen: "#49b534"
    property string spotRed: "#E63D2C"

    Compass {
        id: compass
        active: true

        onReadingChanged: {

            compassAzimuth = reading.azimuth
            compassCalibrationLevel = reading.calibrationLevel
        }
    }

    // Model of spot locations
    // Used for ListViews and as parameter to SpotFinder
    SpotModel {
        id: spotModel
    }

    // SpotFinder: methods for interacting with database of spots
    SpotFinder {
        id: spot
        model: spotModel
        locationEnabled: locationEnabledPermanently // by default, don't allow location updates

        Component.onCompleted: {
            // get the location setting from persistent db
            Storage.initialize();
            locationEnabledPermanently = Storage.getSetting("locationEnabled");

            // show calib page first, then location setting if needed
            if(compassCalibrationLevel < compassCalibrationTreshold) pageStack.push(Qt.resolvedUrl("CalibrationPage.qml"))
            else {
                compassEnabled = true
                if (locationEnabledPermanently) pageStack.push(Qt.resolvedUrl("MainPage.qml"))
                else pageStack.push(Qt.resolvedUrl("LocationPage.qml"))
            }
        }

    }


}
