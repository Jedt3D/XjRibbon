---
phase: 06-designer-v2-0
plan: 01
subsystem: ui
tags: [xojo, designer, ribbon, popup-menu, dictionary, listbox]

# Dependency graph
requires:
  - phase: 05-desktop-complete-control-set
    provides: SplitButton, Toggle, CheckBox item types in the runtime library that designer now models
provides:
  - AddItemPopup 8-item menu (SplitButton, Toggle Button, CheckBox added)
  - Row data model Dictionary schema for splitbutton, toggle, checkbox type strings
  - CascadeTagUpdate handles all 5 item types for auto-tag generation
  - UpdateDropdownColumn shows menu item count for splitbutton rows
affects:
  - 06-02 (inspector plan uses new type strings and row dictionaries)
  - 06-03 (JSON plan uses new type strings in BuildJSON/LoadFromJSON)
  - 06-04 (code generator plan uses new type strings in GenerateCode)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "New item type Case block pattern: FindParentOfType -> FindLastChildRow -> AddRowAt -> set CellTextAt(row,1) -> build Dictionary -> RowTagAt"
    - "CheckBox intentionally omits isEnabled/tooltipText/menuItems from Dictionary (minimal schema per spec)"
    - "Toggle carries menuItems array for schema consistency even though inspector won't show it"

key-files:
  created: []
  modified:
    - designer/MainWindow.xojo_window

key-decisions:
  - "CheckBox Dictionary schema is minimal: type, caption, tag, isToggleActive only — no isEnabled, tooltipText, menuItems"
  - "Toggle Button carries emptyMenuItems array for schema consistency with large/small buttons even though UI won't show menu items"
  - "SplitButton guard message references 'Group' not 'Tab' — matches same parent-finding logic as large/small buttons"
  - "UpdateDropdownColumn extended to splitbutton so col-2 count appears when menu items are added via inspector"

patterns-established:
  - "All five item rowTypes (large, small, splitbutton, toggle, checkbox) must appear in every CascadeTagUpdate branch"
  - "UpdateDropdownColumn col-2 count applies to any type that has a menuItems list (large + splitbutton)"

requirements-completed:
  - REQ-601

# Metrics
duration: 11min
completed: 2026-04-20
---

# Phase 06 Plan 01: Designer v2.0 — New Item Types Foundation Summary

**AddItemPopup extended to 8 entries; row insertion, auto-tag cascade, and dropdown column count all handle splitbutton, toggle, checkbox type strings**

## Performance

- **Duration:** 11 min
- **Started:** 2026-04-20T18:11:18Z
- **Completed:** 2026-04-20T18:22:00Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments

- AddItemPopup InitialValue extended from 5 to 8 entries (Ribbon SplitButton, Ribbon Toggle Button, Ribbon CheckBox appended)
- Three new Case blocks in AddItemPopup.SelectionChanged insert correctly-typed rows at depth=2 with proper col-1 labels and Dictionary schema
- CascadeTagUpdate all three branches (item-self, group-cascade, tab-cascade) now recognise all five item type strings
- UpdateDropdownColumn guard extended so SplitButton rows display menu item count in col 2

## Task Commits

1. **Task 1: Extend AddItemPopup InitialValue and SelectionChanged** - `9281bf7` (feat)
2. **Task 2: Extend CascadeTagUpdate and UpdateDropdownColumn** - `b4c3c56` (feat)

## Files Created/Modified

- `designer/MainWindow.xojo_window` — InitialValue property, three new Case blocks in SelectionChanged event, three CascadeTagUpdate branch extensions, UpdateDropdownColumn guard update

## Decisions Made

- CheckBox Dictionary schema is intentionally minimal (type, caption, tag, isToggleActive only) — per DEV_PLAN.md locked decision: no isEnabled, no tooltipText, no menuItems for CheckBox
- Toggle Button carries an empty menuItems array for schema consistency even though the inspector won't expose it — avoids nil-guard issues in BuildJSON/LoadFromJSON
- Both SplitButton and large button rows will show menu-item count in col 2 because both have a menuItems list that the user can populate

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None. Xojo IDE was running at task start; quit it before editing (per project convention). All edits applied cleanly with unique context strings on first attempt.

## Known Stubs

None — all new rows are fully populated with correct Dictionary values; no placeholder data flows to UI rendering.

## Next Phase Readiness

- Foundation complete: type strings "splitbutton", "toggle", "checkbox" now exist in RibbonStructure row Dictionaries
- Plan 02 (inspector) can reference these type strings to extend SetInspectorState and PopulateInspector
- Plan 03 (JSON) can reference these type strings in BuildJSON/LoadFromJSON Select Case blocks
- Plan 04 (code generator) can reference these type strings in GenerateCode Select Case blocks
- No blockers

---
*Phase: 06-designer-v2-0*
*Completed: 2026-04-20*
