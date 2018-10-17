import QtQuick 2.11
import QtQuick.Controls.Material 2.2
import com.broadcaster.packagemanager 1.0
import com.broadcaster.packagemanifest 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.2

Rectangle {
    anchors.fill: parent
    property color primaryColor: Material.color(Material.BlueGrey)
    property color accentColor: Material.color(Material.Teal)
    property var slideSources: ["ERROR"]

    color: Material.color(Material.BlueGrey, Material.Shade50)

    signal packageChanged

    PackageManager {
        id: packageManager
        //onCurrentPackageNameChanged: packageManifest.packageName = currentPackageName
    }

    onPackageChanged: {
        title.text = packageManager.currentPackageTitle.length>0 ? packageManager.currentPackageTitle : packageManager.currentPackageName
        slideSources = packageManager.currentSlideSources
    }

    onSlideSourcesChanged: {
//        var index = 0
//        var length = slideSources.length
//        var sources = slideSources.sort()
//        while(index<length){
//            console.log(sources[index])
//            slideOverviewList.model.append({slideSource:sources[index]})
//            index++
//        }
        console.log("Updating repeater with "+slideSources.length+" images.")
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

    function addSlideThumbnail(SlideSource){
        slideOverviewList.model.append({slideSource: SlideSource})
    }

    Rectangle{
        id: slideOverview
        anchors.left: parent.left
        anchors.right: parent.right
        height: 135
        anchors.top: titleRect.bottom
        color: Material.color(Material.BlueGrey, Material.Shade500)

        ScrollView{
            id: slideScroll
            anchors.fill: parent
            clip: true
            anchors.margins: 5

            Row{
                anchors.fill: parent
                spacing: 5
                Repeater{
                    model: slideSources[0]=="ERROR" ? 0 : slideSources.length
                    SlideThumbnail {
                        height: 125
                        width: height*16/9
                        source: slideSources[index]
                        async: true
                    }
                }
            }
        }
        RoundButton {
            Material.background: Material.color(Material.Teal, Material.ShadeA700)
            Material.foreground: "white"
            text: "+"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height/3
            width: height
            onClicked: slideFileDialog.open()
            ToolTip.visible: hovered
            ToolTip.text: "Add a slide to the package."
            ToolTip.delay: 600
        }
    }

    PackageManifest {
        id: packageManifest
        packageName: packageManager.getCurrentPackageName()
    }

    RoundButton{
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 80
        height: width
        icon.source: "qrc:icons/broadcast.svg"
        icon.color: "white"
        icon.width: 20
        icon.height: 40
        Material.background: accent
//        onClicked: {
//            console.log(packageManager.getCurrentPackageName())
//            console.log(packageManifest.slideNames[0])
//        }
    }

    FileDialog {
        id: slideFileDialog
        title: "Select the slides to add"
        folder: shortcuts.pictures
        selectMultiple: true
        onAccepted: {
            console.log(slideFileDialog.fileUrls)
            slideFileDialog.fileUrls.forEach(packageManager.addSlideToCurrent)
            slideSourcesChanged()
        }
    }

}
