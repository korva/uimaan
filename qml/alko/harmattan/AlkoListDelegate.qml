import QtQuick 1.1

Item {
    height: nameText.height + addressText.height + 12
    width: parent.width
    Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: marea.pressed ? 0.3 : 0.0
        radius: 6
    }

    Text {
        id: nameText
        anchors { left: parent.left; leftMargin: 6 ; top: parent.top; topMargin: 4 }
        text: name
        font.family: "Nokia Pure Text"
        //font.pointSize: 22
        font.pixelSize: 30
        color: "black"
        elide: Text.ElideRight
    }

    Text {
        id: addressText
        anchors { left: parent.left; leftMargin: 10 ; top: nameText.bottom; topMargin: -4 }
        text: address
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
            nearest = false;
            alko.selectAlko(index)
            if(!alko.positionFound) alkoSelectedWithoutLocation = true
            pageStack.pop()
        }
    }
}
