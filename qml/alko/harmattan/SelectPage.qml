import QtQuick 1.1
import com.nokia.meego 1.0

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

        style: TabButtonStyle { }
        TabButton {
            id: nearestButton
            height: 50
            text: "Lähimmät"
            enabled: alko.positionFound

            onClicked: alko.sortByLocation()
        }
        TabButton {
            id: alphabeticallyButton
            height: 50
            text: "Aakkosittain"

            onClicked: alko.sortByName()
        }
    }

    ListView {
        id: alkoListView
        anchors { top: tabs.bottom; left: parent.left ; right: parent.right ; bottom: parent.bottom }
        spacing: 4
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
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
    }


}
