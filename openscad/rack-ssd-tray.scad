/**
 * SSD Tray for NVMe
 * Version: 0.1
 * History
 * | 0.1 | Initial
 */



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

leftsupportw = 6;
supporth = 44;
leftsupportd = tray_length;

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
        
        // add ssd pcb back
        supportw = tray_width-0.5;
        supporth = 44;
        supportd = tray_length; //tray_length;
        
        translate([ tray_width/2 - supportw/2, tray_length - supportd, 0]) {
            cube( [ supportw, supportd - 96, tray_depth + supporth - 6]);
        }
        
        // add ssd pcb left support
        translate([ 0, tray_length - leftsupportd, 0]) {
            cube( [ leftsupportw, leftsupportd, tray_depth + supporth - 6]);
        }
    }
    
    // punch a hole in the bottom
    translate([ floor_window_border,
                floor_window_border,
                -epsilon]) {
        cube([  floor_window_width,
                floor_window_length,
                tray_depth + 2*epsilon]);
    }

    // add slots
    pcbslotw = 44;
    pcbsloth = 1.5;
    pcbslotd = tray_length + 3;
    y = 6;
    slotgap = 8;

    for ( i=[1:5]) {
        translate([ 
            tray_width/2 - tray_width/2 + 3, 
            tray_length - pcbslotd + 6, 
            y + (slotgap*i)]) {
            cube([pcbslotw, pcbslotd + 12, tray_depth + pcbsloth - 6]);
        }
    }
    
    // add back recess to accommodate any screw holders for SSD
    recessw = 20;
    recessh = 22;
    recessd = tray_length;
    translate([ tray_width/2 - recessw/2 - 3, tray_length - recessd + 4, 12]) {
//            color("red")
        cube( [ recessw, recessd - 96 - 4, tray_depth + recessh + 2]);
    }
    
}