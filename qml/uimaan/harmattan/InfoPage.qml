import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: infoPage
    orientationLock: PageOrientation.LockPortrait
    tools: infoTools

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"
    }

    Titlebar {
        id: titleBar
        text: "Säätila"
    }

    Image {
        anchors { top: titleBar.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        fillMode: Image.Stretch
        source: "http://wwwi3.ymparisto.fi/i3/tilanne/fin/Lampotila/image/lampo.gif"
    }

    ToolBarLayout {
        id: infoTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
    }


}
