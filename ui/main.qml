import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 600
    height: 500
    color: "transparent"
    title: "Notes"


    Rectangle {
        anchors.fill: parent
        radius: 20
        color: "#1E1E1E"
        opacity: 0.95
        layer.enabled: true

    }

    Text {
        anchors.centerIn: parent
        text: "Notes"
        font.pixelSize: 24
    }

}