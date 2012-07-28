import QtQuick 1.1

Item {

    anchors { top: parent.top; right: parent.right; left: parent.left }
    height: 45

    property bool showSeparator: true
    property alias text: titleText.text

    Rectangle {
        anchors.fill: parent
        //color: "#E63D2C"
        color: "grey"
        opacity: 0.2
    }

    Text {
        id: titleText
        anchors { left: parent.left; leftMargin: 12; right: parent.right; verticalCenter: parent.verticalCenter}
        font.family: "Nokia Pure Text Light"
        //font.pointSize: 24
        font.pixelSize: 24
        color: "black"
        elide: Text.ElideRight
        text: ""
    }

    Rectangle {
        id: titleSeparator
        anchors { bottom: parent.bottom; left: parent.left; leftMargin: 6; right: parent.right; rightMargin: 6 }
        color: "grey"
        height: 1
        opacity: showSeparator ? 1.0 : 0.0
    }
}
