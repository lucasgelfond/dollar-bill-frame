//The length of the bill (mm). Don't use exact measurements as, chances are, the thing won't print precisely enough and the bill won't fit, so do round up.
billLength = 162;

//The width of the bill (mm). Don't use exact measurements as, chances are, the thing won't print precisely enough and the bill won't fit, so do round up.
billWidth = 70;

//The thickness of the bill. This SHOULD NOT be an exact measurement and you're completely fine using more space (within reason).
billThick = 5;

//The thickness of the frame length-wise.
frameThickX = 5;

//The thickness of the frame width-wise.
frameThickY = 5;

//The style of the frameshaping cut. A value between 1 and 2 is reccomended. This is how much the frame shaping modules overlap, and it works either way. Default is 1, but you might not like the look so do as you please.
frameShapeStyle = 1;

//The additional thickness of the frame (top to bottom-wise), independent from the bottom and the slot for the bill.
frameThick = 3;

//The thickness of the bottom piece of the frame.
botThick = 2.5;

//The thickness of of the frame triangles.
triangleThick = 2.5;

//The length ("diameter") of the triangles.
triangleLength = 20;

//The width of the triangles.
triangleWidth = 37.5;

//Mode 1 is to have the triangles on the outside corners on the frame, mode 3 is to have triangles on the inner corners of the frame. Had to skip mode 2 just because of how the math works out.
triangleMode = 3;

//Total length of the hook. 
hookLength = 20;

//Total width of the hook
hookWidth = 20;

//Total thickness of the hook.
hookThick = 2.5;

//The size of the hole for the hook.
hookHole = 3;

//The length up from the center the hole should be.
hookHoleUp = 0;

//The detail on all circular objects in the model.
sfn = 100;

//The amount extra to cut through things. Used many times here.
extraCut = 1;


module frame() {
    difference() {
        //The length + the border of the  frame, the width + the border of the frame + the total thickness including the thickness of the bottom, the middle (for the bill) and the thickness of the general frame. Multiply both frame thicknesses for two so both sides have that thickness.
        cube([billLength + frameThickX*2, billWidth + frameThickY*2, frameThick+botThick+billThick], center=true);
        //Moves the frame up to cut through everything except the thickness reserved for the bottom. Saves a step.
        translate([0,0,botThick/2+1]) {
            //The insides that need to be hollowed out, being "subtracted" from the whole piece.
            cube([billLength, billWidth,  frameThick+billThick+1], center=true);
        }
    }
}




module frameShapeX() {
    //Rotate the cylinder that cuts into the frame from a "soup can" or "water bottle" orientation to a "rolling log" type of orientation.
    rotate([0,90,0]) {
        //The size of the frame exactly. The height is the new "length" of the cylinder because it's flipped on its side, so it needs  to be the size of the bill in that directions plus the frame thickness to go all the way. All the way looks different than all the way minus a little bit and they offer different aesthetics, hence why there is a "frameShapeStyle" variable, adjustible above to change the level of overlap of the two cylinders.
        cylinder(r=frameThickX/2, h=billLength+frameThickX*frameShapeStyle, center=true, $fn=sfn);
    }
}
module frameShapeY() {
       //Rotate the cylinder that cuts into the frame from a "soup can" or "water bottle" orientation to a "rolling log" type of orientation.
    rotate([90,0,0]) {
        //The size of the frame exactly. The height is the new "length" of the cylinder because it's flipped on its side, so it needs  to be the size of the bill in that directions plus the frame thickness to go all the way. All the way looks different than all the way minus a little bit and they offer different aesthetics, hence why there is a "frameShapeStyle" variable, adjustible above to change the level of overlap of the two cylinders.
        cylinder(r=frameThickY/2, h=billWidth+frameThickY*frameShapeStyle, center=true, $fn=sfn);
    }
}


module frameTriangle() {
    scale([1,triangleWidth/triangleLength, 1]) {
        cylinder(r=triangleLength/2, h=triangleThick, center=true, $fn=3);
    }
}

module frameShapingX() {
    //Moving the frame to the edge of the frame. Since I don't want the edge of the frame shaping cylinder to be on the edge of the bill, I don't translate it an additional frameThickY/2 to compensate for the size of the cylinder.
    translate([0,(billWidth+frameThickY)/2,(billThick+botThick+frameThick)/2]) {
        frameShapeX();
    }
    //Moving the frame to the edge of the frame. Since I don't want the edge of the frame shaping cylinder to be on the edge of the bill, I don't translate it an additional frameThickX/2 to compensate for the size of the cylinder.
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
    //For all of these blocks of text in this module, we're moving the triangles to either the outside or inside corners, decided by the triangle mode variable above, and rotating them so that they are in the correct orientation for their respective corners.
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
    //Subtracting all of the shaping of the frame from the frame itself.
    difference() {
        frame();
        frameShapingX();
        frameShapingY();
    }
}


module hook() {
    //Moving the hook to the edge of the frame.
    translate([0,(billWidth+frameThickY)/2,0]) {
        //Only using half of the hook by cutting off half of it. 
        difference() {
            //Scaling the cylinder up based on the ratio between length and width.
            scale([1,hookLength*2/hookWidth, 1]) {
                //A cylinder for the hook based on the variables above. 
                cylinder(r=hookWidth/2, h=hookThick, center=true, $fn=sfn);
            }
            //Moving the part to cut over.
            translate([0,hookLength/-2,0]) {
                //Added extracut for a clean cut.
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