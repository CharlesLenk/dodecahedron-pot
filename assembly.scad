include <openscad-utilities/common.scad>
use <pot.scad>

size = get_default_size();

translate([0, -size])
    assembly(size, cross_section = true);

assembly(
    size,
    with_insert = false,
    cross_section = true
);

translate([0, size])
    assembly(
        size,
        with_pot = false,
        cross_section = true
    );

module assembly(size, with_pot = true, with_insert = true, cross_section = false) {
    height = calc_height(size);
    difference() {
        union() {
            if (with_pot)
                pot(size);
            if (with_insert)
                insert(size);
        }
        if (cross_section)
            cube([height, height, height]);
    }
}
