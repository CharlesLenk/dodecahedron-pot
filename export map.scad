include <openscad-utilities/common.scad>
include <defaults.scad>
use <pot.scad>

size = default_size;
name = "";

if (name == "pot")
    rotate([180, 0, 0]) pot(size);
else if (name == "insert")
    rotate([180, 0, 0]) insert(size);
