include <rack-config.scad>

/**
 * RPi4 modifications to allow an NVMe PCB to cut into the tray base.
 * Version: 0.1
 * History
 * | 0.1 | Initial
 */

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
spacer_depth = 4;   // 3; for RPi4 tray
spacer_outer_radius = 3;

screw_radius = 1.25 + screw_hole_fudge;
screw_head_radius = 3;
screw_head_depth = 2;
pcb_depth = 2;
spacer_center_width = 49;
spacer_center_length = 58;
spacer_from_edge = (tray_width - spacer_center_width) / 2;

sd_window_width = 40;
floor_window_width = sd_window_width;
floor_window_border = (tray_width - floor_window_width) / 2;
floor_window_length = tray_length - floor_window_border*2 - inner_wall_thickness;

epsilon = 0.001;

// Dimensions
// For Fideco M.2 NVME External SSD Enclosure - USB3.1 | PCB labelled: M203CPS-RLTL9210B 
nvme_width = 30;
nvme_length = 102;
nvme_height = 4;
nvme_indent = 3;

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
                            h=10,   // this is independent of spacer depth since the RPi4 will sit above
//                            h=tray_depth + spacer_depth + pcb_depth,
                            r=tray_length*1.5,
                            center=false,
                            $fn=360);
                    }
                    
                    // cut away the inside to make it a shell
                    translate([ tray_width/2,
                                -tray_length*0.5 + 5.4,
                                -epsilon]) {
                        cylinder(
                            h=tray_depth  + spacer_depth + pcb_depth + 2*epsilon,
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
        for (a=[    [spacer_from_edge,
                        spacer_from_edge + tray_offset],
                    [spacer_from_edge + spacer_center_width,
                        spacer_from_edge + tray_offset],
                    [spacer_from_edge,
                        spacer_from_edge + spacer_center_length + tray_offset],
                    [spacer_from_edge + spacer_center_width,
                        spacer_from_edge + spacer_center_length+ tray_offset]]) {
            translate([a[0], a[1], tray_depth - epsilon]) {
                // place the spacer
                cylinder(
                    h=spacer_depth + epsilon,
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
                floor_window_border+6,
                -epsilon]) {
        cube([  floor_window_width,
                floor_window_length-6,
                tray_depth + 2*epsilon]);
    }

    // punch a hole for the nvme usb pcb - box
    translate([tray_width/2 - nvme_width/2 + nvme_indent/2, 8, -epsilon]) {
        cube([  nvme_width - nvme_indent,
                nvme_length,
                nvme_height+4]);
    }

    // punch a hole for the nvme usb pcb - slice
    translate([ tray_width/2 - nvme_width/2 - (nvme_indent/2)/2,
                8,
                -epsilon+2]) {
        cube([  nvme_width + nvme_indent/2,
                nvme_length,
                nvme_height-2.5]);
    }

    // drill the 4 screw holes
    for (a=[    [spacer_from_edge,
                    spacer_from_edge + tray_offset],
                [spacer_from_edge + spacer_center_width,
                    spacer_from_edge + tray_offset],
                [spacer_from_edge,
                    spacer_from_edge + spacer_center_length + tray_offset],
                [spacer_from_edge + spacer_center_width,
                    spacer_from_edge + spacer_center_length + tray_offset]]) {
        translate([a[0], a[1], -epsilon]) {
            // drill the main screw hole
            cylinder(
                h=tray_depth + spacer_depth + 2*epsilon,
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