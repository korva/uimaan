import QtQuick 1.1

Item {
    height: titleText.height + bodyText.height
    width: parent.width

    property alias title: titleText.text
    property alias body: bodyText.text

    Rectangle {
        id: separator
        anchors { left: parent.left; leftMargin: 6 ; top: parent.top; topMargin: 0; right: parent.right; rightMargin: 6 }
        color: "grey"
        height: 1
    }

    Text {
        id: titleText
        anchors { left: parent.left; leftMargin: 6 ; top: separator.bottom; topMargin: 0; right: parent.right; rightMargin: 6 }
        text: address
        font.family: "Nokia Pure Text"
        //font.pointSize: 18
        font.pixelSize: 22
        color: "grey"
        elide: Text.ElideRight
    }

    Text {
        id: bodyText
        anchors { left: parent.left; leftMargin: 6 ; top: titleText.bottom; topMargin: -2; right: parent.right; rightMargin: 6 }
        text: name
        font.family: "Nokia Pure Text"
        //font.pointSize: 22
        font.pixelSize: 30
        color: "black"
        wrapMode: Text.WordWrap
    }

}
