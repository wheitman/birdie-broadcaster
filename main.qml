import QtQuick 2.11
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

import com.broadcaster.tvmanager 1.0

ApplicationWindow {
    visible: true

    width: 1280
    height: 720

    property int accent: Material.Teal
    property int primary: Material.BlueGrey

    Material.theme: Material.Light
    Material.primary: primary
    Material.accent: accent

    TvManager {
        id: tvManager
    }

    Timer {
        id: refreshTimer
        interval: 60000 //refresh every minute
        onTriggered: tvListView.refresh()
        running: true
        repeat: true
    }

    Dialog {
        id: canaryDialog
        height: 400
        width: 600
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Canary Alert")
        background: Rectangle{
            anchors.fill: parent
            color: Material.color(Material.Yellow)
        }
        header.visible: false

        Label {
            text: "What kind of alert would you like to send?"
        }
        ColumnLayout{
            Button {
                Layout.minimumWidth: canaryDialog.width/2
                text: "General"
                onClicked: alertConfirmation.open()
                Material.foreground: Material.Yellow
                Material.background: "Black"
                Layout.alignment: Qt.AlignHCenter
            }
            Button {
                Layout.minimumWidth: canaryDialog.width/2
                text: "Weather"
                onClicked: alertConfirmation.open()
                Material.foreground: Material.Yellow
                Material.background: "Black"
                Layout.alignment: Qt.AlignHCenter
            }
            Button {
                Layout.minimumWidth: canaryDialog.width/2
                text: "Fire"
                onClicked: alertConfirmation.open()
                Material.foreground: Material.Yellow
                Material.background: "Black"
                Layout.alignment: Qt.AlignHCenter
            }
            Button {
                Layout.minimumWidth: canaryDialog.width/2
                text: "Chemical"
                onClicked: alertConfirmation.open()
                Material.foreground: Material.Yellow
                Material.background: "Black"
                Layout.alignment: Qt.AlignHCenter
            }
            Button {
                Layout.minimumWidth: canaryDialog.width/2
                text: "Violence"
                onClicked: alertConfirmation.open()
                Material.foreground: Material.Yellow
                Material.background: "Black"
                Layout.alignment: Qt.AlignHCenter
            }
            Button {
                text: "Cancel"
                onClicked: canaryDialog.reject()
                Layout.alignment: Qt.AlignHCenter
                Layout.minimumWidth: canaryDialog.width/2
            }

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }
        modal: true
    }

    Dialog {
        id: alertConfirmation
        height: 400
        width: 600
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Canary Alert")
        background: Rectangle{
            anchors.fill: parent
            color: Material.color(Material.Yellow)
        }
        header.visible: false
        Label{
            text: "This will broadcast a Canary alert across campus. Are you sure?"
        }
        RowLayout{
            anchors.centerIn: parent
            anchors.bottom: parent.bottom
            Button {
                id: alertConfirm
                onClicked: {
                    canaryDialog.close()
                    alertConfirmation.accept()
                }
                text: "Send Alert"
            }
            Button {
                text: "Cancel"
                onClicked: {
                    canaryDialog.close()
                    alertConfirmation.reject()
                }
            }
        }
    }

    Dialog {
        id: addTvDialog
        height: 400
        width: 600
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        title: qsTr("Add a TV")

        ColumnLayout{
            anchors.centerIn: parent
            anchors.left: parent.left
            anchors.right: parent.right
            TextField {
                id: nameField
                placeholderText: "Name (i.e. \"Main entrance\")"
            }
            TextField {
                id: ipField
                placeholderText: "IP address (i.e. \"192.168.1.240\")"
            }
        }
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            tvManager.addTv(nameField.text,ipField.text)
            nameField.clear()
            ipField.clear()
            tvListView.updateTvModel()
        }
        onRejected: {
            nameField.clear()
            ipField.clear()
        }
    }

    FileDialog {
        id: slideFileDialog
        title: "Select the slides to add"
        folder: shortcuts.pictures
        selectMultiple: true
        onAccepted: {
            console.log(slideFileDialog.fileUrls)
        }
    }

    SplitView{
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle{
            id: sidebar
            width: parent.width/4
            color: Material.color(primary,Material.Shade50)

            SplitView{
                anchors.fill: parent
                anchors.bottom: sidebarOptions.top
                property int bottomPadding: 0
                orientation: Qt.Vertical
                PackageListView{
                    id: packageListView
                    height: parent.height/3
                    width: parent.width
                    onHighlightedChanged: {
                        if(packageListView.highlighted===true)
                            tvListView.highlighted = false
                    }
                    accentColor: Material.color(accent, Material.Shade100)
                    primaryColor: Material.color(accent)
                    title: "PACKAGES"
                    onAddButtonClicked: slideFileDialog.open()
                }
                TvListView{
                    anchors.top: packageListView.bottom
                    id: tvListView
                    height: parent.height/3
                    width: parent.width
                    onHighlightedChanged: {
                        if(tvListView.highlighted===true)
                            packageListView.highlighted=false
                    }

                    accentColor: Material.color(accent)
                    primaryColor: Material.color(accent)
                    title: "TVs"
                    bottomPadding: sidebarOptions.height
                    onAddButtonClicked: addTvDialog.open()
                }
            }
            Rectangle{
                id: sidebarOptions
                color: Material.color(primary)
                anchors.bottom: parent.bottom
                height: (parent.height/20)<canaryButton.implicitHeight ? canaryButton.implicitHeight : parent.height/20
                width: parent.width
                Button {
                    id: canaryButton
                    text: "Canary"
                    anchors.centerIn: parent
                    Material.background: Material.Yellow
                    onClicked: canaryDialog.open()
                }
            }
        }
        WelcomeFrame{
            Text{
                text: "Hello"
            }
        }
    }
}
