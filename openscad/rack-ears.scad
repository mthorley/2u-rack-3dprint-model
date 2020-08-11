include <rack-config.scad>

/* [Bolt holes in the corners] */

// Pick the size of the long threaded rods that run through
// the corners and hold everything together.
//
// These are the sizes that are commonly available at
// Home Depot or Lowes:
//
// 1/4 inch: 3.175
// #12     : 2.778125
// #10     : 2.38125 (default and recommended)
//

// Make the bolt holes this much bigger than the size of the bolt
// to give a more comfortable fit
bolt_hole_fudge = 0.2; // [0:0.25:1]


/* [Notches for attaching to the frame parts] */

// You can optionally omit the notches for one ear that will
// join with a frame on the side that has no tabs.
// For the the other you should leave this at its default of true.
notches_enabled = true;

// Make the slot this much taller than the tabs
// to give a more comfortable fit.
notch_fudge = 0.3; // [0:0.25:1]


/* [Bolt holes for mounting to the rack] */

// The size of the bolt holes for mounting to the server rack.
// The default is for M6 bolts.
ear_bolt_size = 3;

// Make the ear bolt holes this much longer than they are wide
// in case the entire assembled rack is not precisely the right
// length.
ear_bolt_stretch = 3;


/* [Hidden] */

width = 82;
height = 5;
frame_width = 15.875;
distance_to_frame = 10;
distance_between_bolt_holes = 15.875 * 2 + 12.7;
ear_height = distance_to_frame + frame_width;

notch_height = 2;
outer_wall_thickness = 12;
inner_wall_thickness = 7;
back_wall_thickness = 5;
wall_diff = outer_wall_thickness - inner_wall_thickness;
floor_depth = 3;
tray_depth = 5;
tray_slot_depth = 2.5;
spacer_depth = 3;
epsilon = 0.001;

length = device_length + back_wall_thickness;

sd_window_width = 40;
sd_window_height = height - (tray_depth + floor_depth)*2;
near_pillar_width = 15;
far_pillar_width = 10;
floor_window_width = sd_window_width;
floor_window_border = (width - floor_window_width - outer_wall_thickness*2) / 2;
floor_window_length = length - back_wall_thickness - floor_window_border*2;
port_window_width = length - near_pillar_width - far_pillar_width;
port_window_frame_height = floor_depth + tray_depth + spacer_depth - notch_height;

bolt_radius = bolt_size + bolt_hole_fudge;

ear_bolt_radius = ear_bolt_size + bolt_hole_fudge;
floor_mini_window_width = (floor_window_width - floor_window_border) / 2;
floor_mini_window_length = (floor_window_length - floor_window_border) / 2;

