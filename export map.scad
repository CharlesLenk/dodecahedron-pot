include <openscad-utilities/common.scad>
use <pot.scad>

name = "";
size = get_default_size();

if (name == "pot")
    rotate([180, 0, 0]) pot(size);
else if (name == "insert")
    rotate([180, 0, 0]) insert(size);
