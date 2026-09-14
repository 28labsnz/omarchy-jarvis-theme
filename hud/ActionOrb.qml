import QtQuick
Item {
    id: root
    property string label: ""
    property string subtitle: ""
    property string symbol: ""
    property bool compact: false
    signal activated()
    implicitWidth: 136
    implicitHeight: compact ? 60 : 128
    Rectangle {
        id: circle
        width: root.compact ? 42 : 66; height: width; radius: width/2
        anchors.horizontalCenter: parent.horizontalCenter
        y: 2
        border.width: 1; border.color: mouse.containsMouse ? "#55efff" : "#22556a"
        gradient: Gradient { GradientStop { position: 0; color: mouse.containsMouse ? "#125365" : "#102d3d" } GradientStop { position: 1; color: "#05141e" } }
        Rectangle { anchors.fill: parent; anchors.margins: -5; radius: width/2; color: "transparent"; border.color: "#164a5e"; opacity: mouse.containsMouse ? 1 : 0; Behavior on opacity { NumberAnimation { duration: 180 } } }
        HudText { anchors.centerIn: parent; text: root.symbol; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: root.compact ? 18 : 28; color: mouse.containsMouse ? "#8af4ff" : "#00dfff" }
    }
    HudText { anchors.horizontalCenter: parent.horizontalCenter; y: root.compact ? 50 : 83; text: root.label; displayFace: true; color: mouse.containsMouse ? "#50eaff" : "#80adbe"; font.pixelSize: root.compact ? 8 : 10; font.letterSpacing: 1.6 }
    HudText { anchors.horizontalCenter: parent.horizontalCenter; y: 107; visible: !root.compact; text: root.subtitle; color: "#4e7c90"; font.pixelSize: 13 }
    MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.activated() }
}
