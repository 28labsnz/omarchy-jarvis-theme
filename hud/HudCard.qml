import QtQuick
Rectangle {
    id: card
    property string caption: ""
    property string number: ""
    color: "#0a1720"
    border.color: "#193541"
    border.width: 1
    Rectangle { x: 0; y: 0; width: 26; height: 2; color: "#00d9f5" }
    Rectangle { x: 0; y: 0; width: 2; height: 12; color: "#00d9f5" }
    Rectangle { anchors.right: parent.right; anchors.bottom: parent.bottom; width: 18; height: 1; color: "#357588" }
    HudText { x: 20; y: 18; text: card.caption; color: "#7399aa"; font.pixelSize: 10; font.letterSpacing: 2 }
    HudText { anchors.right: parent.right; anchors.rightMargin: 18; y: 18; text: card.number; color: "#356172"; font.pixelSize: 10 }
}
