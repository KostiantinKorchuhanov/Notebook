import QtQuick 2.15
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 600
    height: 500
    title: "Notes"
    color: "transparent"

    Component.onCompleted: {
            interact_database.get_last_note()
        }

    Rectangle {
        anchors.fill: parent
        radius: 20

            Rectangle {
                id: searchPanel
                height: parent.height/20
                width: parent.width/3
                anchors.margins: 8
                anchors.top: parent.top
                anchors.left: parent.left
                radius: 20
                color: "#444444"

                TextInput {
                    anchors.fill: parent
                    anchors.margins: 4
                    id: tempText
                    text: ""
                    font.pixelSize: searchPanel.height*0.5
                    color: "#bcbcbc"
                    wrapMode: TextInput.NoWrap
                    verticalAlignment: TextInput.AlignVCenter
                    horizontalAlignment: TextInput.AlignLeft
                }
                Text {
                    anchors.left: tempText.left
                    anchors.verticalCenter: tempText.verticalCenter
                    text: "Search..."
                    color: "#737272"
                    font.pixelSize: searchPanel.height*0.6
                    visible: !tempText.text && !tempText.activeFocus
                }
            }

            Rectangle {
                id: textScene
                anchors.top: searchPanel.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 8
                radius: 20
                color: "#a2c4c9"

                TextArea {
                    id: mainTextArea
                    anchors.fill: parent
                    anchors.margins: 8
                    onTextChanged: {
                        interact_database.save_note(mainTextArea.text, 0)
                    }
                    font.pixelSize: searchPanel.height*0.5
                    color: "#2e3b3d"
                    wrapMode: TextArea.WordWrap
                    verticalAlignment: TextArea.AlignTop
                    horizontalAlignment: TextArea.AlignLeft
                }

                Connections {
                    target: interact_database
                    function onLast_changed(note) {
                        mainTextArea.text = note
                    }
                }


            }

    }
}
