import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.sensors 1.1

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait

    property int calibrationLevelInt: compassCalibrationLevel * 100

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

//    Titlebar {
//        id: titleBar
//        text: "Alkoon!"
//    }

    Image {
        id: logo
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        width: 300
        height: 300
        source: "qrc:/alkoon_logo.png"
        //opacity: compassCalibrationLevel

        Text {
            id: progressText
            color: alkoRed
            text: calibrationLevelInt + " %"
            font.pixelSize: 30
            anchors.bottom: logo.bottom
            anchors.bottomMargin: 25
            anchors.horizontalCenter: logo.horizontalCenter
            font.family: "Nokia Pure Text"
            horizontalAlignment: Text.AlignHCenter

            onTextChanged: {
                if(compassCalibrationLevel >= 1.0) {
                    compassEnabled = true
                    pageStack.push(Qt.resolvedUrl("MainPage.qml"))
                }
            }

        }

    }

    Text {
        id: helloText
        text: "Tervetuloa!"
        font.family: "Nokia Pure Text"
        anchors.top: logo.bottom
        anchors.topMargin: 6
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 30
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: instructionText
        text: "Että voisin opastaa sinut paremmin perille, kompassisi pitäisi kalibroida.\nPyörittele luuriasi ympäri hetki."
        font.family: "Nokia Pure Text"
        anchors.top: helloText.bottom
        anchors.topMargin: 2
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 24
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }

    Image {
        anchors.top: instructionText.bottom
        anchors.topMargin: 0
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: cancelButton.top
        anchors.bottomMargin: 6
        source: "qrc:/shake.png"
        fillMode: Image.PreserveAspectFit
    }

    Button {
        id: cancelButton
        anchors { bottom: parent.bottom; bottomMargin: 24; horizontalCenter: parent.horizontalCenter }
        text: "Älä käytä kompassia"

        onClicked: {
            compassEnabled = false
            pageStack.push(Qt.resolvedUrl("MainPage.qml"))
        }
    }


}
