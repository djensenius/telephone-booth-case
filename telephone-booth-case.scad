// ============================================================================
// Telephone-Booth enclosure - TWO-BAY design
//   Front bay : GL.iNet MUDI 7 (GL-E5800) router, 157 x 75 x 22.8 mm,
//               lying flat SCREEN UP, resting in a cradle, removable.
//   Back  bay : Raspberry Pi 4B + 52Pi GPIO Screw Terminal HAT, fan on lid.
//
// Router body size confirmed from the Mudi 7 wall-mount bracket STLs
// (75 mm wide, 22.8 mm thick) + GL.iNet spec (157 mm long).
//
// Internal wiring path (why the divider has a big passage + slack room):
//   External USB-C inlet  ->  router power-in
//   router PD output      ->  Pi power
//   router Ethernet       ->  Pi Ethernet
//   Two panel RJ45 (GPIO) ->  52Pi screw-terminal HAT
//
// VERIFY-before-final items (no reliable drawing): screen window size/pos,
// power-button position, USB-C / HDMI / RJ45 flange cutouts.
//
// Render:  openscad -D 'part="base"' -o base.stl telephone-booth-case.scad
//          openscad -D 'part="lid"'  -o lid.stl  telephone-booth-case.scad
// ============================================================================

/* [What to render] */
part = "both";      // "base" | "lid" | "both" | "check"
$fn = 64;

/* [Shell] */
wall     = 2.4;
floor_th = 2.4;
roof_th  = 2.4;

/* [Raspberry Pi 4B] */
board_x    = 85;    // along X
board_y    = 56;    // along Y
board_th   = 1.4;
standoff_h = 6;     // lift PCB off floor
stack_h    = 28;    // PCB top -> top of 52Pi HAT + screw terminals
roof_gap   = 6;     // stack top -> roof
hole_dx    = 58;    // Pi mounting-hole rectangle (verified)
hole_dy    = 49;
hole_inset = 3.5;
post_od    = 7.0;
post_id    = 2.9;   // M2.5 clearance (screws driven up from underside)
cbore_d    = 5.6;
cbore_h    = 2.6;

/* [GL.iNet MUDI 7 router] */
rt_len = 157;       // along X
rt_wid = 75;        // along Y
rt_thk = 22.8;      // Z
rt_clr = 1.5;       // fit clearance around the body
ledge_w = 4;        // cradle ledge that the router rests on
ledge_t = 2.4;      // ledge thickness

/* [Bay layout] */
pi_front  = 12;     // board gap toward the divider
pi_back   = 30;     // deep zone behind board for connector plugs/cables
pocket_x  = rt_len + 2*rt_clr;         // router pocket X
pocket_y  = rt_wid + 2*rt_clr;         // router pocket Y
IX        = max(pocket_x, board_x + 40);   // shared cavity width
pi_bay_y  = board_y + pi_front + pi_back;  // Pi bay depth

inner_h = standoff_h + board_th + stack_h + roof_gap;   // cavity height
base_h  = floor_th + inner_h;
cradle_z = inner_h - rt_thk;            // ledge rest height above floor

/* [Snap-fit lid] */
lip_h   = 10;
lip_gap = 0.35;
snap_w  = 8;
snap_t  = 1.0;
snap_z  = 5;

/* [Fan - Noctua NF-A4x20] */
fan_hole_dx = 32;
fan_screw   = 4.4;  // clearance for supplied self-tapping screws (4.3 mm fan holes)
fan_bore    = 37;
grille_bar  = 2.4;
grille_gap  = 4.0;

/* [Router screen window - VERIFY] */
screen_w = 62;      // along X
screen_h = 48;      // along Y

/* [Ventilation] */
vent_slot_w = 3;
vent_slot_h = 9;
vent_gap    = 4;

/* [USB round hole] */
usb_hole_d = 22.6;  // 86-type threaded USB bulkhead

/* [Emboss label] */
label       = "Telephone Booth Case v.0.1";
emboss_h    = 0.8;  // raised height
lid_txt_sz  = 6;    // lid top face
wall_txt_sz = 4.5;  // base front wall

// ============================================================================
// Derived coordinates (absolute, origin at outer corner)
// ============================================================================
OUTX = IX + 2*wall;
IY   = wall + pocket_y + wall + pi_bay_y;   // interior depth (both bays + divider)
OUTY = IY + 2*wall;

router_cav_y0 = wall;                    // router cavity front
router_cav_y1 = wall + pocket_y;         // router cavity back (= divider front)
divider_y0    = router_cav_y1;
divider_y1    = router_cav_y1 + wall;
pi_cav_y0     = divider_y1;              // Pi cavity front
pi_cav_y1     = pi_cav_y0 + pi_bay_y;    // Pi cavity back

board_absx = wall + (IX - board_x)/2;
board_absy = pi_cav_y0 + pi_front;

// Divider cable passage (central, full height) for router<->Pi wiring.
// Router is retained by the pocket walls + cradle rim on its other 3 sides,
// so the divider only needs short end stubs; a wide passage gives the
// internal power/Ethernet cables plenty of room to route between bays.
pass_margin = 25;   // solid divider stub left at each end

