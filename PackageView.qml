import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import com.broadcaster.packagemanager 1.0
import QtQuick.Controls 1.4

Rectangle {
    anchors.fill: parent
    property color primaryColor: Material.color(Material.BlueGrey)
    property color accentColor: Material.color(Material.Teal)

    signal packageChanged

    PackageManager {
        id: packageManager
        onCurrentPackageNameChanged: console.log("YEET")
    }

    onPackageChanged: {
        title.text = packageManager.currentPackageTitle.length>0 ? packageManager.currentPackageTitle : packageManager.currentPackageName
    }

    Rectangle{
        color: Material.color(Material.Teal)
        width: parent.width
        height: 50
        id: titleRect

        Text{
            id: title
            text: "Package information unavailable."
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            minimumPointSize: 16
            font.pointSize: 200
            fontSizeMode: Text.Fit
            anchors.fill: parent
            anchors.margins: 5
        }
    }
    SplitView{
        id: contentSplit
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        orientation: Qt.Vertical

        Rectangle{
            id: slideOverview
            height: parent.height/4
            color: primaryColor
        }
        Rectangle{
            height: parent.height-slideOverview.height
        }
    }
}
