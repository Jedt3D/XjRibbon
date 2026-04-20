---
phase: 05-desktop-complete-control-set
plan: "01"
subsystem: desktop/XjRibbonItem
tags: [xojo, ribbon, splitbutton, property, backward-compat]
dependency_graph:
  requires: []
  provides: [XjRibbonItem.IsSplitButton]
  affects: [desktop/XjRibbonGroup.xojo_code, desktop/XjRibbon.xojo_code]
tech_stack:
  added: []
  patterns: [Xojo property block #tag Property]
key_files:
  created: []
  modified:
    - desktop/XjRibbonItem.xojo_code
decisions:
  - "IsSplitButton added as flag on ItemType=2 — no new ItemType needed, backward compatible (default False)"
metrics:
  duration: "71s"
  completed_date: "2026-04-20T12:47:19Z"
  tasks_completed: 1
  tasks_total: 1
  files_changed: 1
---

# Phase 5 Plan 01: IsSplitButton Property Summary

**One-liner:** Added `IsSplitButton As Boolean = False` flag on XjRibbonItem enabling split-button hit-zone differentiation without a new ItemType.

## What Was Done

Added a single new public property `IsSplitButton As Boolean = False` to `XjRibbonItem` in `desktop/XjRibbonItem.xojo_code`. The property is inserted between `IsToggleActive` and `KeyTip`, grouping all interaction-mode flags (IsToggle, IsToggleActive, IsSplitButton) together.

### Property Added

| Name | Type | Default | Scope | Purpose |
|------|------|---------|-------|---------|
| IsSplitButton | Boolean | False | Public | Marks an ItemType=2 item as having a body/arrow split hit zone |

### Insertion Point

Placed immediately after `IsToggleActive As Boolean = False` and immediately before `KeyTip As String` — keeping toggle/mode-related properties adjacent.

### Backward Compatibility

Default value of `False` means all existing `XjRibbonItem` instances, all existing `AddDropdownButton` calls, and all existing code referencing `ItemType = 2` items continue to behave exactly as before Phase 5. The whole-button click still opens the popup menu for any item where `IsSplitButton` was not explicitly set to `True`.

## Downstream Consumers

- **Plan 02 (XjRibbonGroup):** `AddSplitButton` factory sets `item.IsSplitButton = True`
- **Plan 03 (XjRibbon):** `MouseDown` reads `hitItem.IsSplitButton` to compute `mPressedOnArrow`; `DrawDropdownButton` reads it to draw the vertical separator line and reposition the chevron

## Verification

All acceptance criteria passed:

```
grep -c "IsSplitButton As Boolean = False" desktop/XjRibbonItem.xojo_code  → 1
grep -c "IsSplitButton" desktop/XjRibbonItem.xojo_code                      → 1
grep -c "IsToggleActive As Boolean = False" desktop/XjRibbonItem.xojo_code   → 1 (untouched)
grep -c "KeyTip As String" desktop/XjRibbonItem.xojo_code                   → 1 (untouched)
grep -c "Caption As String" desktop/XjRibbonItem.xojo_code                  → 1 (untouched)
File ends with: End Class / #tag EndClass                                    → verified
```

Note: The plan's acceptance criterion stated `grep -c "#tag Property"` should return `15` (was 14 + 1). The actual original file had 16 properties (not 14 as research noted), giving a post-edit count of 17. The research document had a stale count. The property structure is correct — the new block is properly formed and placed, and all original 16 properties are untouched.

## Deviations from Plan

### Research Count Discrepancy (non-blocking)

- **Found during:** Acceptance criteria verification
- **Issue:** Research document stated "14 properties before" but actual file had 16. The acceptance criterion `grep -c "#tag Property" = 15` was therefore unreachable (actual result: 17).
- **Fix:** Accepted actual count of 17 as correct. All other criteria passed. The property block itself is correct.
- **Files modified:** None (no code change required)
- **Commit:** n/a

## Known Stubs

None — this plan adds a data property only. No rendering or logic depends on it yet (that is Plan 02 and 03's responsibility).

## Threat Flags

None — adding a Boolean property to a data class introduces no new network endpoints, auth paths, or trust boundary changes.

## Self-Check: PASSED

- File exists: `/Users/worajedt/Xojo Projects/XjRibbon/desktop/XjRibbonItem.xojo_code` — FOUND
- Commit f752087 — FOUND (`feat(05-01): add IsSplitButton property to XjRibbonItem`)
- `IsSplitButton As Boolean = False` present exactly once — VERIFIED
- All pre-existing properties untouched — VERIFIED
