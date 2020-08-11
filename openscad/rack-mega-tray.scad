/**
 * Arduino Mega Tray.
 * Version: 0.2
 * History
 * | 0.1 | Initial
 * | 0.2 | Added spacer_depth_ext for spacers only; Moved forward spacers;
 *
 */


/* [Screw holes for attaching the Arduino Mega] */

// Make the screw holes this much bigger than the
// actual screw for a more comfortable fit
// (a bigger number here will make the screws fit looser)
screw_hole_fudge = 0.15; // [0:0.05:0.5]

/* [Tray width] */

// Make the tray this much narrower on each side
// for a more comfortable fit in the frame
// (a bigger number here will make the fit looser)
tray_insert_fudge = 0.25; // [0:0.05:0.75]

/* [Hidden] */

inner_wall_size = 5;
tray_width = 58;

tray_arduino_length = 101.6; // arduino mega length
tray_length = tray_arduino_length;

tray_depth = 5;
tray_lip_overhang = 10;

inner_wall_thickness = 5;
spacer_depth_ext = 2; // arduino requires 2mm uplift so a USB connector cable can fit "over" the curved handle
spacer_depth = 3;
spacer_outer_radius = 3;

screw_radius = 1.5 + screw_hole_fudge;  //M3 
screw_head_radius = 3.5;    // +0.5 for M3
screw_head_depth = 2.5;     // +0.5 for M3
pcb_depth = 2;
spacer_center_width = 48.2; // arduino width between pcb holes
spacer_from_edge = (tray_width - spacer_center_width) / 2;

sd_window_width = 38;
floor_window_width = sd_window_width;
floor_window_border = (tray_width - floor_window_width) / 2;
floor_window_length = tray_length - floor_window_border*2 - inner_wall_thickness;

epsilon = 0.001;

/*
https://blog.adafruit.com/2011/02/28/arduino-hole-dimensions-drawing/

    (--------------------------
   (   D                   A  |
  (                 F         |
  (                           |
  (                 E         |
   (  C                     B |
    (--------------------------
*/        

ay = 13;
by = ay - 6.3; // derived from EtherMega PCB
dy = ay + 24.1 + 50.8;               
cy = dy + 1.3;           
fy = ay + 24.1;
fx = spacer_from_edge + spacer_center_width - 15.2;
ey = ay + 24.1;
ex = fx - 27.9;

difference() {
    union() {
        // the main tray
        intersection() {
            union() {
                translate([tray_insert_fudge, 0, 0]) {
                    cube([  tray_width - 2*tray_insert_fudge,
                            tray_length + tray_lip_overhang,
                            tray_depth]);
                }

                
                difference() {
                    // the outer part of the curved handle
                    translate([ tray_width/2,
                                -tray_length*0.5 + 7.5,
                                0]) {
                        cylinder(
                            h=tray_depth + spacer_depth + pcb_depth,
                            r=tray_length*1.5,
                            center=false,
                            $fn=360);
                    }
                    
                    // cut away the inside to make it a shell
                    translate([ tray_width/2,
                                -tray_length*0.5 + 5.4,
                                -epsilon]) {
                        cylinder(
                            h=tray_depth + spacer_depth + pcb_depth + 2*epsilon,
                            r=tray_length*1.5,
                            center=false,
                            $fn=360);
                    }
                    translate([ tray_width,
                                -tray_length,
                                -epsilon]) {
                        cube([  2.2*tray_width,
                                3*tray_length,
                                tray_depth + spacer_depth + pcb_depth + 2*epsilon]);
                    }
                    translate([ -2.2*tray_width,
                                -tray_length,
                                -epsilon]) {
                        cube([  2.2*tray_width,
                                3*tray_length,
                                tray_depth + spacer_depth + pcb_depth + 2*epsilon]);
                    }
                }
                
                // reinforce the curved handle
                translate([epsilon, tray_length, tray_depth]) {
                    rotate([-75, 0, 0]) {
                        cube([tray_width - 2*epsilon, 2*sqrt(2), 6]);
                    }
                }
            }
            
            // cut away the ears of the tray
            // where they jut through the curved handle
            translate([ tray_width/2,
                        -tray_length*0.5 + 7.5,
                        0]) {
                cylinder(
                    h=tray_depth + spacer_depth + pcb_depth,
                    r=tray_length*1.5,
                    center=false,
                    $fn=360);
            }
        }
        
        // place the 4 spacers
        for (a=[    [spacer_from_edge + spacer_center_width, 
                            ay ],
                    [spacer_from_edge,
                             by ],
                    [spacer_from_edge,
                            cy ],
                    [spacer_from_edge + spacer_center_width,
                            dy ],
                    [ex,
                            ey ],
                    [fx,
                            fy ]]) {
            translate([a[0], a[1], tray_depth-epsilon]) {
                // place the spacer
                cylinder(
                    h=spacer_depth + epsilon + spacer_depth_ext,
                    r=spacer_outer_radius,
                    center=false,
                    $fn=360);

                // place a small cone around it
                cylinder(
                    h=2 + epsilon,
                    r1=spacer_outer_radius + 1,
                    r2=spacer_outer_radius,
                    center=false,
                    $fn=360);
            }
        }

        // the tray insert edge tabs
        for (a=[    tray_insert_fudge,
                    tray_width - tray_insert_fudge]) {
            translate([ a,
                        0,
                        tray_depth/2]) {
                intersection() {
                    rotate([0, 45, 0]) {
                        translate([-tray_depth/sqrt(2)/2, 0, -tray_depth/sqrt(2)/2]) {
                            cube([  tray_depth/sqrt(2),
                                    tray_length,
                                    tray_depth/sqrt(2)]);
                        }
                    }
                    translate([-tray_depth/2+0.5, 0, -tray_depth/2]) {
                        cube([  tray_depth-1,
                                tray_length,
                                tray_depth]);
                    }
                }
            }
        }
    }

    // punch a hole in the bottom
    translate([ floor_window_border,
                floor_window_border,
                -epsilon]) {
        cube([  floor_window_width,
                floor_window_length - 55,
                tray_depth + 2*epsilon]);
    }
    
    // punch a hole in the bottom
    translate([ floor_window_border,
                floor_window_border + 33,
                -epsilon]) {
        cube([  floor_window_width,
                floor_window_length - 27,
                tray_depth + 2*epsilon]);
    }

    // drill the 4 screw holes
    for (a=[   [spacer_from_edge + spacer_center_width, 
                            ay ],
                    [spacer_from_edge,
                             by ],
                    [spacer_from_edge,
                            cy ],
                    [spacer_from_edge + spacer_center_width,
                            dy ],
                    [ex,
                            ey ],
                    [fx,
                            fy ]]) {
        translate([a[0], a[1], -epsilon]) {
            // drill the main screw hole
            cylinder(
                h=tray_depth + spacer_depth + spacer_depth_ext + 2*epsilon,
                r=screw_radius,
                center=false,
                $fn=360);

            // drill a recessed hole for the screw head
            cylinder(
                h=screw_head_depth + epsilon,
                r=screw_head_radius,
                center=false,
                $fn=360);
        }
    }
}