// Snap X positions (front/back walls) - clear of the connectors.
snap_positions = [ OUTX*0.12, OUTX*0.50, OUTX*0.88 ];

// Fan + screen centres.
fan_cx = wall + IX/2;
fan_cy = pi_cav_y0 + pi_bay_y/2;
scr_cx = wall + pocket_x/2;
scr_cy = wall + pocket_y/2;

// ============================================================================
// PANEL-MOUNT CUTOUTS
// [ wall, shape, a, b, along, up, screw_spacing, screw_dia ]
//   rect: a=width across wall, b=height(Z).  circ: a=diameter.
//   along: offset from the wall's start corner.  up: centre height above floor.
// ============================================================================
panel_holes = [
    // Pi bay - BACK wall: two round USB 3.0 bulkheads (-> Pi USB-A).
    [ "back",  "circ", usb_hole_d, 0,  50, 26, 0,  0   ],
    [ "back",  "circ", usb_hole_d, 0, 110, 26, 0,  0   ],
    // Pi bay - LEFT wall: two RJ45 Ethernet for GPIO (-> 52Pi HAT). VERIFY.
    [ "left",  "rect", 16.5, 17, 108, 26, 20, 3.2 ],
    [ "left",  "rect", 16.5, 17, 150, 26, 20, 3.2 ],
    // Pi bay - RIGHT wall: HDMI (Pi video out). VERIFY.
    [ "right", "rect", 22, 15, 140, 24, 24, 3.0 ],
    // Router bay - RIGHT wall: USB-C power inlet (-> router power in). VERIFY.
    [ "right", "rect", 13, 8, 40, 14, 20, 2.6 ],
    // Router bay - FRONT wall: power-button access. VERIFY position.
    [ "front", "circ", 6, 0, 120, 30, 0, 0 ],
];

// ============================================================================
// Helper modules
// ============================================================================
module shell_box(sx, sy, sz, r=3) {
    hull() for (x=[r, sx-r], y=[r, sy-r])
        translate([x, y, 0]) cylinder(r=r, h=sz);
}

module panel_cutter(shape, a, b, screw_spacing, screw_dia) {
    L = wall * 4;
    if (shape == "rect") cube([a, L, b], center=true);
    else rotate([90,0,0]) cylinder(d=a, h=L, center=true);
    if (screw_spacing > 0)
        for (s=[-1,1]) translate([s*screw_spacing/2, 0, 0])
            rotate([90,0,0]) cylinder(d=screw_dia, h=L, center=true);
}

module place_panel(spec) {
    w_=spec[0]; shape=spec[1]; a=spec[2]; b=spec[3];
    along=spec[4]; up=spec[5]; ss=spec[6]; sd=spec[7];
    z = floor_th + up;
    if (w_ == "back")
        translate([wall+along, OUTY - wall/2, z]) panel_cutter(shape,a,b,ss,sd);
    else if (w_ == "front")
        translate([wall+along, wall/2, z]) panel_cutter(shape,a,b,ss,sd);
    else if (w_ == "left")
        translate([wall/2, wall+along, z]) rotate([0,0,90]) panel_cutter(shape,a,b,ss,sd);
    else if (w_ == "right")
        translate([OUTX - wall/2, wall+along, z]) rotate([0,0,90]) panel_cutter(shape,a,b,ss,sd);
}

module all_panels() { for (s = panel_holes) place_panel(s); }

// Pi board hole centres.
function pi_hole_pts() = [ for (x=[hole_inset, hole_inset+hole_dx],
                                y=[hole_inset, hole_inset+hole_dy])
                           [board_absx + x, board_absy + y] ];

module pi_standoffs() {
    for (p = pi_hole_pts())
        translate([p[0], p[1], floor_th]) cylinder(d=post_od, h=standoff_h);
}
module pi_standoff_holes() {
    for (p = pi_hole_pts()) translate([p[0], p[1], 0]) {
        translate([0,0,-0.1]) cylinder(d=post_id, h=floor_th+standoff_h+0.2);
        translate([0,0,-0.1]) cylinder(d=cbore_d, h=cbore_h+0.1);   // head counterbore
    }
}

// Cradle ledge around the router pocket (router rests on top of it).
module router_ledge() {
    z_top = floor_th + cradle_z;
    translate([0,0,z_top - ledge_t])
        difference() {
            translate([wall, router_cav_y0, 0])
                cube([pocket_x, pocket_y, ledge_t]);
            translate([wall+ledge_w, router_cav_y0+ledge_w, -0.5])
                cube([pocket_x-2*ledge_w, pocket_y-2*ledge_w, ledge_t+1]);
        }
}

// Central full-height passage through the divider for internal wiring.
module divider_passage() {
    translate([wall+pass_margin, divider_y0-1, floor_th])
        cube([IX-2*pass_margin, wall+2, inner_h+1]);
}

module vent_row(length, z0) {
    n = floor((length - vent_gap) / (vent_slot_w + vent_gap));
    span = n*(vent_slot_w+vent_gap) - vent_gap;
    start = (length - span)/2;
    for (i=[0:n-1])
        translate([start + i*(vent_slot_w+vent_gap), 0, z0])
            cube([vent_slot_w, wall*3, vent_slot_h]);
}

