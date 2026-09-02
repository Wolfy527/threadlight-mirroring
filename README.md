# ThreadLight Mirroring

A free, targets-focused editor tool for creating and updating Live Mirroring
setups. It shares its authoring foundation with ThreadLight Builder while remaining
a separate lightweight product.

## Install

<a href="https://wolfy527.github.io/threadlight-mirroring/?install=1">
  <img src=".github/assets/add-to-vcc-button.svg" alt="Add ThreadLight Mirroring to VCC" width="132">
</a>

VCC repository: `https://wolfy527.github.io/threadlight-mirroring/index.json`

Install `ThreadLight Mirroring` through VCC. VCC installs ThreadLight Authoring
as its shared creator-side dependency. ThreadLight Components is a separate
lightweight customer package for finished prefabs, not a Builder
dependency.

## Use

Open **Tools > ThreadLight > Mirroring**. Choose an existing
setup to edit, or choose a prefab root and select **Create & Build**.

### Before you begin

VCC installs the required ThreadLight Authoring dependency with ThreadLight Mirroring.
The Builder will not replace the prefab root, existing children, or
creator-authored transforms.

If ThreadLight Authoring is removed manually, reinstall ThreadLight Mirroring through
VCC before Unity compiles the tool.

### Create a setup

1. Choose the prefab root in **Prefab Root**, or select it in the Hierarchy and
   use **Use Selection**.
2. Optionally choose **Prefab Scale Reference**. It must be inside the selected
   root. Leave it empty to have Build create an owned `Prefab Container` for
   shared scaling.
3. Select **Create & Build** in the bottom dock.

Build creates the editor-only setup holder and generated constraint targets.
Unity Undo can restore the setup immediately after creation or a later build.

### ThreadLight Mirroring Setup

Use **ThreadLight Mirroring Setup** to choose an existing setup. Use
**Select Setup Object** to find its editor-only holder in the Hierarchy.

### Target Naming & Organization

**Constraint Targets Object Name** controls the generated targets holder. The
target cards below it define each source/mirrored relationship.

The generated-target prefix, R/L side labels, source and mirrored folder
names, transform defaults, and unused-target cleanup follow the same rules as
the full ThreadLight Builder so a setup can transfer without being renamed or
reorganized.

- **+ Add Target** adds an empty source/mirrored pair.
- **Add Selected Objects** creates a new pair from exactly two selected
  transforms. Select the source first and the intended opposite-side target
  second; the Builder fills both fields.
- **Create Opposite Target** keeps a second-side target. While Live Mirroring
  is enabled, that target follows its source automatically.
- **Use Global Side Labels** uses the shared R/L labels; turn it off for
  per-target labels.
- **Target Name**, **Source**, **Mirrored Target**, and **Rotation Offset** set
  the relationship. Empty source or mirrored target fields receive generated
  empty targets during Build.
- **Source Bone** and **Mirrored Bone** appear when VRCFury armature links are
  enabled.
- **Up**, **Down**, **Swap**, and **Remove** reorder, exchange, or remove a
  pair.

### Target Defaults & Preview Helpers

- **Add VRCFury Armature Links** adds or updates generated targets when VRCFury
  is installed.
- **Synchronize Scale** keeps generated constraint targets at the same shared
  world scale as the prefab scale reference.
- **Prefab Scale Reference** sets that scale basis.
- **Add Parent Constraint To Prefab Container** adds a VRC Parent Constraint
  to that reference and assigns every configured source and mirrored target.
- **Additional Scale Handles** adds other transforms that need the same scale
  treatment.

An invalid scale reference is rejected. When none is set, the Builder creates
an owned `Prefab Container` so the scale topology stays explicit and safe.

### Live Mirroring

- **Live Mirroring** turns continuous editor-time mirroring on or off.
- **Mirror Center** defines the mirror plane's position and orientation.
- **Mirror Axis** chooses the mirror center's local separation axis.
- **Mirror Position**, **Mirror Rotation**, and **Mirror Scale** choose which
  source transform values are applied to the mirrored target.

### Mirroring and Scaling

**Mirror Scale** copies the source object's local scale to its mirrored target.
**Synchronize Scale** is separate: it keeps the target system aligned with the
prefab scale reference.

### Scene Preview

- **Show Scene Preview** enables editor-only preview ghosts.
- **Preview Source** chooses the object drawn by those ghosts.
- **Preview Material** controls their appearance. Build prefers the included
  Ghost Material when none is selected and falls back to Unity's default.

### Build, validate, and undo

The bottom dock explains whether it will create or update a setup. Correct
validation messages before building. After building, inspect the targets and
scene preview, then use Unity Undo if the result is not what you expected.

If a root is managed by the full ThreadLight Builder, ThreadLight Mirroring directs
you to edit it there. Do not try to keep two tools synchronised; build from the
authoritative tool for that prefab.

The same guide is included in the package at
[Using ThreadLight Mirroring](Documentation~/Using%20Threadlight%20Mirroring.md).

## Requirements

- Unity 2022.3
- ThreadLight Authoring 1.x

## License

See [LICENSE.md](LICENSE.md).
