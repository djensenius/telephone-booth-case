# Telephone Booth Case

A parametric, 3D-printable enclosure for the [Telephone-Booth](https://github.com/djensenius/Telephone-Booth)
art project. It is a two-bay, snap-fit case that houses:

- **Back bay** — Raspberry Pi 4B + 52Pi GPIO Screw Terminal HAT, with a Noctua
  NF-A4x20 fan mounted on the lid.
- **Front bay** — GL.iNet MUDI 7 (GL-E5800) travel router, lying flat screen-up in
  a cradle so the screen shows through the lid window and the power button is
  reachable from the front wall.

Internal wiring runs between the bays through a passage in the central divider:
external USB-C inlet → router power in, router PD out → Pi power, router Ethernet →
Pi Ethernet. Two panel RJ45 jacks wire to the 52Pi HAT (GPIO).

Current embossed version: **v.0.1**

## Components

Parts the case is designed around (official product pages where available, Amazon
otherwise). Panel-mount connectors are representative examples — verify cutout
dimensions before a final print.

| Component | Where it goes | Link |
| --- | --- | --- |
| Raspberry Pi 4 Model B | Back bay | [raspberrypi.com](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) |
| 52Pi GPIO Screw Terminal HAT (EP-01129) | On the Pi | [52pi.com](https://52pi.com/products/52pi-gpio-screw-terminal-hat-for-raspberry-pi) |
| GL.iNet MUDI 7 (GL-E5800) 5G travel router | Front bay | [gl-inet.com](https://www.gl-inet.com/products/gl-e5800/) |
| Noctua NF-A4x20 40 mm fan | Lid | [noctua.at](https://noctua.at/en/nf-a4x20-flx) |
| Round USB 3.0 panel-mount bulkhead, 86-type ⌀22 mm (2-pack) | Back wall | [Amazon.ca](https://www.amazon.ca/dp/B0F2MW7XXZ) |
| USB-C 3.1 panel-mount coupler, rectangular flange | Router-bay right wall (power inlet) | [Amazon.ca](https://www.amazon.ca/dp/B0GF22WM9T) |
| HDMI female → micro-HDMI panel-mount extension | Right wall | [Amazon.ca](https://www.amazon.ca/dp/B0DHK3RN81) |
| RJ45 CAT6 panel-mount coupler (×2, GPIO) | Left wall | [Amazon.ca](https://www.amazon.ca/dp/B071FNHVXN) |

Fasteners: M2.5 screws for the Pi standoffs (driven up from the underside); the
Noctua fan ships with its own self-tapping screws.

## Parts (printed)

| File | Part | Description |
| --- | --- | --- |
| [`telephone-booth-case.scad`](telephone-booth-case.scad) | Source | Parametric OpenSCAD model (all dimensions live here) |
| [`base.stl`](base.stl) | Base | Two-bay body with standoffs, cradle, panel cutouts and vents |
| [`lid.stl`](lid.stl) | Lid | Snap-fit lid with fan grille and router screen window |

Outer size: **~164.8 × 185.6 × 43.8 mm**. Both parts are embossed with the version.

## Previews

| Preview | View |
| --- | --- |
| ![Top layout](previews/1_layout_top.png) | Top-down layout with router + Pi ghosts |
| ![Interior](previews/2_interior_iso.png) | Interior, both bays |
| ![Assembled lid](previews/3_assembled_lid.png) | Assembled — fan grille + screen window |
| ![Underside](previews/4_assembled_under.png) | Assembled underside |
| ![Base label](previews/label_base.png) | Embossed label on the base front wall |
| ![Lid label](previews/label_lid.png) | Embossed label on the lid top |

## Printing / rendering

Requires [OpenSCAD](https://openscad.org/).

```sh
openscad -D 'part="base"' -o base.stl telephone-booth-case.scad
openscad -D 'part="lid"'  -o lid.stl  telephone-booth-case.scad
```

Use `-D 'part="check"'` for a translucent fit check with router and Pi ghosts.

## Versioning

The version is defined once, in the `label` parameter at the top of
`telephone-booth-case.scad`, embossed on both parts, and mirrored by the git tag
(embossed `v.0.1` ⇔ tag `v0.1`). See [`.github/copilot-instructions.md`](.github/copilot-instructions.md)
for the bump workflow.

## Related repositories

- [Telephone-Booth](https://github.com/djensenius/Telephone-Booth) — main project
- [Telephone-Booth-Operator](https://github.com/djensenius/Telephone-Booth-Operator)
- [Telephone-Booth-Operator-Mobile](https://github.com/djensenius/Telephone-Booth-Operator-Mobile)
