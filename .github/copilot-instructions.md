# Copilot instructions — Telephone Booth Case

Parametric 3D-printable enclosure for the **Telephone-Booth** art project. Two-bay
design in OpenSCAD: a Raspberry Pi 4B + 52Pi GPIO Screw Terminal HAT in one bay and
a GL.iNet MUDI 7 (GL-E5800) travel router in the other, with internal wiring between
them.

## Commit conventions

- **Do NOT add a `Co-authored-by: Copilot` trailer** (or any Copilot co-author
  attribution) to commits. This is an art project authored by @djensenius.
- Do not add other AI-attribution trailers either.

## Versioning workflow

The version is embossed on **both printed parts** and must always match the git tag.

- The version lives in one place: the `label` parameter at the top of
  `telephone-booth-case.scad` (e.g. `label = "Telephone Booth Case v.0.1";`).
- Git tags mirror it without the dot after `v` — embossed `v.0.1` ⇒ tag `v0.1`.

**At the start of every new session that touches this repo, ask the user:
"Is this a new version?"**

If yes:
1. Bump the version in the `label` string in `telephone-booth-case.scad`.
2. Re-render both STLs and all preview images (see below).
3. Commit the changes.
4. Create a matching git tag (e.g. `v0.2`) and push it with the commit.

If no, leave the version and tag unchanged.

## Rendering

OpenSCAD is at `/opt/homebrew/bin/openscad` (arm64; Rosetta not installed).

```sh
# Print-ready parts
openscad -D 'part="base"' -o base.stl telephone-booth-case.scad
openscad -D 'part="lid"'  -o lid.stl  telephone-booth-case.scad
```

Confirm each render reports `Status: NoError` (manifold). `part` accepts
`base` | `lid` | `both` | `check` (`check` adds translucent router + Pi ghosts).

Preview images live in `previews/`; regenerate them whenever the geometry or the
embossed version changes so they stay in sync with the STLs.

## Layout notes

- Coordinates: X = width, Y = depth (front→back), Z = up. Front bay = router,
  back bay = Pi.
- Key verified dimensions: Pi 4B mounting holes **58 × 49 mm**; Noctua NF-A4x20
  **40 × 40 × 20 mm**, 32 mm hole spacing; GL.iNet MUDI 7 **157 × 75 × 22.8 mm**.
- Items marked `VERIFY` in the SCAD have no reliable drawing and need caliper
  confirmation before a final print (screen window, power-button position,
  USB-C / HDMI / RJ45 flange cutouts).
