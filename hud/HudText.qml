import QtQuick
Text {
    property bool displayFace: false
    property int weight: Font.Medium
    color: "#83b4c5"
    font.family: displayFace ? "Orbitron" : "Rajdhani"
    font.pixelSize: 14
    font.weight: weight
    font.variableAxes: displayFace ? ({"wght": weight}) : ({})
    textFormat: Text.PlainText
    renderType: Text.QtRendering
}
