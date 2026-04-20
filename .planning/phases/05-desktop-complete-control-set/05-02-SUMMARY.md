---
phase: 05-desktop-complete-control-set
plan: 02
subsystem: ui
tags: [xojo, ribbon, canvas, factory-methods, checkbox, splitbutton, separator]

# Dependency graph
requires:
  - phase: 05-desktop-complete-control-set/05-01
    provides: IsSplitButton property on XjRibbonItem

provides:
  - AddSplitButton(caption, tag) As XjRibbonItem — ItemType=2, IsSplitButton=True
  - AddCheckBox(caption, tag, initialState=False) As XjRibbonItem — ItemType=3, IsToggle=True
  - AddSeparator() Sub — ItemType=4, no return value

affects:
  - 05-desktop-complete-control-set/05-03 (rendering and layout consumer)
  - 05-desktop-complete-control-set/05-04 (demo window consumer)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Factory method on XjRibbonGroup centralizes ItemType assignment and flag combinations
    - Function returns item for chaining; Sub used for side-effect-only factory (AddSeparator)

key-files:
  created: []
  modified:
    - desktop/XjRibbonGroup.xojo_code

key-decisions:
  - "AddSplitButton uses ItemType=2 + IsSplitButton=True flag — no new ItemType constant needed, backward compatible"
  - "AddCheckBox always sets IsToggle=True — checkbox clicks handled by existing MouseUp toggle dispatch automatically"
  - "AddSeparator is a Sub (no return value) — callers need no Call wrapper, separator has no configurable state"
  - "initialState parameter defaults to False — matches Xojo Boolean default, optional for unchecked initial state"

patterns-established:
  - "Factory method pattern: Var item As New XjRibbonItem → set properties → mItems.Add(item) → Return item"
  - "Sub factory for items with no configurable post-creation state (Separator)"

requirements-completed: [REQ-513, REQ-514, REQ-515]

# Metrics
duration: 4min
completed: 2026-04-20
---

# Phase 5 Plan 02: Desktop Complete Control Set — Factory Methods Summary

**Three XjRibbonGroup factory methods for SplitButton (ItemType=2+flag), CheckBox (ItemType=3, IsToggle=True), and Separator (ItemType=4, Sub) added following the established AddDropdownButton pattern.**

## Performance

- **Duration:** ~4 min
- **Started:** 2026-04-20T12:47:59Z
- **Completed:** 2026-04-20T12:51:21Z
- **Tasks:** 3
- **Files modified:** 1

## Accomplishments

- `AddSplitButton(caption, tag)` added — returns XjRibbonItem with ItemType=2 and IsSplitButton=True, enabling caller to chain `.AddMenuItem()` calls
- `AddCheckBox(caption, tag, initialState=False)` added — returns XjRibbonItem with ItemType=3, IsToggle=True, IsToggleActive from optional third param; existing MouseUp toggle dispatch handles clicks without new code
- `AddSeparator()` added as Sub — appends ItemType=4 item with no caption or tag; no return value required since separator has no configurable state

## Task Commits

Each task was committed atomically:

1. **Task 1: Add AddSplitButton method to XjRibbonGroup** - `74f2fde` (feat)
2. **Task 2: Add AddCheckBox method to XjRibbonGroup** - `09fdc3f` (feat)
3. **Task 3: Add AddSeparator method to XjRibbonGroup** - `d9befdc` (feat)

## Files Created/Modified

- `desktop/XjRibbonGroup.xojo_code` — Three new `#tag Method` blocks added after `AddDropdownButton`, before `Caption` property block. Method count: 5 → 8.

## Decisions Made

- `AddSplitButton` uses `ItemType=2` (same as Dropdown) plus `IsSplitButton=True` flag — consistent with the architectural decision from Plan 01 and STATE.md: no new ItemType constant, backward compatible
- `AddCheckBox` always sets `IsToggle=True` — this ensures the existing `MouseUp` toggle dispatch (`If pressed.IsToggle Then pressed.IsToggleActive = Not pressed.IsToggleActive`) handles CheckBox items automatically; no new MouseUp branch needed in Plan 03
- `AddSeparator` is a `Sub` not a `Function` — REQ-515 specifies no return value; separator has no properties to configure after creation, so callers don't need a handle on it and need no `Call` wrapper

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- All three factory methods available for Plan 03 (rendering/layout) and Plan 04 (demo window)
- `IsSplitButton` property confirmed present on XjRibbonItem (added by Plan 01, verified by reading XjRibbonItem.xojo_code)
- Plan 03 can reference `kItemTypeCheckBox=3` and `kItemTypeSeparator=4` constants (those will be added in Plan 03 to XjRibbon.xojo_code)
- No blockers

---
*Phase: 05-desktop-complete-control-set*
*Completed: 2026-04-20*
