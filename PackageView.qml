import QtQuick 2.0
import QtQuick.Controls.Material 2.2

Rectangle {
    anchors.fill: parent

    Rectangle{
        color: Material.color(Material.Teal)
        width: parent.width
        height: 50

        Text{
            text: "Package name here"
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            minimumPointSize: 16
            font.pointSize: 200
            fontSizeMode: Text.Fit
            anchors.fill: parent
            anchors.margins: 5
        }
    }
}
