#!/usr/bin/env bash
# Render the print-ready STLs and all preview images for the Telephone Booth Case.
# Keep previews/ in sync whenever the geometry or embossed version changes.
#
# Requires the arm64 OpenSCAD snapshot (the regular cask is Intel-only):
#   brew install --cask openscad@snapshot
set -euo pipefail

OSC="${OPENSCAD:-/opt/homebrew/bin/openscad}"
SRC="telephone-booth-case.scad"
CS="Tomorrow Night"
P="previews"

echo "== STLs =="
"$OSC" -D 'part="base"' -o base.stl "$SRC"
"$OSC" -D 'part="lid"'  -o lid.stl  "$SRC"

echo "== previews =="
shot() { # part projection "camX,camY,camZ,cx,cy,cz" WxH outfile
    local part="$1" proj="$2" cam="$3" size="$4" out="$5"
    "$OSC" -D "part=\"$part\"" --colorscheme="$CS" --projection="$proj" \
        --camera="$cam" --viewall --autocenter --imgsize="$size" \
        -o "$P/$out" "$SRC"
}

shot check ortho "0,-1,600,0,0,0"       1000,1120 1_layout_top.png
shot base  perspective "-120,-150,220,0,0,0" 1100,850  2_interior_iso.png
shot both  perspective "-140,-180,170,0,0,0" 1100,850  3_assembled_lid.png
shot both  perspective "-120,-160,-190,0,0,0" 1100,850 4_assembled_under.png
shot base  perspective "45,-180,130,0,0,0"   1100,850  5_interior_router_end.png
shot base  perspective "-200,-130,150,0,0,0" 1100,850  6_interior_dongle_end.png
shot base  perspective "120,120,170,0,0,0"   1100,850  7_interior_rear.png
shot base  ortho "0,-600,0,0,0,0"            1100,480  label_base.png
shot lid   ortho "0,-1,600,0,0,0"            1000,1000 label_lid.png

echo "done"
