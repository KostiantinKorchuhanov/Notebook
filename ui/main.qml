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
                id: noteName
                height: parent.height/20
                width: parent.width/3
                anchors.margins: 8
                anchors.top: parent.top
                anchors.left: searchPanel.right
                radius: 20
                color: "#444444"

                TextEdit {
                    anchors.fill: parent
                    anchors.margins: 8
                    text: "note_name"
                    font.pixelSize: noteName.height*0.6
                    wrapMode: TextInput.NoWrap
                    verticalAlignment: TextEdit.AlignVCenter
                    horizontalAlignment: TextEdit.AlignLeft
                    color: "#737272"

                }
            }

            Rectangle {
                id: allNotes
                width: parent.width * 0.08
                anchors.top: searchPanel.bottom
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 8
                radius: 20
                color: "#c3c5c9"

                ListView{
                    id: listOfNotes
                    anchors.fill: parent
                    anchors.margins: 8
                    clip: true
                    model: notes_info

                    delegate: Rectangle {
                                width: listOfNotes.width
                                height: 64
                                radius: 12
                                color: ListView.isCurrentItem ? "#3a3a3a" : "#333333"

                                Text {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    text: note
                                    color: "#e0e0e0"
                                    elide: Text.ElideRight
                                    wrapMode: Text.WordWrap
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                            interact_database.select_note(model.id)
                                            listOfNotes.currentIndex = index
                                        }
                                }
                    }
                }
            }

            Rectangle {
                id: textScene
                anchors.top: searchPanel.bottom
                anchors.left: allNotes.right
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
