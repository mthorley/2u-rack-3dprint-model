include <rack-config.scad>

/* [Screw holes for attaching the Raspberry Pi 4] */

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

// adjust length if housing arduino
tray_rpi_length = 85;        // rpi tray length
tray_length = device_length;
tray_offset = device_length - tray_rpi_length;

tray_depth = 5;
tray_lip_overhang = 10;

inner_wall_thickness = 5;
spacer_depth = 3;
spacer_outer_radius = 3;

screw_radius = 1.5 + screw_hole_fudge;  //M3.
pcb_depth = 2;
spacer_center_width = 49;
spacer_center_length = 58;
spacer_from_edge = (tray_width - spacer_center_width) / 2;

sd_window_width = 40;
floor_window_width = sd_window_width;
floor_window_border = (tray_width - floor_window_width) / 2;
floor_window_length = tray_length - floor_window_border*2 - inner_wall_thickness;

epsilon = 0.001;

// add oled base
oledw = 46;
oledh = 44;
oledd = 46;

// oled screen
screenw = 34.5;
screenh = 34.5;


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
        
        // oled cube
        // -4 set back from tray front
        translate([ tray_width/2 - oledw/2, tray_length - oledd - 4, 0]) {
            cube( [ oledw, oledd, tray_depth + oledh - 6]);
        }

    }

    // cut out space for 2x4 connector
    translate([ tray_width/2 + screenw/2 - 22, 76, tray_depth + 30]) {
        color("red")
        cube( [ 22, 20, 10 ]);
    }


    // cut out cylinder to create arc for oled cube
    extend = 4;
    translate([tray_width/2 - oledw/2 - extend, 54 - 10, tray_depth + oledh]) {
        rotate([90, 0, 90]) {
            cylinder (h=50 + extend*2, r=44, $fn=360);
        }
    }
    
    // cut out oled screen
    translate([ tray_width/2 - screenw/2, 91, tray_depth + 4]) {
        cube( [ screenw, 7, screenh ]);
    }
    
    sidew = 5;
    
    // cut out oled screen L rear
    translate([ tray_width/2 - screenw/2 - 2*sidew, 56, tray_depth + 4]) {
        color("blue")
        cube( [ 2*sidew + 1, 32, screenh + 6 ]);
    }
    
    // cut out oled screen R rear
    translate([ tray_width/2 + screenw/2 - 1, 56, tray_depth + 4]) {
                color("blue")
        cube( [ 2*sidew + 1, 32, screenh + 6 ]);
    }

    // cut out oled screen L front
    translate([ tray_width/2 - screenw/2 - 2*sidew, 95, tray_depth + 4]) {
    color("gray")
        cube( [ 2*sidew+1, 3, screenh ]);
    }

    // cut out oled screen R front
    translate([ tray_width/2 + screenw/2, 95, tray_depth + 4]) {
    color("gray")
        cube( [ 2*sidew+1, 3, screenh ]);
    }

    // drill the 4 screw holes
    offset = -2.5;
    // dist between screw holes
    x = 39;
    y = 27.5;
    for (a=[    [-oledh + screw_radius*2,
                    oledw - offset],
                [-oledh + screw_radius*2 + y,
                    oledw - offset],
                [-oledh + screw_radius*2,
                    oledw - x - offset ],
                [-oledh + screw_radius*2 + y,
                    oledw - x - offset ]]) {
                        
       rotate ([90, 90, 0]) {
            translate([a[0], a[1], -epsilon - tray_length + 6.5]) {
                // drill the main screw hole
                cylinder(
                    h= 6 + spacer_depth + 2*epsilon,
                    r=screw_radius,
                    center=false,
                    $fn=360);
            }
        }
    }
    
    /* punch a hole in the bottom */
    translate([ floor_window_border,
                floor_window_border,
                -epsilon]) {
        cube([  floor_window_width,
                floor_window_length -40,
                tray_depth + 2*epsilon]);
    }
    
}