module snap_bump() {
    hull() {
        cube([snap_w, 0.1, 0.1]);
        translate([0, snap_t, -snap_t]) cube([snap_w, 0.1, 0.1]);
        translate([0, 0.1, -snap_z*0.9]) cube([snap_w, 0.1, 0.1]);
    }
}

// Raised label on the base front wall (above vents, clear of the button).
module base_label() {
    translate([wall + IX/2 - 12, 0, 30]) rotate([90, 0, 0])
        translate([0, 0, -0.1]) linear_extrude(emboss_h + 0.1)
            text(label, size=wall_txt_sz, halign="center", valign="center");
}

// Raised label on the lid top, between the screen window and the fan.
module lid_label() {
    translate([wall + IX/2, 90, roof_th - 0.1])
        linear_extrude(emboss_h + 0.1)
            text(label, size=lid_txt_sz, halign="center", valign="center");
}

// ============================================================================
// BASE
// ============================================================================
module base() {
    difference() {
        union() {
            difference() {
                shell_box(OUTX, OUTY, base_h);
                // router cavity
                translate([wall, router_cav_y0, floor_th])
                    cube([IX, pocket_y, inner_h+1]);
                // Pi cavity
                translate([wall, pi_cav_y0, floor_th])
                    cube([IX, pi_bay_y, inner_h+1]);
            }
            pi_standoffs();
            router_ledge();
        }
        all_panels();
        pi_standoff_holes();
        divider_passage();
        // ventilation: Pi back wall + router front wall (low rows)
        translate([0, OUTY - wall, floor_th+4]) vent_row(OUTX, 0);
        translate([0, wall,        floor_th+4]) vent_row(OUTX, 0);
    }
    // snap catches on front & back walls
    for (cx = snap_positions) {
        translate([cx - snap_w/2, OUTY - 0.1, base_h - snap_z]) snap_bump();
        translate([cx - snap_w/2, 0.1,        base_h - snap_z]) mirror([0,1,0]) snap_bump();
    }
    base_label();
}

// ============================================================================
// LID
// ============================================================================
module lid() {
    difference() {
        union() {
            shell_box(OUTX, OUTY, roof_th);
            // skirt overlapping the outer walls
            translate([0,0,-lip_h])
                difference() {
                    shell_box(OUTX, OUTY, lip_h);
                    translate([wall - lip_gap, wall - lip_gap, -1])
                        cube([IX + 2*lip_gap, IY + 2*lip_gap, lip_h + 2]);
                    translate([-1,-1,-1])
                        difference() {
                            cube([OUTX+2, OUTY+2, lip_h+2]);
                            translate([0 - lip_gap, 0 - lip_gap, 0])
                                cube([IX + 2*lip_gap + 2*wall, IY + 2*lip_gap + 2*wall, lip_h+2]);
                        }
                }
        }
        // fan bore + screw holes over the Pi bay
        translate([fan_cx, fan_cy, -1]) cylinder(d=fan_bore, h=roof_th+2);
        for (dx=[-1,1], dy=[-1,1])
            translate([fan_cx + dx*fan_hole_dx/2, fan_cy + dy*fan_hole_dx/2, -1])
                cylinder(d=fan_screw, h=roof_th+2);
        // screen window over the router bay
        translate([scr_cx - screen_w/2, scr_cy - screen_h/2, -1])
            cube([screen_w, screen_h, roof_th+2]);
        // snap recesses
        for (cx = snap_positions) {
            translate([cx - snap_w/2 - 0.5, OUTY - wall - 0.1, -snap_z - snap_t/2])
                cube([snap_w+1, wall+0.5, snap_t+1.2]);
            translate([cx - snap_w/2 - 0.5, -0.4, -snap_z - snap_t/2])
                cube([snap_w+1, wall+0.5, snap_t+1.2]);
        }
    }
    // fan grille bars
    intersection() {
        translate([fan_cx, fan_cy, 0]) cylinder(d=fan_bore+0.2, h=roof_th);
        union() {
            n = floor(fan_bore/(grille_bar+grille_gap));
            for (i=[0:n])
                translate([fan_cx - fan_bore/2 + i*(grille_bar+grille_gap),
                           fan_cy - fan_bore/2, 0])
                    cube([grille_bar, fan_bore, roof_th]);
        }
    }
    lid_label();
}

// ============================================================================
// Preview ghosts
// ============================================================================
module board_ghost() {
    translate([board_absx, board_absy, floor_th+standoff_h])
        cube([board_x, board_y, board_th]);
}
module router_ghost() {
    translate([wall + rt_clr, router_cav_y0 + rt_clr, floor_th + cradle_z])
        cube([rt_len, rt_wid, rt_thk]);
}

// ============================================================================
// Render selector
// ============================================================================
if (part == "base") base();
else if (part == "lid") translate([0,0,base_h + lip_h]) mirror([0,0,1]) lid();
else if (part == "check") { base(); %board_ghost(); %router_ghost(); }
else { base(); translate([0,0,base_h]) lid(); }
