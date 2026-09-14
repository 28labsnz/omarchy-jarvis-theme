import QtQuick
Canvas {
        onAvailableChanged: if (available) requestPaint()
        onVisibleChanged: if (visible) requestPaint()
    property var values: []
    property color ink: "#00dfff"
    onValuesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onPaint: {
        var c = getContext("2d"); c.reset();
        c.strokeStyle = "#112d3a"; c.lineWidth = 1;
        for (var j=1; j<4; j++) { c.beginPath(); c.moveTo(0, height*j/4); c.lineTo(width,height*j/4); c.stroke(); }
        if (values.length < 2) return;
        var max = Math.max(20, Math.max.apply(null, values)*1.15);
        c.beginPath();
        for (var i=0;i<values.length;i++) {
            var x=width*i/(values.length-1), y=height-4-values[i]/max*(height-8);
            if(i===0)c.moveTo(x,y);else c.lineTo(x,y);
        }
        c.strokeStyle=ink; c.lineWidth=1.5; c.stroke();
        c.lineTo(width,height);c.lineTo(0,height);c.closePath();
        var g=c.createLinearGradient(0,0,0,height); g.addColorStop(0,"#40136a80");g.addColorStop(1,"#0006131d");c.fillStyle=g;c.fill();
    }
}
