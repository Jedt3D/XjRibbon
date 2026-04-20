---
phase: 05-desktop-complete-control-set
plan: 04
subsystem: ui
tags: [xojo, desktop, ribbon, checkbox, splitbutton, separator, demo]

# Dependency graph
requires:
  - phase: 05-03
    provides: AddCheckBox, AddSeparator, AddSplitButton factory methods; DrawCheckBoxItem; SplitButton hit-split logic
provides:
  - Show/hide group with 3 checkboxes + separator + small button in demo View tab
  - Panes group with SplitButton "Navigation pane" + 3 menu items in demo View tab
  - End-to-end demo proof that Phase 5 Plans 01-03 compose correctly
affects: [06-designer-v2, 07-web-phase5]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Call for unused XjRibbonItem returns in Opening event"
    - "#Pragma Unused hiddenCb for initially-checked checkbox with no post-init config"
    - "Groups appended to viewTab local var before contextual tab section"

key-files:
  created: []
  modified:
    - desktop/MainWindow.xojo_window

key-decisions:
  - "Use Call for first two AddCheckBox calls (returns not needed — default unchecked state, no post-creation config)"
  - "Use Var hiddenCb + #Pragma Unused to exercise optional initialState parameter without compiler warning"
  - "Insert new groups after guidesItem.IsToggle = True and before contextual tab section to keep viewTab in scope"

patterns-established:
  - "Demo insertion pattern: append to viewTab local var still in scope, before contextual tab section"

requirements-completed: [REQ-516]

# Metrics
duration: 5min
completed: 2026-04-20
---

# Phase 5 Plan 04: Demo Update — Show/hide Group and Panes SplitButton Summary

**Demo View tab extended with Show/hide group (3 checkboxes + separator + small button) and Panes group (SplitButton with 3 menu items), proving Phase 5 Plans 01-03 compose correctly**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-04-20T13:05:00Z
- **Completed:** 2026-04-20T13:10:00Z
- **Tasks:** 1/2 (Task 2 is checkpoint:human-verify — awaiting human verification)
- **Files modified:** 1

## Accomplishments
- Inserted 17 lines of Xojo code into MainWindow.Opening event after existing Show group
- Show/hide group: 3 checkboxes (2 unchecked, 1 starts checked via True parameter), separator, small button
- Panes group: SplitButton "Navigation pane" with 3 dropdown menu items attached via AddMenuItem
- All existing demo controls (Home, Insert, View Zoom/Show, contextual tabs) left untouched

## Task Commits

1. **Task 1: Add Show/hide group and Panes SplitButton group to Opening event** - `5f52d36` (feat)

## Files Created/Modified
- `desktop/MainWindow.xojo_window` - Opening event extended with Show/hide and Panes groups (17 lines inserted)

## Decisions Made
- Used `Call showHide.AddCheckBox(...)` for unchecked checkboxes (return value not needed, follows existing project convention)
- Used `Var hiddenCb ... #Pragma Unused hiddenCb` for the initially-checked checkbox to exercise the optional `True` parameter without a compiler warning
- `showHide.AddSeparator()` called without `Call` because it is a Sub (no return value)
- `panesGroup` used as the local group var (not `navGroup`) to avoid shadowing with `navPane` item var

## Deviations from Plan

None - plan executed exactly as written. The insertion point matched the plan spec exactly (after guidesItem.IsToggle = True, before contextual tab section).

## Issues Encountered
None.

## Known Stubs
None — all groups and items are fully wired via the existing XjRibbon event handlers (ItemPressed fallthrough Else branch covers all view.* tags; DropdownMenuAction covers SplitButton arrow selections).

## Threat Flags
None — demo-only window with MessageBox output on developer-defined tag constants. No new network surface, auth paths, or user data.

## Self-Check: PASSED
- `desktop/MainWindow.xojo_window` modified and committed: `5f52d36`
- grep -c "showHide" returns 6 (>= 3 required)
- grep -c "AddCheckBox" returns 3 (exactly 3)
- grep -c "AddSplitButton" returns 1 (exactly 1)
- grep -c "AddSeparator" returns 1 (exactly 1)
- grep -c "navPane" returns 4 (>= 4 required)
- grep -c "view.nav_pane.toggle" returns 1
- grep -c "view.nav_pane.expand" returns 1
- grep -c "view.nav_pane.allfolders" returns 1
- grep -c "view.hidden.*True" returns 1
- grep -c "zoomGroup" returns 4 (existing code untouched)
- grep -c "Table Tools" returns 8 (existing code untouched)
- grep -c "#Pragma Unused hiddenCb" returns 1

## Next Phase Readiness
- Task 2 (checkpoint:human-verify) requires opening Xojo IDE, compiling, and visually/interactively verifying all Phase 5 controls
- After human approval, Phase 5 (Plans 01-04) is complete: REQ-501 through REQ-516 all satisfied
- Phase 6 (Designer v2.0) can begin: will need to add splitbutton, toggle, checkbox to JSON schema + inspector + code gen

---
*Phase: 05-desktop-complete-control-set*
*Completed: 2026-04-20*
