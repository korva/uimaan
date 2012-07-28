import QtQuick 1.1

Item {
    height: dayText.height + 12
    width: parent.width

    property alias day: dayText.text
    property alias time: timeText.text

    Rectangle {
        anchors { left: parent.left; leftMargin: 6 ; top: parent.top; right: parent.right; rightMargin: 6 }
        color: "grey"
        height: 1
    }

    Text {
        id: dayText
        anchors { left: parent.left; leftMargin: 6 ; right: timeText.left; rightMargin: 6; top: parent.top; topMargin: 4 }
        text: ""
        font.family: "Nokia Pure Text"
        //font.pointSize: 22
        font.pixelSize: 24
        color: "black"
        elide: Text.ElideRight
    }

    Text {
        id: timeText
        anchors { right: parent.right; rightMargin: 6 ; top: parent.top; topMargin: 4 }
        width: 100
        text: ""
        font.family: "Nokia Pure Text"
        //font.pointSize: 22
        font.pixelSize: 24
        color: "black"

    }


}
