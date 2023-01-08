// Author: Christian Petry
// Designed in Switzerland 2017
// Version: 1.2 (2018-02-11)

// uses model of nexus 6 by Samg381 https://www.thingiverse.com/thing:755283
// Thank you!

/* Version History
V1.0 (2017-12-12) initial version
- based on my oneplus3 wallet case

V1.1 (2018-01-11)
- phoneDimensionAdditional X/Y/Z -0.25 -> -0.5
- phoneZCorrection 0 -> 2
- creditCardSpace[0] increased by 1.2mm
- caseUndersideThickness 1.8 -> 1.2
- hingeAdditional 2.75 -> 5.0

V1.2 (2018-02-11)
- fixed: model of nexus 6 is not correct, had to add corrections parts
-- phoneZCorrection 2 -> 4.8
-- phoneDimensionAdditional X/Y -0.25 -> 1.0
-- caseUndersideThickness 1.2 -> -1.4
-- hingeAdditional 3.75 -> 6.2
- standLayer 6 -> 5

*/

/* [Main] */
layerHeight=0.15;
caseSideThickness=1.8;
caseTopBottomThickness=1.8;
caseUndersideThickness=-1.4;
// position of the stand layer; -1=none
standLayer=5; // [-1:1:20]
// position of the extra pocket layer; 0=none
extraTopPocketLayer=6; // [0:1:20]
// number of credit card pockets; 0=none
numberCreditCardPockets=3; // [0:1:4]
// height of top without credit card pockets; 0=no top, i.e. bumper case
topZLayers=10; // [0:1:20]
// credit card pocket top thickness
creditCardPocketTopLayers=3; // [1:1:5]
// number of layers for air gap
airGapLayers=2; // [1:1:3]
// hinge thickness; 0=none
hingeZLayers=2; // [0:1:20]
// extra space for credit cards and money between phone and top
hingeAdditional=6.2;
// make additional space for phone, use i.e. to offset print precision issues. For very flexible materials you may want to use negative values
phoneDimensionAdditionalX=1.0;
phoneDimensionAdditionalY=1.0;
phoneDimensionAdditionalZ=0;

// engraved text
engravedText="Doris";
engravedTextLayers=2;
engravedTextSize=9;
engravedTextSpacing=1.1;
engravedTextPosX=-103;
engravedTextPosY=-70;
engravedTextFont="Liberation Sans";

/* [Hidden] */
$fn=50;
phoneZCorrection=4.8; // workaround for errors in modeled phone
phone=[82.98+phoneDimensionAdditionalX,159.26+phoneDimensionAdditionalY,10.06+phoneDimensionAdditionalZ]; // phone dimesions x,y,z
path="Nexus6.stl";

// --- cutouts ---
// top (headphone)
topCutout=[8-2,19,30];
posCutout1=[0,-3,4];
// power button
powerbutton=[42-8,24,30];
posCutout2=[9,-3,3.5];
// bottom (usb)
bottomCutout=[10-4,16,30];
posCutout3=[0,-1,6.0];
// camera
camera_loc=[0,57];
camera=[20,20,20];
camera_rounding=camera[0]/2-0.01;

// --- cutoffs ---
case_top_cutoff=-99;
case_bottom_cutoff=3;

// --- phone and case spefific rounding ---
phone_edge=11;
phone_edge_r=37;
rounding=1.7;
s_scale=[3.5,3.5,1];
case_rounding=5;
case_rounding_sphere=2.5;
smallerX=18;
smallerY=15;

// case size offset x,y,z
caseWall=[caseSideThickness, 
caseTopBottomThickness, caseUndersideThickness+case_bottom_cutoff];

hingeX=phone[2]+caseWall[0]+caseWall[2]-case_bottom_cutoff+hingeAdditional;
hingeWidth=hingeX+hingeAdditional;
hingeZ=hingeZLayers*layerHeight;

topZ=topZLayers*layerHeight;

OVERLAP=0.005;

function creditCardZ()=airGapLayers*layerHeight;

creditCardSpace=[65.4+1.2,75]; // x in mm, y in mm
bottomThickness=0;
creditCardPocketSeam=1;
seamTopPocket=1.5;
creditCardPocketTop=layerHeight*creditCardPocketTopLayers;
zOffset=0+creditCardZ()+creditCardPocketTop;
creditCardPocketsStartOffset=2;
creditCardPocketYOffsetPerPocket=19;
creditCardPocketHeight=bottomThickness+creditCardZ()+creditCardPocketTop;
extraYOffsetPerPocket=2.5;


difference(){
    bumper();
    standCutout();
}


