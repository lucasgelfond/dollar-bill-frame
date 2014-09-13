//------------------Variables------------------\\ 

		//----Global Values----\\
			//The default unit in OpenSCAD is mm and this unit variable allows one to change the variables in the code with units other than mm. Default is 1, for mm, but cm is 10 and inches is 25.4. Note that this entails that you change EVERY variable (except maybe sfn)  so that one piece of the model is not ridiculously bigger/smaller than the other parts. 
				unit=1;

			//The detail in the cylinders/spheres of the shape.
				sfn=30;

		//----Bill Specifics----\\

			//The length of the bill.
				billength= 157.5;

			//The width of the bill. 
				billwidth = 67.8;

			//The thickness of the frame. 
				framethick = 5;
			
			//Bottom Thickness
				botthick = 2 ;

		//----Frame Specifics----\\

			//The border of the frame length-wise. This is the measurement from the inside of the frame to the outisde on the length (x) axis. The cylinders that shape the frame use this measurement.
				xframe = 5;

			//The border of the frame width-wise. This is the measurement from the inside of the frame to the outisde on the width (y) axis.
				yframe = 5;
		
			//How prominent the frame shaping is. Play with this value. Default is 2.
				frameshapethick = 1.6;

			//How raised the frame shaping is. Play with this value as well. 
				frameshaperaise = 0;
		
	//----Paper clip slit size----\\\
		//Width of the paperclip slit. Adjust this value if as you want. 
		slitwidth = 10;
		
		//Height of the slit. This is actually a size control but it mainly changes the size.
		slitheight = 7.5;

		//Where the slit is. Slit is in the middle by default but depending on size you may have to raise or lower this value.
		slitlift =-3;

		//Shape of slit in sides. Default is 3 (triangle) as its overhangs are not unbearable.
		slitshape=3;

		//Slit scale (x,y,z)
		slitscalex= 0.5;
		slitscaley= 1.5;
		slitscalez= 1;
	
	//----Hook sizing----\\
		//Hook size
		hooksize=22.5;

		//Hook hole size
		hookhole=3;

		//Hook thickness
		hookthick=2.5;

//-------------------Modules-------------------\\ 

	//----Basic Frame Shapes----\\
		module bill() {
			cube([billength*unit, billwidth*unit,framethick*unit], center=true);
		}

		module outsideframe() { 
			cube([(billength+xframe)*unit, (billwidth+yframe)*unit, (framethick+botthick)*unit], center=true);
		}

	//----Frame shaping.----\\
		//Frame shaping cylinder on the X Axis.
			module xfsc() {
				cylinder(r=(framethick*unit)/(frameshapethick*2), h=(billwidth+yframe)*unit+xframe, center=true, $fn=sfn);
			}

		//Frame shaping cylinder on the Y Axis.
			module yfsc() {
				cylinder(r=(framethick*unit)/(frameshapethick*2), h=(billength+xframe)*unit+yframe, center=true, $fn=sfn);
			}

		//Frameshaping general module
			module frameshaping() {
				translate([(billength/2)*unit+xframe/2, 0, (framethick/2)*unit]) {
					rotate([90,0,0]) {
						xfsc();
					}
				}
				translate([(-billength/2)*unit-xframe/2, 0, (framethick/2)*unit]) {
					rotate([90,0,0]) {
						xfsc();
					}
				}

				translate([0, (billwidth/2)*unit+yframe/2, (framethick/2)*unit]) {
					rotate([90,0,90]) {
						yfsc();
					}
				}
				translate([0, (-billwidth/2)*unit-yframe/2, (framethick/2)*unit]) {
					rotate([90,0,90]) {
						yfsc();
					}
				}
			}

	



	//A slit on every side for a paper clip to hold it down
	module clipslit() {
		translate([0, ((billwidth+yframe)/2)*unit, slitlift*unit]) {
			rotate([0,270,90]) {
				scale([slitscalex,slitscaley,slitscalez]) {
					cylinder(r=(slitheight/2)*unit, h=slitwidth*unit, $fn=slitshape, center=true);
				}
			}
		}
		translate([0, ((billwidth+yframe)/2)*-unit, slitlift*unit]) {
			rotate([0,270,90]) {
				scale([slitscalex,slitscaley,slitscalez]) {
					cylinder(r=(slitheight/2)*unit, h=slitwidth*unit, $fn=slitshape, center=true);
				}
			}
		}
		translate([((billength+xframe)/2)*unit, 0, slitlift*unit]) {
			rotate([0,270,0]) {
				scale([slitscalex,slitscaley,slitscalez]) {
					cylinder(r=(slitheight/2)*unit, h=slitwidth*unit, $fn=slitshape, center=true);
				}
			}
		}
		translate([-unit*((billength+xframe)/2), 0, slitlift*unit]) {
			rotate([0,270,0]) {
				scale([slitscalex,slitscaley,slitscalez]) {
					cylinder(r=(slitheight/2)*unit, h=slitwidth*unit, $fn=slitshape, center=true);
				}
			}
		}				
	}

		
	module hook() {
		translate([0,-((billwidth+xframe)/2)*unit, (-(framethick+botthick)/2)*unit ]) {
			difference() {
				scale([1,2,1]) {
					cylinder(r=(hooksize/2)*unit, h=hookthick*unit, $fn=sfn);
				}
				translate([(-hooksize/2)*unit, 0]) {
					cube([hooksize*unit, hooksize*unit, hookthick*unit]);
				}
				translate([0, (-hooksize/2)*unit, 0]) {
					cylinder(r=(hookhole/2)*unit, h=hookthick*unit, $fn=sfn);
				}
			}
		}
	}


	//Plating module
	module frame() {
		difference() {
			outsideframe();
			translate([0,0, botthick]) {
				bill();
				clipslit();
			}
			translate([0,0, frameshaperaise]) {
				frameshaping();
			}
		}
	}

frame();
hook();