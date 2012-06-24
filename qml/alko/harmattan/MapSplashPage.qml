import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: mapSplashPage
    tools: mapSplashTools

    onStatusChanged: {
        if(status === PageStatus.Active) pageStack.replace(Qt.resolvedUrl("MapPage.qml"), { }, true)
    }

    Image {
        anchors.fill: parent
        source: "qrc:/paperbg.png"

    }

    ToolBarLayout {
        id: mapSplashTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()

        }

        ToolIcon {
            iconSource: "image://theme/icon-s-location-picker"

        }


        ToolIcon {
            iconSource: "image://theme/icon-s-common-drive"
        }


    }


}
