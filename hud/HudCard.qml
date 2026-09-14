import QtQuick
Item {
    id: card
    property string caption: ""
    property string number: ""
    Rectangle {
        anchors.fill: parent
        radius: 20
        gradient: Gradient { GradientStop { position: 0; color: "#550a2735" } GradientStop { position: 1; color: "#1106131d" } }
    }
    Rectangle { x: 0; y: 11; width: 14; height: 3; radius: 1; color: "#00dfff" }
    HudText { x: 26; y: 5; text: card.caption; displayFace: true; color: "#00dfff"; font.pixelSize: 10; font.letterSpacing: 1.8 }
    HudText { anchors.right: parent.right; anchors.rightMargin: 5; y: 5; text: card.number; displayFace: true; color: "#32647a"; font.pixelSize: 9 }
    Rectangle { x: 0; y: 32; width: parent.width; height: 1; gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0; color: "#286178" } GradientStop { position: 1; color: "#00165369" } } }
}
