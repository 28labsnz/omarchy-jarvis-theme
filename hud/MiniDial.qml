import QtQuick
Item {
    id: root
    property real amount: 0
    property string label: Math.round(amount) + "%"
    property color ink: "#00dfff"
    Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
        id: ring
        anchors.fill: parent
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            var c=getContext("2d");c.reset();var x=width/2,y=height/2,r=Math.min(width,height)/2-7;
            c.lineWidth=1;c.strokeStyle="#205064";c.beginPath();c.arc(x,y,r,0,Math.PI*2);c.stroke();
            c.strokeStyle="#123746";c.lineWidth=4;c.beginPath();c.arc(x,y,r-8,0,Math.PI*2);c.stroke();
            c.strokeStyle=root.ink;c.lineWidth=3;c.lineCap="round";c.shadowColor=root.ink;c.shadowBlur=7;
            c.beginPath();c.arc(x,y,r-8,-Math.PI/2, -Math.PI/2+Math.max(0,Math.min(100,root.amount))*Math.PI/50);c.stroke();
        }
        Connections { target: root; function onAmountChanged(){ring.requestPaint()} function onInkChanged(){ring.requestPaint()} }
    }
    HudText { anchors.centerIn: parent; text: root.label; displayFace: true; font.pixelSize: 23; weight: Font.DemiBold; color: root.ink }
}
