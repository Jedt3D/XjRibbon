---
phase: 06-designer-v2-0
plan: 04
subsystem: ui
tags: [xojo, designer, ribbon, codegen, splitbutton, toggle, checkbox]

# Dependency graph
requires:
  - phase: 06-02
    provides: IsToggleActive inspector control + isToggleActive Dictionary key populated by UI
  - phase: 06-03
    provides: BuildJSON/LoadFromJSON JSON round-trip for all 5 item types with isToggleActive

provides:
  - GenerateCode Select Case dispatch for all 5 item types
  - Case "splitbutton" generates AddSplitButton + tooltip + enabled + menu items loop
  - Case "toggle" generates AddLargeButton + .IsToggle = True + conditional .IsToggleActive = True
  - Case "checkbox" generates conditional Var .AddCheckBox(..., True) or Call .AddCheckBox(...)
  - Case "large", "small" preserves existing dropdown/large/small logic unchanged (no regression)

affects:
  - end-to-end user flow: "Copy Toolbar Code" now produces valid Xojo code for all 5 item types

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Select Case it pattern in GenerateCode — scalable dispatch for 5 item types; replaces binary If it = 'large' Or it = 'small' Then"
    - "Case 'splitbutton': uses same menu items loop as dropdown (miList <> Nil guard, not hasMI)"
    - "Case 'toggle': always uses Var itemVar form (never Call) since .IsToggle = True must be set on the returned item"
    - "Case 'checkbox': isActive branch uses Var itemVar form with True arg; inactive branch uses Call form"

key-files:
  created: []
  modified:
    - designer/MainWindow.xojo_window

key-decisions:
  - "Select Case structure chosen over ElseIf chain — cleaner for 5 types, matches plan spec"
  - "splitbutton menu items loop uses miList <> Nil guard (not hasMI flag) — consistent with plan spec; splitbutton always has an explicit menu list"
  - "toggle Case always emits Var itemVar form — .IsToggle = True and optional .IsToggleActive = True cannot be set without a reference to the returned XjRibbonItem"
  - "checkbox isActive=True emits Var form with True arg to AddCheckBox; isActive=False emits Call form — matches plan spec output patterns"
  - "Case 'large', 'small' block is semantically unchanged — only wrapped in Select Case; hasMI/isDropdown logic for dropdown detection preserved"

# Metrics
duration: 5min
completed: 2026-04-20
---

# Phase 06 Plan 04: Designer v2.0 — GenerateCode Select Case for New Item Types Summary

**GenerateCode item dispatch restructured from binary If/End If to Select Case with Case blocks for all five item types; "Copy Toolbar Code" now produces valid Xojo API calls for splitbutton, toggle, and checkbox in addition to existing large/small/dropdown**

## Performance

- **Duration:** 5 min
- **Started:** 2026-04-20T18:20:00Z
- **Completed:** 2026-04-20T18:25:00Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- GenerateCode `If it = "large" Or it = "small" Then ... End If` replaced with `Select Case it` covering all five item types
- Case "large", "small": existing large/small/dropdown logic preserved exactly — no regression
- Case "splitbutton": emits `Var itemVar As XjRibbonItem = grpVar.AddSplitButton(cap, tag)` + optional tooltip + optional IsEnabled=False + menu items loop (miList <> Nil guard)
- Case "toggle": emits `Var itemVar As XjRibbonItem = grpVar.AddLargeButton(cap, tag)` + `.IsToggle = True` + conditional `.IsToggleActive = True` + optional tooltip + optional IsEnabled=False
- Case "checkbox": isActive=True emits `Var itemVar As XjRibbonItem = grpVar.AddCheckBox(cap, tag, True)`; isActive=False emits `Call grpVar.AddCheckBox(cap, tag)` — no variable needed for inactive checkbox

## Task Commits

1. **Task 1: Restructure GenerateCode item dispatch as Select Case with new type branches** - `d08dd44` (feat)

## Files Created/Modified

- `designer/MainWindow.xojo_window` — GenerateCode function: `If it = "large" Or it = "small" Then` block replaced with `Select Case it` containing Case "large","small", Case "splitbutton", Case "toggle", Case "checkbox", End Select

## Decisions Made

- Select Case chosen over ElseIf chain — cleaner dispatch for 5 types; directly matches plan recommendation
- splitbutton menu items loop uses `If miList <> Nil Then` guard (not the `hasMI` boolean used for dropdown detection in the large/small case) — splitbutton always explicitly has a menu list, no inferred-from-count logic needed
- toggle Case unconditionally uses the Var itemVar form (never Call) because `.IsToggle = True` must be chained on the returned XjRibbonItem reference
- checkbox Case uses conditional Var/Call pattern: the `isActive=True` branch needs a Var to pass `True` as third argument; the `isActive=False` branch uses Call since no post-creation properties are set

## Deviations from Plan

None - plan executed exactly as written. The replacement matched the plan spec code verbatim.

## Known Stubs

None — GenerateCode produces concrete Xojo API calls from real Dictionary data for all 5 item types; no placeholder or mock code paths remain.

## Threat Flags

No new network endpoints, auth paths, file access patterns, or schema changes. GenerateCode writes a string to clipboard only; trust boundary is Xojo source output, not executed code. T-06-07 (tampering — accept disposition) unchanged.

## Self-Check

- [x] `designer/MainWindow.xojo_window` modified and committed
- [x] Commit d08dd44 exists with correct message
- [x] `Case "splitbutton"` present at line 1225 in GenerateCode
- [x] `Case "toggle"` present at line 1245 in GenerateCode
- [x] `Case "checkbox"` present at line 1264 in GenerateCode
- [x] `AddSplitButton` present at line 1232 (1 match in GenerateCode)
- [x] `.IsToggle = True` present at line 1253 (1 match)
- [x] `IsToggleActive = True` present at line 1255 (1 match inside toggle Case)
- [x] `AddCheckBox` present at lines 1270 and 1272 (Var form + Call form)
- [x] `Case "large", "small"` present at line 1186 (Select Case confirmed)
- [x] Old `If it = "large" Or it = "small" Then` no longer exists

## Self-Check: PASSED

---
*Phase: 06-designer-v2-0*
*Completed: 2026-04-20*
