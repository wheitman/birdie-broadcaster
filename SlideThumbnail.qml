import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    border.width: highlighted ? 2 : 1
    border.color: highlighted ? "white" : "#80000000"
    color: "transparent"
    width: height*16/9
    property string source;
    property bool async: true;
    property bool highlighted: false;
    signal deleteClicked()

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            highlighted = true;
            if (mouse.button === Qt.RightButton)
                contextMenu.popup()
        }
        Menu{
            id: contextMenu
            MenuItem {text: "Delete"; onClicked: {
                    deleteClicked()
                }
            }
        }
    }

    Image {
        id: thumbImg
        anchors.margins: parent.border.width
        anchors.fill: parent
        source: parent.source
        asynchronous: async
    }

    BusyIndicator {
        running: thumbImg.status == Image.Loading
        anchors.centerIn: parent
        height: parent.height/2
        width: height
    }

    Rectangle {
        height: 18
        width: parent.width
        anchors.bottom: parent.bottom
        color: "#80000000"
        Text {
            anchors.fill: parent
            text: source.split("/")[source.split("/").length-1]
            color: "white"
            clip: true
            font.pixelSize: 14
            anchors.leftMargin: 5
        }
    }
}
