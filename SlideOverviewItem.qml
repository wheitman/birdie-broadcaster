import QtQuick 2.11

Rectangle {
    property string path
    property string name
    property string source
    color: "Gray"
    Image {
        source: parent.source
        Component.onCompleted: console.log(parent.source)
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 5
        fillMode: Image.PreserveAspectFit
    }
}
