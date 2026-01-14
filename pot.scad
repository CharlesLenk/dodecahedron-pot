include <openscad-utilities/common.scad>

// Diameter of the circumsphere.
default_size = 130;
edge_diameter = 8;
wall_width = 1.6;
bottom_width = 2;

function get_default_size() = default_size;
function calc_height(size) = size/2 * golden_ratio;
function calc_slice_height(size) = 0.85 * calc_height(size);

module pot(size = default_size) {
    height = calc_height(size);
    slice_height = calc_slice_height(size);
    insert_top_offset = 0.1;
    difference() {
        dodecahedron_base(height);
        translate([-height/2, -height/2, slice_height - wall_width - insert_top_offset]) {
            cube([height, height, height]);
        }
        core_cut(size);
   }
}

module insert(size = default_size) {
    height = calc_height(size);
    slice_height = calc_slice_height(size);
    insert_wall_offset = 0.15;
    insert_bottom_offset = wall_width + insert_wall_offset + 3;
    difference() {
        union() {
            lip_slice();
            offset_cut(insert_bottom_offset, slice_height, insert_wall_offset)
                core_cut(size);
        }
        fix_preview()
            offset_cut(insert_bottom_offset + bottom_width, slice_height, wall_width + insert_wall_offset)
                core_cut(size);
        translate([0, 0, bottom_width + insert_bottom_offset])
            drain_cuts(size);
    }

    module lip_slice() {
        intersection() {
            dodecahedron_base(height);
            translate([-height/2, -height/2, slice_height - wall_width])
                cube([height, height, wall_width]);
        }
    }
}

module drain_cuts(size) {
    cut_size = 5;
    drain_count = floor((0.3 * size * PI) / (10 + cut_size));
    for (i = [0 : drain_count - 1])
        rotate([0, -90, i * (360 / drain_count)])
            translate([0, -cut_size/2])
                tombstone([cut_size, cut_size, size/2]);
}

function get_radius_inscribed_in_face(size) =
    let (
        height = calc_height(size),
        edge_len = height / 2.227,
        radius = edge_len / (2 * tan(36))
    ) radius;

module core_cut(size) {
    height = calc_height(size);
    slice_height = calc_slice_height(size);
    top_lip_width = 4;
    face_angle = 26.565;
    rad = get_radius_inscribed_in_face(size);

    radius_at_cut_height = rad + get_opposite(face_angle, adjacent = height - slice_height) - top_lip_width;
    lower_radius = radius_at_cut_height * cos(36);

    hull() {
        translate([0, 0, slice_height])
            linear_extrude(0.001)
                fillet_2d(edge_diameter/2)
                    circle(r = radius_at_cut_height / cos(36), $fn = 5);
        translate([0, 0, bottom_width])
            linear_extrude(0.001)
                circle(lower_radius);
    }
}

module offset_cut(h1, h2, cut_offset = 0) {
    hull() {
        offset_slice_at_height(h1, -cut_offset)
            children();
        offset_slice_at_height(h2, -cut_offset)
            children();
    }
}

module offset_slice_at_height(slice_height, slice_offset, scale = [1, 1]) {
    translate([0, 0, slice_height])
        linear_extrude(0.001)
            offset(slice_offset)
                scale(scale)
                    projection(cut = true)
                        translate([0, 0, -slice_height])
                            children();
}

module dodecahedron_base(height) {
    translate([0, 0, height/2])
        dodecahedron(height, edge_diameter);
}
