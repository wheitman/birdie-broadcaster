import QtQuick 2.0
import QtQuick.Controls.Material 2.2
import com.broadcaster.packagemanager 1.0

Rectangle {
    anchors.fill: parent
    signal packageChanged

    PackageManager {
        id: packageManager
        onCurrentPackageNameChanged: console.log("YEET")
    }

    onPackageChanged: {
        title.text = packageManager.currentPackageName
    }

    Rectangle{
        color: Material.color(Material.Teal)
        width: parent.width
        height: 50

        Text{
            id: title
            text: packageManager.currentPackageName
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