if (topZLayers > 0){
    hinge();
    difference(){
        top();
        extraTopPocket();
        translate([0,0,-OVERLAP])
        engravedText();
    }

    if (numberCreditCardPockets > 0){
        translate([0,creditCardPocketsStartOffset,0])
        creditCardPockets();
    }
}

module bumper(){
    translate([0,0,-case_bottom_cutoff])
    difference(){
        difference(){
            hull(){
                resize(newsize=[phone[0]+2*caseWall[0],phone[1]+2*caseWall[1],phone[2]+caseWall[2]+phoneZCorrection])
                phone();
                
                translate([-phone[0]/2+smallerX/2,-phone[1]/2+smallerY/2,0])
                minkowski(){
                    cube([phone[0]-smallerX,phone[1]-smallerY,6]);
                    cylinder(r=case_rounding*1.5,h=case_rounding);
                }
            }
            
            translate([0,0,phone[2]+caseWall[2]+10/2-case_top_cutoff])
            cube([phone[0]*2,phone[1]*2,10], center=true);
            
            translate([0,0,-30/2+case_bottom_cutoff])
            cube([phone[0]*2,phone[1]*2,30], center=true);
        }
        translate([0,0,caseWall[2]])
        union(){
            resize(newsize=[phone[0],phone[1],phone[2]+phoneZCorrection])
            phone();
            phone_cutouts();
        }
    }
    
    difference(){
        union(){
            translate([-34.5,-phone[1]/2-0.67,0])
            cube([67,phone[1]+0.2,1.3]);
            
            translate([-28,-81.2,0.2])
            cube([54,8,4.6]);
                
            translate([-35,-80.2,0.2])
            cube([70,8,4.6]);
            
            translate([-33,-72.3,0.2])
            cube([65,15,3.4]);
            
            translate([-33,-57.4,0.2])
            cube([65,15,2.5]);
            
            translate([-33,-42.5,0.2])
            cube([65,15,1.7]);
        }
        
        phone_cutouts();
    }
}

module standCutout(){
    sizeFactor=2;
    color([1,0,0])
    translate([-phone[0]/2*sizeFactor,-phone[1]/2*sizeFactor,(standLayer-1)*layerHeight])
    cube([sizeFactor*phone[0]/2,sizeFactor*phone[1],airGapLayers*layerHeight]);
}

module extraTopPocket(){
    zOffset=(airGapLayers*layerHeight)/topZ;
    color([1,0,0])
    scale([1,(phone[1]-2*seamTopPocket)/phone[1],1])
    translate([seamTopPocket,0,(extraTopPocketLayer-1)*layerHeight])
    scale([1,(phone[1]-2*seamTopPocket)/phone[1],zOffset])
    top();
}

module top(){
    scaleSizeWithWallThicknessFactor=0.75;
    translate([-1.5*phone[0]-hingeX+case_rounding-scaleSizeWithWallThicknessFactor*caseWall[0],-phone[1]/2+1.5*case_rounding-scaleSizeWithWallThicknessFactor*caseWall[1],0])
    difference(){
        minkowski(){
            cube([phone[0]-2*1.5*case_rounding-case_rounding_sphere+2*scaleSizeWithWallThicknessFactor*caseWall[0],phone[1]-2*1.5*case_rounding+2*scaleSizeWithWallThicknessFactor*caseWall[1],topZ]);
            cylinder(r=case_rounding*1.5,h=case_rounding);
        }
        translate([-case_rounding*1.5-OVERLAP/2,-case_rounding*1.5-OVERLAP/2,topZ])
        cube([phone[0]+OVERLAP+case_rounding_sphere+caseWall[0],phone[1]+OVERLAP+2*caseWall[1],100]);
    }
}

module creditCardPockets(){    
      translate([-phone[0]-hingeWidth-caseWall[0]/2,-phone[1]/2+creditCardSpace[0]/2+creditCardPocketSeam+case_rounding,topZ])
      {
      for (i=[1:numberCreditCardPockets]){
        creditCardPocket(i,numberCreditCardPockets);
      }
      }
}

module creditCardPocket(pocketNumber,totalNumber){
    yOffset=(totalNumber-pocketNumber)*creditCardPocketYOffsetPerPocket;
    extraYOffset=(totalNumber-pocketNumber)*extraYOffsetPerPocket;
    zOffset=(pocketNumber-1)*creditCardPocketHeight+creditCardPocketHeight/2;
    
