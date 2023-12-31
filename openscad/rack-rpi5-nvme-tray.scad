include <rack-config.scad>

/**
 * RPi5 and NVMe modifications to sink or cutin the PCB supports
 * in order to create more depth.
 * Estimated extra depth created (until Pimoroni board available) is:
 *  - tray_cutin 2.5mm = 2.5mm extra
 *  - reduced spacer depth from 3 to 2.5 (since Pimoroni board is flat) = 0.5mm extra 
 *  - 5mm available in height already between next bracket 
 *  - total = 8mm.
 *
 Pimoroni estimate height:
 - 1.57mm PCB
 - 4mm PCIe M connector
 - approx 6mm
 * Version: 0.1
 * History
 * | 0.1 | Initial
 */

/* [Screw holes for attaching the Raspberry Pi 5] */

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

// RPi5 and NVMe new var
// 'tray_cutin' - sinks the tray by cutin mm to allow space for NVMe base
//  0 - no cutin; as per RPi4 tray
tray_cutin = 2.5;
tray_lip_overhang = 10;

inner_wall_thickness = 5;
// RPi5 and NVMe var change
// spacer_depth = 3; // for RPi4
spacer_depth = 2.5;
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

difference() {
    union() {
h_ = 10;
        // the main tray
        intersection() {
            union() {
                translate([tray_insert_fudge, 0, 0]) {
                    cube([  tray_width - 2*tray_insert_fudge,
                            tray_length + tray_lip_overhang,
                            tray_depth - tray_cutin]);
                }

                
                difference() {
                    // the outer part of the curved handle
                    translate([ tray_width/2,
                                -tray_length*0.5 + 7.5,
                                0]) {
                        cylinder(
                              h=h_,
//                            h=tray_depth - tray_cutin + spacer_depth + pcb_depth,
                            r=tray_length*1.5,
                            center=false,
                            $fn=360);
                    }
                    
                    // cut away the inside to make it a shell
                    translate([ tray_width/2,
                                -tray_length*0.5 + 5.4,
                                -epsilon]) {
                        cylinder(
                              h=h_ + 2*epsilon,
//                            h=tray_depth  + spacer_depth + pcb_depth + 2*epsilon,
                            r=tray_length*1.5,
                            center=false,
                            $fn=360);
                    }
                    translate([ tray_width,
                                -tray_length,
                                -epsilon]) {
                        cube([  2.2*tray_width,
                                3*tray_length,
                                h_ + 2*epsilon]);
//                                tray_depth + spacer_depth + pcb_depth + 2*epsilon]);
                    }
                    translate([ -2.2*tray_width,
                                -tray_length,
                                -epsilon]) {
                        cube([  2.2*tray_width,
                                3*tray_length,
                                h_ + 2*epsilon]);
 //                               tray_depth + spacer_depth + pcb_depth + 2*epsilon]);
                    }
                }
                
                // reinforce the curved handle
                translate([epsilon, tray_length, tray_depth - tray_cutin]) {
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
//                    h=tray_depth - tray_cutin + spacer_depth + pcb_depth,
                    h=h_,
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
            translate([a[0], a[1], tray_depth - tray_cutin - epsilon]) {
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
                floor_window_border,
                -epsilon]) {
        cube([  floor_window_width,
                floor_window_length,
                tray_depth + 2*epsilon]);
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