difference() {
    union() {
        // the main tray block
        translate([0, -epsilon, 0]) {
            cube([width, length + epsilon, height]);
        }
        
        // the ear
        translate([0, -height, 0]) {
            cube([width, height, ear_height]);
        }
        
        // reinforce the joint
        translate([0, 0, 0]) {
            rotate([45, 0, 0]) {
                cube([width, height-0.5, height-0.5]);
            }
        }
        
        translate([ (width - distance_between_bolt_holes)/2 - ear_bolt_radius, 0, 0]) {
            rotate([45, 0, 0]) {
                cube([distance_between_bolt_holes + 2*ear_bolt_radius, height+1, height+1]);
            }
        }
    }
    
    // cut the bolt holes
    for (a=[[outer_wall_thickness/2, near_pillar_width/2],
            [outer_wall_thickness/2, length - far_pillar_width/2],
            [width - outer_wall_thickness/2, near_pillar_width/2],
            [width - outer_wall_thickness/2, length - far_pillar_width/2]]) {
        translate([a[0], a[1], -epsilon]) {
            cylinder(   h=height + 2*epsilon,
                        r=bolt_radius,
                        center=false,
                        $fn=360);
        }
    }

    // make the sides thinner
    polyhedron(
        points = [
            [ wall_diff, length-far_pillar_width-wall_diff, height+notch_height+epsilon],
            [ wall_diff, near_pillar_width+wall_diff,       height+notch_height+epsilon],
            [ wall_diff, length-far_pillar_width-wall_diff, -epsilon],
            [ wall_diff, near_pillar_width+wall_diff,       -epsilon],
            [-wall_diff, length-far_pillar_width+wall_diff, height+notch_height+epsilon],
            [-wall_diff, near_pillar_width-wall_diff,       height+notch_height+epsilon],
            [-wall_diff, length-far_pillar_width+wall_diff, -epsilon],
            [-wall_diff, near_pillar_width-wall_diff,       -epsilon]
        ],
        faces = [
            [1,0,2,3],
            [4,5,7,6],
            [0,4,6,2],
            [6,7,3,2],
            [7,5,1,3],
            [5,4,0,1]
        ],
        convexity = 10);
    polyhedron(
        points = [
            [width-wall_diff, near_pillar_width+wall_diff,       height+notch_height+epsilon],
            [width-wall_diff, length-far_pillar_width-wall_diff, height+notch_height+epsilon],
            [width-wall_diff, near_pillar_width+wall_diff,       -epsilon],
            [width-wall_diff, length-far_pillar_width-wall_diff, -epsilon],
            [width+wall_diff, near_pillar_width-wall_diff,       height+notch_height+epsilon],
            [width+wall_diff, length-far_pillar_width+wall_diff, height+notch_height+epsilon],
            [width+wall_diff, near_pillar_width-wall_diff,       -epsilon],
            [width+wall_diff, length-far_pillar_width+wall_diff, -epsilon]
        ],
        faces = [
            [1,0,2,3],
            [4,5,7,6],
            [0,4,6,2],
            [6,7,3,2],
            [7,5,1,3],
            [5,4,0,1]
        ],
        convexity = 10);

    if (notches_enabled) {
        // cut the notches
        translate([ wall_diff - epsilon,
                    near_pillar_width + wall_diff,
                    -epsilon]) {
            cube([  inner_wall_thickness-2 + epsilon,
                    length - near_pillar_width - far_pillar_width - 2*wall_diff,
                    notch_height + notch_fudge + epsilon]);
        }
        translate([ width - wall_diff - (inner_wall_thickness-2),
                    near_pillar_width + wall_diff,
                    -epsilon]) {
            cube([  inner_wall_thickness-2 + epsilon,
                    length - near_pillar_width - far_pillar_width - 2*wall_diff,
                    notch_height + notch_fudge + epsilon]);
        }
    }
    
    // cut some mini windows in the floor
    for (a=[[outer_wall_thickness + floor_window_border,
                floor_window_border],
            [width - outer_wall_thickness - floor_window_border - floor_mini_window_width,
                floor_window_border],
            [outer_wall_thickness + floor_window_border,
                2*floor_window_border + floor_mini_window_length],
            [width - outer_wall_thickness - floor_window_border - floor_mini_window_width,
                2*floor_window_border + floor_mini_window_length]]) {
        translate([a[0], a[1], -epsilon]) {
            cube([  floor_mini_window_width,
                    floor_mini_window_length,
                    height + 2*epsilon]);
        }
    }
    
    // cut the bolt holes on the ear
    for (a=[    width/2 - distance_between_bolt_holes/2,
                width/2 + distance_between_bolt_holes/2]) {
        for (b=[-ear_bolt_stretch/2, ear_bolt_stretch/2]) {
            translate([ a,
                        -height-epsilon,
                        ear_height - frame_width/2 + b]) {
                rotate([-90,0,0]) {
                    cylinder(   h=height + 2*epsilon,
                                r=ear_bolt_radius,
                                center=false,
                                $fn=360);
                }
            }
        }
        translate([ a - ear_bolt_radius,
                    -height-epsilon,
                    ear_height - frame_width/2 - ear_bolt_stretch/2]) {
            cube([  ear_bolt_radius*2,
                    height + 2*epsilon,
                    ear_bolt_stretch]);
        }
    }
}