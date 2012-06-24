import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: selectPage
    orientationLock: PageOrientation.LockPortrait
    tools: selectTools

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Titlebar {
        id: titleBar
        text: "Valitse myymälä"
        showSeparator: false
    }

    ButtonRow {
        id: tabs
        anchors { top: titleBar.bottom; left: parent.left ; right: parent.right }
        height: 50

        Button {
            id: nearestButton
            text: "Lähimmät"
            enabled: alko.positionFound
//            platformInverted: true

            onClicked: alko.sortByLocation()
        }
        Button {
            id: alphabeticallyButton
            text: "Aakkosittain"
//            platformInverted: true

            onClicked: alko.sortByName()
        }
    }

    ListView {
        id: alkoListView
        anchors { top: tabs.bottom; left: parent.left ; right: parent.right ; bottom: parent.bottom }
        spacing: 0
        clip: true
        model: alkoModel
        delegate: AlkoListDelegate { }
    }

    ScrollDecorator {
        id: decorator
        flickableItem: alkoListView
    }

    ToolBarLayout {
        id: selectTools
        visible: true
        ToolButton {
            iconSource: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
    }

    Image {
        id: topLeftCorner
        anchors { top: parent.top; left: parent.left }
        source: "qrc:/corner.png"
    }

    Image {
        id: topRightCorner
        anchors { top: parent.top; right: parent.right }
        source: "qrc:/corner.png"
        rotation: 90
    }





}
