billLength = 162;
billWidth = 70;
billThick = 5;
frameThickX = 5;
frameThickY = 5;
frameShapeStyle = 1;
frameThick = 3;
botThick = 2.5;
triangleThick = 2.5;
triangleLength = 20;
triangleWidth = 37.5;
triangleMode = 3;
hookLength = 20;
hookWidth = 20;
hookThick = 2.5;
hookHole = 3;
hookHoleUp = 0;
sfn = 100;
extraCut = 1;


module frame() {
    difference() {
        cube([billLength + frameThickX*2, billWidth + frameThickY*2, frameThick+botThick+billThick], center=true);
        translate([0,0,botThick/2+1]) {
            cube([billLength, billWidth,  frameThick+billThick+1], center=true);
        }
    }
}




module frameShapeX() {
    rotate([0,90,0]) {
        cylinder(r=frameThickX/2, h=billLength+frameThickX*frameShapeStyle, center=true, $fn=sfn);
    }
}
module frameShapeY() {
    rotate([90,0,0]) {
        cylinder(r=frameThickY/2, h=billWidth+frameThickY*frameShapeStyle, center=true, $fn=sfn);
    }
}


module frameTriangle() {
    scale([1,triangleWidth/triangleLength, 1]) {
        cylinder(r=triangleLength/2, h=triangleThick, center=true, $fn=3);
    }
}

module frameShapingX() {
    translate([0,(billWidth+frameThickY)/2,(billThick+botThick+frameThick)/2]) {
        frameShapeX();
    }
    translate([0,(billWidth+frameThickY)/-2,(billThick+botThick+frameThick)/2]) {
        frameShapeX();
    }
}

module frameShapingY() {
    translate([(billLength+frameThickX)/2,0,(billThick+botThick+frameThick)/2]) {
        frameShapeY();
    }
    translate([(billLength+frameThickX)/-2,0/-2,(billThick+botThick+frameThick)/2]) {
        frameShapeY();
    }
}


module frameTriangles() {
    translate([(billLength-frameThickX*triangleMode)/2,(billWidth-frameThickY*triangleMode)/2, (billThick+botThick+frameThick-triangleThick)/2]) {
        rotate([0,0,45]) {
            frameTriangle();
        }
        
    }
    translate([(billLength-frameThickX*triangleMode)/-2,(billWidth-frameThickY*triangleMode)/2, (billThick+botThick+frameThick-triangleThick)/2]) {
        rotate([0,0,135]) {
            frameTriangle();
        }
        
    }
    
    translate([(billLength-frameThickX*triangleMode)/2,(billWidth-frameThickY*triangleMode)/-2, (billThick+botThick+frameThick-triangleThick)/2]) {
        rotate([0,0,315]) {
            frameTriangle();
        }
        
    }
    translate([(billLength-frameThickX*triangleMode)/-2,(billWidth-frameThickY*triangleMode)/-2, (billThick+botThick+frameThick-triangleThick)/2]) {
        rotate([0,0,225]) {
            frameTriangle();
        }
        
    }
}
module shapedFrame() {
    difference() {
        frame();
        frameShapingX();
        frameShapingY();
    }
}


module hook() {
    translate([0,(billWidth+frameThickY)/2,0]) {
        difference() {
            scale([1,hookLength*2/hookWidth, 1]) {
                cylinder(r=hookWidth/2, h=hookThick, center=true, $fn=sfn);
            }
            translate([0,hookLength/-2,0]) {
                cube([hookWidth+extraCut,hookLength, hookThick+extraCut], center=true);
            }
            translate([0,hookLength/2+hookHoleUp,0]) {
                cylinder(r=hookHole/2, h=hookThick+extraCut, center=true, $fn=sfn);
        }
        }
    }
}

module fullFrame() {
    shapedFrame();
    frameTriangles();
    hook();

}

fullFrame();