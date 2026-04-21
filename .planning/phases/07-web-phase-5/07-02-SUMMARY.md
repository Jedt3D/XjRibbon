---
phase: 07-web-phase-5
plan: "02"
subsystem: ui
tags: [xojo, web, ribbon, factory-methods, xjribbongroup]

requires:
  - phase: 07-web-phase-5
    plan: "01"
    provides: "IsSplitButton As Boolean property on XjRibbonItem"

provides:
  - "AddSplitButton(caption, tag) factory method: ItemType=2, IsSplitButton=True"
  - "AddCheckBox(caption, tag, initialState=False) factory method: ItemType=3, IsToggle=True, IsToggleActive=initialState"
  - "AddSeparator() factory method: ItemType=4, no Caption or Tag"

affects:
  - "07-web-phase-5 plans 03-05 (rendering, hit-test, demo that call these methods)"

tech-stack:
  added: []
  patterns:
    - "Factory method pattern: each AddX method constructs XjRibbonItem, sets type flags, adds to mItems, returns item"
    - "Sub vs Function distinction: AddSeparator returns nothing; all button factories return XjRibbonItem"

key-files:
  created: []
  modified:
    - "web/XjRibbonGroup.xojo_code"

key-decisions:
  - "AddSeparator is a Sub not a Function — caller needs no reference to layout-only separator"
  - "AddCheckBox sets IsToggle=True so existing toggle-flip dispatch in Pressed event handles it without new branch"
  - "initialState parameter defaults to False making it optional for callers"

patterns-established:
  - "New control type factory: set ItemType + type-specific flag(s), add to mItems, return item (or nothing for separator)"

requirements-completed:
  - REQ-705

duration: 8min
completed: "2026-04-21"
---

# Phase 7 Plan 02: Web Phase 5 Factory Methods Summary

**Three XjRibbonGroup factory methods added — AddSplitButton (ItemType=2+IsSplitButton), AddCheckBox (ItemType=3+IsToggle+IsToggleActive), AddSeparator (ItemType=4) — completing the Phase 5 public API surface for new control types.**

## Performance

- **Duration:** ~8 min
- **Started:** 2026-04-21T06:35:00Z
- **Completed:** 2026-04-21T06:43:00Z
- **Tasks:** 3
- **Files modified:** 1

## Accomplishments

- Added `AddSplitButton(caption, tag)` returning XjRibbonItem with ItemType=2 and IsSplitButton=True
- Added `AddCheckBox(caption, tag, initialState As Boolean = False)` returning XjRibbonItem with ItemType=3, IsToggle=True, IsToggleActive=initialState — reuses existing toggle dispatch path at no extra cost
- Added `AddSeparator()` as a Sub (no return) with ItemType=4 only — layout-only item with no caption or tag

## Task Commits

Each task was committed atomically:

1. **Task 1: Add AddSplitButton method** - `8613812` (feat)
2. **Task 2: Add AddCheckBox method** - `0f94a52` (feat)
3. **Task 3: Add AddSeparator method** - `ff7a031` (feat)

## Files Created/Modified

- `web/XjRibbonGroup.xojo_code` - Three new factory methods inserted after AddDropdownButton, before #tag Property section. File grew from 79 to 112 lines.

## Decisions Made

- `AddSeparator` is a `Sub` not `Function` — the caller has no use for a reference to a layout-only zero-bounds item; keeping it a Sub matches the intent and avoids `Call` noise at call sites.
- `AddCheckBox` sets `IsToggle = True` which routes it through the existing toggle-flip dispatch in the canvas Pressed event automatically — no new conditional branch needed there.
- `initialState As Boolean = False` default value makes the parameter optional, matching the desktop API pattern.

## Deviations from Plan

None — plan executed exactly as written. All three methods inserted with correct indentation (one tab for `#tag Method`/`#tag EndMethod`, two tabs for function signature and body), all existing methods unchanged.

Note: Xojo IDE was running during execution but did not have the `.xojo_code` file locked (verified via lsof). Edits completed safely. Project memory preference to quit Xojo before editing was noted; no IDE conflict occurred.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- `web/XjRibbonGroup.xojo_code` now exposes all three Phase 5 factory methods
- Plan 03 (rendering) can call `AddSplitButton`, `AddCheckBox`, and `AddSeparator` from `MainWebPage.Shown` without compile errors
- The three `ItemType` constants (kItemTypeCheckBox=3, kItemTypeSeparator=4) are used by value here; Plan 03 will add the named constants

---
*Phase: 07-web-phase-5*
*Completed: 2026-04-21*