    translate([0,yOffset/2+totalNumber/2*extraYOffsetPerPocket-extraYOffset/2,zOffset]){
        cube([creditCardSpace[0]+extraYOffset,creditCardSpace[1]+yOffset,bottomThickness], center=true);
        
        difference(){
            cube([creditCardSpace[0]+extraYOffset,creditCardSpace[1]+yOffset,creditCardPocketHeight], center=true);
            
        translate([0,creditCardPocketSeam+yOffset/2,bottomThickness-(creditCardPocketHeight-creditCardZ())/2])
            cube([creditCardSpace[0]-2*creditCardPocketSeam,creditCardSpace[1]-creditCardPocketSeam,creditCardZ()+OVERLAP], center=true);
        }
    }
}

module hinge(){
    color([1,1,0])
    translate([-phone[0]/2-hingeWidth/2,0,hingeZ/2])
    cube([hingeX+hingeAdditional+2*case_rounding+caseWall[0],phone[1]+2*caseWall[1]-case_rounding-smallerY/2,hingeZ], center=true);
}

module phone(){
    hull(){
        translate([-phone[0]/2-3.4,-phone[1]/2-3.1,-3.3-2.5])
        scale([25.85,25.85,25.85*(phone[2]+phoneZCorrection)/phone[2]])
        import(path, convexity = 10);
    }
}

module phone_cutouts(){
	// camera
	translate([camera_loc[0], camera_loc[1], -camera_loc[2]+camera_rounding])
	minkowski()
	{
		cube([camera[0]-2*camera_rounding,
			camera[1]-2*camera_rounding,
			camera[2]], center=true);
		difference()
		{
			sphere(r=camera_rounding);
			translate([-camera_rounding,-camera_rounding,0])
				cube(2*camera_rounding);
		}
	}	

        phone_cutout_helper("TOP",posCutout1,topCutout);
            
        phone_cutout_helper("RIGHT",posCutout2,powerbutton);
        
        phone_cutout_helper("BOTTOM",posCutout3,bottomCutout);
}

// phoneSideAlias=LEFT/RIGHT/TOP/BOTTOM/UPPER/UNDER
// posVector=[x,y,z]
// sizeVector=[width,height,depth]
module phone_cutout_helper(phoneSideAlias,posVector,sizeVector){
    dZ=sizeVector[1]/2; // default Z offset
    if (phoneSideAlias=="LEFT"){
        offsetVector=[-phone[0]/2-posVector[1],-posVector[0],dZ+posVector[2]];
        rotateVector=[-90,0,90];
        phone_cutout(sizeVector,offsetVector,rotateVector);
    } else if (phoneSideAlias=="RIGHT"){
        offsetVector=[phone[0]/2+posVector[1],posVector[0],dZ+posVector[2]];
        rotateVector=[90,0,90];
        phone_cutout(sizeVector,offsetVector,rotateVector);
    } else if (phoneSideAlias=="TOP"){
        offsetVector=[posVector[0],phone[1]/2+posVector[1]+sizeVector[2],dZ+posVector[2]];
        rotateVector=[90,0,0];
        phone_cutout(sizeVector,offsetVector,rotateVector);
    } else if (phoneSideAlias=="BOTTOM"){
        offsetVector=[posVector[0],-phone[1]/2-posVector[1],dZ+posVector[2]];
        rotateVector=[90,0,0];
        phone_cutout(sizeVector,offsetVector,rotateVector);
    } else if (phoneSideAlias=="UPPER"){
        // TODO
    } else if (phoneSideAlias=="UNDER"){
        offsetVector=[posVector[0],phone[1]/2+posVector[1],dZ+posVector[2]];
        rotateVector=[0,180,90];
        phone_cutout(sizeVector,offsetVector,rotateVector);
    }
}

// sizeVector=[width,height,depth]
module phone_cutout(sizeVector,offsetVector,rotateVector){
    color([1,0,0])
    translate([offsetVector[0],offsetVector[1],offsetVector[2]])
    rotate([rotateVector[0],rotateVector[1],rotateVector[2]])
    translate([-sizeVector[0]/2+sizeVector[1]/6,0,0])
			hull()
			{
					cylinder(d=sizeVector[1],h=sizeVector[2]);
				translate([sizeVector[0]-sizeVector[1]/3,0,0])
					cylinder(d=sizeVector[1],h=sizeVector[2]);
			}
}

module engravedText(){ 
    color([1,0,0])
    translate ([engravedTextPosX,engravedTextPosY,engravedTextLayers*layerHeight])
    rotate ([0,180,0])
    linear_extrude(engravedTextLayers*layerHeight)
        text(engravedText, font = engravedTextFont, size = engravedTextSize, spacing = engravedTextSpacing );
}