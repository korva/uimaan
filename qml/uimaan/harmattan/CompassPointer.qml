import QtQuick 1.1

Item {

    property int radius: 100
    property int angle: 0
    property alias running: timer.running
    property alias pointerX: pointer.x
    property alias pointerY: pointer.y


    Timer {
        id: timer
        interval: 50
        running: false
        repeat: true

        onTriggered: {
            pointer.pointerAngle = angle
            //if (pointer.pointerAngle >= 360) pointer.pointerAngle = 0
        }


    }


    Image {
        id: pointer
        source: "qrc:/pointer.png"
        width: 70
        height: 35

        property int pointerAngle: 0


        x: Math.cos(2 * Math.PI * angle / 360)*radius - width/2
        y: Math.sin(2 * Math.PI * angle / 360)*radius - height/2

        rotation: 90 + angle
    }



}
