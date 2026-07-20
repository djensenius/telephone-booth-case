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
rt_clr = 0.75;      // fit clearance around the body (snug: walls hug the router)
case_clr = 1.5;     // clearance the OUTER footprint is sized for (FIXED) - the box
                    // stays this size no matter how snug rt_clr makes the pocket;
                    // reclaimed space becomes dongle clearance + rear cable room
ledge_w = 4;        // cradle ledge that the router rests on
ledge_t = 2.4;      // ledge thickness
dongle_gap = 10.5;  // base clearance at the router's dongle (LEFT) end; the snug
                    // pocket adds any reclaimed width on top of this

/* [Cradle supports] */
sup_top_w = 12;     // support cap length along the rim (meets the ledge)
sup_foot  = 3;      // tapered support foot at the floor (less bridging -> less stringing)

/* [Bay layout] */
pi_front  = 12;     // board gap toward the divider
pi_back   = 65;     // deep zone behind board: right-angle USB-A plugs + flat-cable routing
pocket_x  = rt_len + 2*rt_clr;         // snug router pocket X (walls hug the body)
pocket_y  = rt_wid + 2*rt_clr;         // snug router pocket Y
router_bay_x = rt_len + 2*case_clr;    // front-bay footprint X (fixed via case_clr)
router_bay_y = rt_wid + 2*case_clr;    // front-bay footprint Y (fixed via case_clr)
IX        = max(router_bay_x + dongle_gap, board_x + 40);   // box width - fixed, NOT tied to the snug pocket
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

/* [Panel round holes] */
usb_hole_d  = 22.6;  // 86-type threaded USB bulkhead
hdmi_hole_d = 21.5;  // panel-mount waterproof HDMI bulkhead (21 mm thread, cut Ø21.5)
btn_hole_d  = 16.6;  // 16 mm rugged metal RGB pushbutton (Adafruit 3350) - opened up for fit

/* [USB audio adapter cradle - US205] */
// Holds the US205 USB stereo sound adapter (drives the phone handset audio) in
// the Pi bay's rear cable zone so it can't rattle loose. Body size ESTIMATED
// from IMG_2489 scaled against the Pi board (~25.7 px/mm) - VERIFY with calipers.
aud_len    = 56;    // adapter body length along X
aud_wid    = 20;    // adapter body width  along Y (incl. a little clearance)
aud_slot_d = 9;     // how deep the body seats into the cradle ribs
aud_floor  = 2;     // material below the body
aud_wall   = 2.4;   // cradle side-wall thickness
aud_rib    = 3;     // rib thickness along X
aud_lip    = 0.6;   // inward retention nub at each rib's mouth (light snap)
aud_x0     = wall + 40;  // cradle left edge - clear of the deep left-wall ethernet keystones

/* [Emboss label] */
label       = "Telephone Booth Case v.0.3";
author      = "David Jensenius";
contact     = "david@jensenius.com";
emboss_h    = 0.8;  // raised height (base front wall)
deboss_d    = 0.6;  // recessed depth (lid top - engraved so it prints cleanly)
lid_txt_sz  = 6;    // lid top face
wall_txt_sz = 4.5;  // base front wall

// ============================================================================
// Derived coordinates (absolute, origin at outer corner)
// ============================================================================
OUTX = IX + 2*wall;
IY   = wall + router_bay_y + wall + pi_bay_y;   // interior depth (front bay uses the fixed footprint)
OUTY = IY + 2*wall;

router_cav_y0 = wall;                    // router cavity front
router_cav_y1 = wall + router_bay_y;     // router cavity back = divider front (fixed)
divider_y0    = router_cav_y1;
divider_y1    = router_cav_y1 + wall;
pi_cav_y0     = divider_y1;              // Pi cavity front
pi_cav_y1     = pi_cav_y0 + pi_bay_y;    // Pi cavity back

board_absx = wall + (IX - board_x)/2;
board_absy = pi_cav_y0 + pi_front;

// Router pocket left origin: the router is pushed hard against the RIGHT wall so
// ALL reclaimed width lands as dongle clearance on its LEFT (min-X) end.
rt_x0 = wall + IX - pocket_x;

