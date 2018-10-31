import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    border.width: 1
    border.color: "#80000000"
    color: "transparent"
    width: height*16/9
    property string source;
    property bool async: true;


    Image {
        id: thumbImg
        anchors.margins: 1
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
