/**
* "Pimp My Padlock"
*
* A library for creating stylised padlock sheaths enabling
* padlocks to blend in more appropriately with various escape room
* themes
*
* Suggested 3D filaments:
* Gold, Ivory, Jade, Brass, Bronze
*
* For improved durability, resin coat the sheath after printing

Front View     Side View
   _____             _
  /  _  \           | |
  | | | |           | |
 _| |_| |_         _| |_
|      (  )       |     |
|      (  )       |     |
|      (  )       |     |
|______(__)       |_____|
 Width_A           Depth  
*/

//Width_A is from flat edge to centre of cylindrical barrel
Padlock_Width_A = 33;
Padlock_Depth = 14;
Sheath_Thickness = 2;
Barrel_Radius = 8.5;


// Library for creating textured surface from heightmap image data
include <PolyhedronHelper.scad>

// EXPERIMENTAL!
// Include any textures required here
// Created from images using separate Python script
// include <Textures/Slate.scad>

// Include any ornamentations required here
Ornament = "Skull"; // [LionHead,DragonHead,WingedSphinx,Skull]

fourComboPadlock();

// This is for a small padlock
// (Max) Body width 20mm
// Body thickness 10mm
module smallPadlock() {
    difference() {
        // Outer block, translated to be central
        translate([-12,-7, -2])
            cube([24, 14, 20]);
        
        // Padlock body
        linear_extrude(height=18){
            intersection() {
                resize([25.5,11])circle(d=20);
                square(size = [21, 11], center = true);  
            }  
        }   
   
        // Keyhole
        cylinder(h = 4, r=4.5, center = true, $fn=100);
        translate([-1,0, 0])
        cylinder(h = 4, r=5.5, center = true, $fn=100);
       
    }

    // Ornament
    translate([-12,-6.9,-2]) rotate([90,0,0]) resize([24,20,16])
    import("Ornaments/DragonHead.stl");
}


// This is for a small padlock
// (Max) Body width 20mm
// Body thickness 10mm
module fourComboPadlock() {
    
    // PADLOCK SHEATH BOTTOM HALF
    difference() {
        // SOLID EXTERIOR BLOCK
        union(){
            // Main block
            cube([Padlock_Width_A+Sheath_Thickness, Padlock_Depth + (2*Sheath_Thickness), 48]);
            
            // Add textured sides
            // Front
            if(str(texture_data) != "undef") {
                resize([Padlock_Width_A+Sheath_Thickness,1,35]) rotate([90,0,0])
                polyhedron_from_surface(texture_data, 35, 35, 1, 2, false);
            }
            // Back
            if(str(texture_data) != "undef") {
                translate([Padlock_Width_A+Sheath_Thickness,18,0]) rotate([90,0,180])
                polyhedron_from_surface(slate_data, 35, 48, 1, 2, false);
            }
            
            // Cylinder
            translate([35,9,0])
                cylinder(h = 48, r=Barrel_Radius+Sheath_Thickness, center = false, $fn=100);
        }
            
        // HOLLOW OUT CAVITY FOR PADLOCK
        // Padlock body
        translate([2,2,2])
        union(){
            // Main block
            cube([Padlock_Width_A, Padlock_Depth, 46]);
            // Barrel
            translate([Padlock_Width_A+Sheath_Thickness,7,0])
            cylinder(h = 46, r=Barrel_Radius, center = false, $fn=100);
        }
          
        // Number ring cutout
        translate([28,-20,9])
        cube([40, 40, 29]);
            
        // Cutoff top of model
        translate([0,0,36]){
            union(){
                cube([Padlock_Width_A+Sheath_Thickness, 18, 48]);
                translate([35,9,0])
                    cylinder(h = 48, r=Barrel_Radius+Sheath_Thickness, center = false, $fn=100);
            }
        }
    }
    
    // Add ornamentation
    if (Ornament == "LionHead"){
        translate([14,.2,22]) resize([26,12,30]) rotate([90,0,0])
        import("Ornaments/LionHead.stl");
    }
    else if (Ornament == "WingedSphinx") {
        translate([16,9.4,19]) resize([24,4,20])
        import("Ornaments/WingedSphinx.stl");
    }
    else if (Ornament == "DragonHead") {
        translate([0,-0,8]) rotate([90,0,0]) resize([34,34,20])
        import("Ornaments/DragonHead.stl");
    }
    else if (Ornament == "Skull") {
        translate([30,0,6]) rotate([0,0,180]) resize([28,15,36])
        import("Ornaments/Skull.stl");
    }

    // PADLOCK SHEATH TOP HALF
    translate([0,40,0])
    difference() {
        union(){
            // outer block
            cube([35, Padlock_Depth + 2*Sheath_Thickness, 16.5]);
            translate([35,9,0])
            cylinder(h = 12, r=Barrel_Radius+Sheath_Thickness, center = false, $fn=100);
        }
            
        // padlock body
        translate([2,2,2])
        union(){
            // outer block
            cube([33, Padlock_Depth, 48]);
            translate([33,7,0])
            cylinder(h = 46, r=Barrel_Radius, center = false, $fn=100);
        }
   
        // Number ring cutout
        translate([28,-20,12])
          cube([40, 40, 29]);

        // Cutout holes for shackle
        translate([9,9,0])
            cylinder(h = 46, r=3.6, center = true, $fn=100);
        translate([35,9,0])
            cylinder(h = 46, r=3.6, center = true, $fn=100);

        // Cutout channel in top cover to allow shackle to pass over without obstruction
        translate([35,9,0]) rotate([0,0,180])
        rotate_extrude(convexity = 10, angle = 30)
            translate([26, 1, 0])
                square(size = [7.2,2], center = true);
    }
}