// Router front-face rest Y. The bay is hollowed full width, so the router is
// located in Y only by the ledge + the mid-span stabilizer fins. It rests a
// touch further back than rt_clr so the front fin has real thickness.
rt_front = router_cav_y0 + 1.75;
fin_play = 0.2;   // clearance between each stabilizer fin and the router face

// Divider cable passage (central, full height) for router<->Pi wiring.
// Router is retained by the pocket walls + cradle rim on its other 3 sides,
// so the divider only needs short end stubs; a wide passage gives the
// internal power/Ethernet cables plenty of room to route between bays.
pass_margin = 25;   // solid divider stub kept near the USB-C (right/max-X) end
open_left   = true; // remove the divider on the LEFT end so the router ethernet
                    // door can open and the dongle power cable can reach the Pi

// Snap X positions (front/back walls) - clear of the connectors.
snap_positions = [ OUTX*0.12, OUTX*0.50, OUTX*0.88 ];

// Fan + screen centres.
// Fan centred over the Pi board (not the bay) so it keeps cooling the SoC
// regardless of how deep the rear cable zone is.
fan_cx = wall + IX/2;
fan_cy = board_absy + board_y/2;
scr_cx = rt_x0 + pocket_x/2;
scr_cy = wall + pocket_y/2;

// ============================================================================
// PANEL-MOUNT CUTOUTS
// [ wall, shape, a, b, along, up, screw_spacing, screw_dia ]
//   rect: a=width across wall, b=height(Z).  circ: a=diameter.
//   along: offset from the wall's start corner.  up: centre height above floor.
// ============================================================================
panel_holes = [
    // Pi bay - BACK wall: ONE round USB 3.0 bulkhead (-> Pi USB-A). The second
    // USB was dropped (that Pi port now drives the USB audio adapter internally),
    // and the HDMI bulkhead was relocated here to take its place.
    [ "back",  "circ", usb_hole_d,  0,  50, 26, 0,  0   ],
    [ "back",  "circ", hdmi_hole_d, 0, 110, 26, 0,  0   ],
    // Pi bay - LEFT wall: two RJ45 Ethernet keystones (-> 52Pi HAT GPIO).
    // Screw-mount breakout: 16.5 x 13.1 mm port window, screws 24.5 mm apart,
    // body ~37 mm deep into the bay (clears the Pi board; see note below).
    // Port window raised to 15 mm tall - the 13.1 mm opening printed too tight.
    [ "left",  "rect", 16.5, 15, 108, 26, 24.5, 3.2 ],
    [ "left",  "rect", 16.5, 15, 150, 26, 24.5, 3.2 ],
    // Pi bay - RIGHT wall: 16 mm rugged metal RGB pushbutton = Pi power button.
    // Round hole opened up slightly (16 -> btn_hole_d) for an easier fit.
    [ "right", "circ", btn_hole_d, 0, 180, 24, 0, 0 ],
    // Router bay - RIGHT wall: USB-C power inlet (-> router power in). VERIFY.
    [ "right", "rect", 13, 8, 40, 7, 23.5, 2.6 ],
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

// USB audio adapter cradle: two U-channel ribs (spanning the body's width in Y,
// thin in X) joined by a thin floor strap, sitting just behind the Pi board in
// the rear cable zone. The body drops in from the top and is lightly captured by
// an inward lip at each rib's mouth.
aud_yc = board_absy + board_y + 6 + aud_wid/2;   // centre Y, just behind the board

module audio_rib() {
    top = aud_floor + aud_slot_d;
    difference() {
        translate([-aud_rib/2, -(aud_wid/2 + aud_wall), 0])
            cube([aud_rib, aud_wid + 2*aud_wall, top]);
        // main slot, full body width, up to just below the mouth
        translate([-aud_rib/2 - 1, -aud_wid/2, aud_floor])
            cube([aud_rib + 2, aud_wid, aud_slot_d - 1.2 + 0.01]);
        // narrower mouth -> leaves an inward retention lip on each side
        translate([-aud_rib/2 - 1, -(aud_wid/2 - aud_lip), aud_floor + aud_slot_d - 1.2])
            cube([aud_rib + 2, aud_wid - 2*aud_lip, 1.2 + 1]);
    }
}
module audio_cradle() {
    for (cx = [aud_x0 + aud_rib/2, aud_x0 + aud_len - aud_rib/2])
        translate([cx, aud_yc, floor_th]) audio_rib();
    // floor strap tying the ribs together
    translate([aud_x0, aud_yc - (aud_wid/2 + aud_wall), floor_th])
        cube([aud_len, aud_wid + 2*aud_wall, 1.6]);
}

// Cradle ledge around the router pocket (router rests on top of it).
module router_ledge() {
    z_top = floor_th + cradle_z;
    translate([0,0,z_top - ledge_t])
        difference() {
            translate([rt_x0, router_cav_y0, 0])
                cube([pocket_x, pocket_y, ledge_t]);
            translate([rt_x0+ledge_w, router_cav_y0+ledge_w, -0.5])
                cube([pocket_x-2*ledge_w, pocket_y-2*ledge_w, ledge_t+1]);
        }
}

// Tapered pillars under the cradle rim: wide where they meet the ledge, narrow
// at the floor so they bridge less and reduce stringing on the print.
module ledge_support(cx, cy, top_w, top_d) {
    z0 = floor_th;
    z1 = floor_th + cradle_z - ledge_t;
    hull() {
        translate([cx, cy, z0])        cube([sup_foot, sup_foot, 0.1], center=true);
        translate([cx, cy, z1 - 0.05]) cube([top_w, top_d, 0.1], center=true);
    }
}
module router_supports() {
    y_front = router_cav_y0 + ledge_w/2;
    y_back  = router_cav_y1 - ledge_w/2;
    x_right = rt_x0 + pocket_x - ledge_w/2;
    for (f = [0.18, 0.38, 0.58, 0.78]) {
        cx = rt_x0 + pocket_x*f;
        ledge_support(cx, y_front, sup_top_w, ledge_w);
        ledge_support(cx, y_back,  sup_top_w, ledge_w);
    }
    for (g = [0.3, 0.7]) {
        cy = router_cav_y0 + pocket_y*g;
        ledge_support(x_right, cy, ledge_w, sup_top_w);
    }
}

// Full-height stabilizer fins at the router's mid-span. The bay is hollowed the
// full width to the lid, so the router otherwise floats in Y with ~3 mm of play
// and rocks. These two fins form a slot the router drops into: they pin it front
// and back and brace the case floor-to-lid so nothing bounces. The router rests
// against their inner faces (it sits BESIDE the front fin, not on it).
module router_stabilizers() {
    stab_w = 8;                             // fin length along X
    cx     = rt_x0 + pocket_x*0.48;         // midway between supports #2 and #3
    front_y1 = rt_front - fin_play;         // front fin inner face
    back_y0  = rt_front + rt_wid + fin_play;// back fin inner face
    // front fin: front wall inner face -> router front face
    translate([cx - stab_w/2, router_cav_y0, floor_th])
        cube([stab_w, front_y1 - router_cav_y0, inner_h]);
    // back fin: router back face -> divider front face
    translate([cx - stab_w/2, back_y0, floor_th])
        cube([stab_w, router_cav_y1 - back_y0, inner_h]);
}

// Corner stops on the router's LEFT (dongle) end. Enlarging the bay removed the
// old left cavity wall, so these retain the router in X while leaving the centre
// of the left edge open for the right-angle USB dongle.
module router_left_stops() {
    tab_h = cradle_z + rt_thk*0.4;
    x0    = rt_x0 + rt_clr - wall - 0.3;
    for (yc = [router_cav_y0 + ledge_w, router_cav_y1 - ledge_w - 10])
        translate([x0, yc, floor_th]) cube([wall, 10, tab_h]);
}

// Central full-height passage through the divider for internal wiring.
module divider_passage() {
    x0 = open_left ? wall - 1 : wall + pass_margin;
    x1 = wall + IX - pass_margin;
    translate([x0, divider_y0-1, floor_th])
        cube([x1 - x0, wall+2, inner_h+1]);
}

module vent_row(length, z0) {
    n = floor((length - vent_gap) / (vent_slot_w + vent_gap));
    span = n*(vent_slot_w+vent_gap) - vent_gap;
    start = (length - span)/2;
    // Cube is centred in Y so the row straddles the wall centreline and cuts
    // clean through, regardless of which wall it is placed on.
    for (i=[0:n-1])
        translate([start + i*(vent_slot_w+vent_gap) + vent_slot_w/2, 0, z0 + vent_slot_h/2])
            cube([vent_slot_w, wall*3, vent_slot_h], center=true);
}

module snap_bump() {
    hull() {
        cube([snap_w, 0.1, 0.1]);
        translate([0, snap_t, -snap_t]) cube([snap_w, 0.1, 0.1]);
        translate([0, 0.1, -snap_z*0.9]) cube([snap_w, 0.1, 0.1]);
    }
}

// Raised label on the base front wall (above vents, clear of the button).
// Three stacked lines: version, author, contact.
module base_label() {
    s = wall_txt_sz;
    translate([wall + IX/2, 0, 30]) rotate([90, 0, 0])
        translate([0, 0, -0.1]) linear_extrude(emboss_h + 0.1) {
            translate([0,  s*1.05, 0]) text(label,   size=s,      halign="center", valign="center");
            translate([0,  0,      0]) text(author,  size=s*0.72, halign="center", valign="center");
            translate([0, -s*0.9,  0]) text(contact, size=s*0.6,  halign="center", valign="center");
        }
}

// Recessed (engraved) label on the lid top, between the screen window and fan.
// Debossed rather than raised so the top face prints cleanly. Subtracted from
// the lid in lid()'s difference() block.
module lid_label() {
    s = lid_txt_sz;
    translate([wall + IX/2, 90, roof_th - deboss_d])
        linear_extrude(deboss_d + 0.1) {
            translate([0,  s*1.05, 0]) text(label,   size=s,      halign="center", valign="center");
            translate([0,  0,      0]) text(author,  size=s*0.72, halign="center", valign="center");
            translate([0, -s*0.9,  0]) text(contact, size=s*0.6,  halign="center", valign="center");
        }
}

// ============================================================================
// BASE
// ============================================================================
module base() {
    difference() {
        union() {
            difference() {
                shell_box(OUTX, OUTY, base_h);
                // router cavity (hollowed to the divider so there's cable room behind the snug pocket)
                translate([wall, router_cav_y0, floor_th])
                    cube([IX, router_bay_y, inner_h+1]);
                // Pi cavity
                translate([wall, pi_cav_y0, floor_th])
                    cube([IX, pi_bay_y, inner_h+1]);
            }
            pi_standoffs();
            router_ledge();
            router_supports();
            router_stabilizers();
            router_left_stops();
            audio_cradle();
        }
        all_panels();
        pi_standoff_holes();
        divider_passage();
        // ventilation: Pi back wall + router front wall (low rows)
        translate([0, OUTY - wall/2, floor_th+4]) vent_row(OUTX, 0);
        translate([0, wall/2,        floor_th+4]) vent_row(OUTX, 0);
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
        // engraved label on the top face
        lid_label();
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
}

// ============================================================================
// Preview ghosts
// ============================================================================
module board_ghost() {
    translate([board_absx, board_absy, floor_th+standoff_h])
        cube([board_x, board_y, board_th]);
}
module router_ghost() {
    translate([rt_x0 + rt_clr, rt_front, floor_th + cradle_z])
        cube([rt_len, rt_wid, rt_thk]);
}

// ============================================================================
// Render selector
// ============================================================================
if (part == "base") base();
else if (part == "lid") translate([0,0,base_h + lip_h]) mirror([0,0,1]) lid();
else if (part == "check") { base(); %board_ghost(); %router_ghost(); }
else { base(); translate([0,0,base_h]) lid(); }
