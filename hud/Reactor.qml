import QtQuick
Item {
    id: root
    property real load: 0
    property real memory: 0
    property string temperature: "—"
    property int second: 0
    Canvas {
        id: dial
        anchors.fill: parent
        onPaint: {
            var c=getContext("2d");c.reset();
            var cx=width/2,cy=height/2,r=Math.min(width,height)*.42;
            function arc(radius,start,end,color,line) {
                c.beginPath();c.arc(cx,cy,radius,start*Math.PI/180,end*Math.PI/180);c.strokeStyle=color;c.lineWidth=line;c.stroke();
            }
            arc(r,0,360,"#183846",1);
            arc(r-19,0,360,"#13303e",8);
            arc(r-19,-90,-90+Math.max(1,root.load)*3.6,"#00d9f5",8);
            arc(r-37,20,160,"#296073",2);arc(r-37,200,340,"#296073",2);
            arc(r-49,-90,-90+root.memory*3.6,"#4d94b0",2);
            arc(r-65,0,360,"#163443",1);
            for(var i=0;i<120;i++) {
                var a=i*Math.PI/60,len=i%5===0?9:3;
                c.beginPath();c.moveTo(cx+(r+9)*Math.cos(a),cy+(r+9)*Math.sin(a));
                c.lineTo(cx+(r+9+len)*Math.cos(a),cy+(r+9+len)*Math.sin(a));
                c.strokeStyle=i%5===0?"#42798d":"#1f4352";c.lineWidth=1;c.stroke();
            }
            var a=(root.second*6-90)*Math.PI/180;
            c.beginPath();c.arc(cx+(r+17)*Math.cos(a),cy+(r+17)*Math.sin(a),3,0,Math.PI*2);c.fillStyle="#e8faff";c.fill();
            c.strokeStyle="#265364";
            for(var k=0;k<4;k++) {var b=k*Math.PI/2;c.beginPath();c.moveTo(cx+(r+33)*Math.cos(b),cy+(r+33)*Math.sin(b));c.lineTo(cx+(r+45)*Math.cos(b),cy+(r+45)*Math.sin(b));c.stroke();}
        }
        Connections { target: root; function onLoadChanged(){dial.requestPaint()} function onMemoryChanged(){dial.requestPaint()} function onSecondChanged(){dial.requestPaint()} }
    }
    Column {
        anchors.centerIn: parent
        spacing: 8
        HudText { anchors.horizontalCenter: parent.horizontalCenter; text: "SYSTEM CORE"; font.pixelSize: 10; font.letterSpacing: 3; color: "#729bac" }
        HudText { anchors.horizontalCenter: parent.horizontalCenter; text: root.load.toFixed(0) + "%"; font.pixelSize: 66; font.weight: Font.Light; color: "#e5f9ff" }
        HudText { anchors.horizontalCenter: parent.horizontalCenter; text: "PROCESSOR LOAD"; font.pixelSize: 9; font.letterSpacing: 2; color: "#00d9f5" }
        Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: 80; height: 1; color: "#234a5a" }
        HudText { anchors.horizontalCenter: parent.horizontalCenter; text: root.temperature + "  /  CPU"; font.pixelSize: 10; color: "#83a8b8" }
    }
}
