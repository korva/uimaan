import QtQuick 1.1

Item {
    height: nameText.height + bottleText.height + 12
    width: parent.width
    Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: marea.pressed ? 0.3 : 0.0
        radius: 6
    }

    Text {
        id: nameText
        anchors { left: parent.left; leftMargin: 6 ; right: priceText.left; rightMargin: 6; top: parent.top; topMargin: 4 }
        text: name
        font.family: "Nokia Pure Text"
        //font.pointSize: 22
        font.pixelSize: 30
        color: "black"
        elide: Text.ElideRight
    }

    Text {
        id: priceText
        anchors { right: parent.right; rightMargin: 6 ; top: parent.top; topMargin: 4 }
        width: 100
        text: price
        font.family: "Nokia Pure Text"
        //font.pointSize: 22
        font.pixelSize: 30
        color: "black"

    }



    Text {
        id: bottleText
        anchors { left: parent.left; leftMargin: 10 ; top: nameText.bottom; topMargin: -4 }
        text: bottle
        font.family: "Nokia Pure Text"
        //font.pointSize: 18
        font.pixelSize: 22
        color: "grey"
        elide: Text.ElideRight
    }

    MouseArea {
        id: marea
        anchors.fill: parent

        onClicked: {

            pageStack.push(Qt.resolvedUrl("ProductPage.qml"))
        }
    }
}
