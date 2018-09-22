import QtQuick 2.0
import QtQuick.Controls.Material 2.2

Rectangle {
    property int primary: Material.BlueGrey
    property int accent: Material.Teal

    color: "transparent"//Material.color(primary, Material.Shade50)

    Image {
        id: broadcastImage
        source: "icons/broadcast.svg"
        anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
        fillMode: Image.PreserveAspectFit
        anchors.topMargin: parent.height*.3; anchors.bottomMargin: anchors.topMargin; anchors.leftMargin: anchors.topMargin/2
    }
    Text {
        id: broadcastText
        text: "<b>Welcome to <br>Birdie Broadcaster.</b><br>To get started, create or edit a package on the left."
        anchors.top: broadcastImage.top
        anchors.bottom: broadcastImage.bottom
        anchors.left: broadcastImage.right
        anchors.right: parent.right
        anchors.topMargin: broadcastImage.height/5
        anchors.bottomMargin: anchors.topMargin
        anchors.rightMargin: broadcastImage.anchors.leftMargin
        anchors.leftMargin: broadcastImage.anchors.leftMargin
        color: Material.color(primary)
        minimumPointSize: 24
        font.pointSize: 200
        fontSizeMode: Text.Fit
        wrapMode: Text.Wrap

    }
}
