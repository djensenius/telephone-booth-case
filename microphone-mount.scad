// ============================================================================
// Telephone-Booth - microphone mount
//   A round disc that drops into the mouthpiece of an NE 233 handset in place
//   of the original built-in carbon microphone. It carries a small electret
//   condenser capsule, glued into the centre through-hole.
//
//   Profile (revolved, Z up, disc rests on the receiver at Z = 0):
//     * 46 mm outer diameter.
//     * A flat outer rim (the outer ~9 mm from the edge) that sits ON the
//       receiver, 5.4 mm thick.
//     * From ~9 mm in from the edge the body thickens toward the centre, up to
//       7 mm, forming a raised central boss.
//     * The underside recesses in the centre (a wide, deep dip) so the electret
//       capsule sits nestled below the rest face. The dip bottoms out on a flat
//       ledge so the capsule seats squarely.
//     * A 9 mm round through-hole at the centre holds the capsule (glued in).
//
// Render:
//   openscad -o microphone-mount.stl microphone-mount.scad
//   openscad -D section=true ... microphone-mount.scad   (half-section preview)
// ============================================================================

$fn = 128;

/* [Overall] */
disc_d      = 46;    // outer diameter
rim_th      = 5.4;   // thickness of the flat rim that rests on the receiver
boss_th     = 7;     // thickness at the raised central boss
rim_flat_w  = 9;     // width of the flat rim (from the edge inward) before it
                     // starts thickening toward the centre
boss_top_d  = 18;    // flat-top diameter of the boss (shoulder ramps up to here)

/* [Microphone dip - underside] */
mic_hole_d  = 9;     // centre through-hole - electret capsule glued in here
dip_open_d  = 28;    // diameter where the dip opens on the bottom face
dip_depth   = 5.0;   // how deep the dip sinks in from the bottom face
seat_d      = 13;    // flat ledge diameter at the top of the dip; the capsule
                     // seats against the annulus between here and the hole

/* [Preview] */
section     = false; // set true to render a half-section (dev preview only)

/* [Fit] */
eps = 0.01;

// ---------------------------------------------------------------------------

module microphone_mount() {
    r_out   = disc_d / 2;
    r_flat  = r_out - rim_flat_w;          // where the rim ends / boss begins
    r_hole  = mic_hole_d / 2;
    r_top   = boss_top_d / 2;
    r_open  = dip_open_d / 2;
    r_seat  = seat_d / 2;

    difference() {
        // Solid body of revolution: flat rim that ramps up to a taller boss.
        rotate_extrude()
            polygon(points = [
                [0,       0],
                [r_out,   0],
                [r_out,   rim_th],
                [r_flat,  rim_th],
                [r_top,   boss_th],   // top of the boss shoulder
                [0,       boss_th],
            ]);

        // Underside dip: a wide, deep recess funnelling up from the bottom face
        // to a flat ledge, so the mic drops in and seats squarely.
        translate([0, 0, -eps])
            cylinder(h = dip_depth + eps, r1 = r_open, r2 = r_seat);

        // Centre through-hole for the electret capsule.
        translate([0, 0, -eps])
            cylinder(h = boss_th + 2 * eps, r = r_hole);
    }
}

if (section)
    difference() {
        microphone_mount();
        translate([-50, 0, -5]) cube([100, 50, 30]);
    }
else
    microphone_mount();
