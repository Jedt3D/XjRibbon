---
phase: 06-designer-v2-0
plan: 02
subsystem: ui
tags: [xojo, designer, ribbon, inspector, checkbox, dictionary]

# Dependency graph
requires:
  - phase: 06-01
    provides: splitbutton/toggle/checkbox type strings established in RibbonStructure row Dictionaries
provides:
  - IsToggleActive DesktopCheckBox control in GroupBox1 inspector layout (Caption "Default Active?")
  - SetInspectorState handles all 5 item types with hasToggleState and hasIsEnabled boolean vars
  - PopulateInspector uses Select Case for ItemTypeField.Text across all 5 item types
  - IsToggleActive.ValueChanged event persists isToggleActive back to row Dictionary
affects:
  - 06-03 (JSON plan — BuildJSON/LoadFromJSON for isToggleActive field)
  - 06-04 (code generator plan — GenerateCode Select Case blocks)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "hasToggleState boolean pattern: (rowType = 'toggle' Or rowType = 'checkbox') for conditional control enabling"
    - "hasIsEnabled boolean pattern: excludes 'checkbox' from IsEnabled/Tooltip controls per spec"
    - "IsToggleActive.ValueChanged mirrors IsEnabled.ValueChanged: mUpdatingInspector guard + MarkDirty"
    - "PopulateInspector Select Case pattern replaces binary If/Else for scalable type dispatch"

key-files:
  created: []
  modified:
    - designer/MainWindow.xojo_window

key-decisions:
  - "IsToggleActive placed at Top=248 (same row as ResourceNameField) — ResourceNameField always disabled so no visual conflict"
  - "Tooltip and IsEnabled both gated on hasIsEnabled (not isItem) — CheckBox spec explicitly excludes these two controls"
  - "PopulateInspector Else branch (tab/group) also clears IsToggleActive.Value = False for consistency"
  - "SetInspectorState clear-fields block also resets IsToggleActive.Value = False when nothing selected"

patterns-established:
  - "All new inspector controls must appear in both SetInspectorState (enable/disable) and the clear-fields If Not anythingSelected block"
  - "ValueChanged event handlers follow the mUpdatingInspector guard + RowTagAt Dictionary write + MarkDirty pattern"

requirements-completed:
  - REQ-604
  - REQ-605
  - REQ-606

# Metrics
duration: 12min
completed: 2026-04-20
---

# Phase 06 Plan 02: Designer v2.0 — Inspector UI for New Item Types Summary

**IsToggleActive DesktopCheckBox added to inspector GroupBox1; SetInspectorState and PopulateInspector extended to handle all 5 item types with per-type enable/disable logic and Dictionary round-trip**

## Performance

- **Duration:** 12 min
- **Started:** 2026-04-20T18:22:00Z
- **Completed:** 2026-04-20T18:34:00Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments

- New DesktopCheckBox `IsToggleActive` (Caption "Default Active?") inserted into GroupBox1 at Top=248, Enabled=False, TabIndex=14
- SetInspectorState extended with `hasToggleState` and `hasIsEnabled` boolean vars; all 5 item types (large, small, splitbutton, toggle, checkbox) correctly enable/disable their respective inspector controls
- PopulateInspector replaced binary `If rowType = "large" Or rowType = "small"` with full 5-type Select Case for ItemTypeField.Text; loads `isToggleActive` from Dictionary via `d.Lookup("isToggleActive", False)`
- `IsToggleActive.ValueChanged` event added — writes `d.Value("isToggleActive") = Me.Value` with mUpdatingInspector guard and MarkDirty call
- SplitButton inspector shows MenuItem list (same as Large Button per spec)
- CheckBox inspector disables IsEnabled and Tooltip controls per spec

## Task Commits

1. **Task 1: Add IsToggleActive DesktopCheckBox control to GroupBox1 layout** - `94734b1` (feat)
2. **Task 2: Extend SetInspectorState and PopulateInspector; add IsToggleActive.ValueChanged** - `467d530` (feat)

## Files Created/Modified

- `designer/MainWindow.xojo_window` — New IsToggleActive control block, SetInspectorState extended logic, PopulateInspector Select Case block, IsToggleActive.ValueChanged event

## Decisions Made

- IsToggleActive placed at Top=248 (overlapping ResourceNameField position) — ResourceNameField is always disabled/deferred, so no functional conflict at runtime
- CheckBox type deliberately excludes IsEnabled and TooltipTextField from inspector (gated on `hasIsEnabled`, not `isItem`) — matches DEV_PLAN.md spec locked decision
- Both the SetInspectorState "clear fields" block and the PopulateInspector Else branch reset IsToggleActive.Value = False for clean state transitions

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

Whitespace mismatch on the first attempt to insert IsToggleActive.ValueChanged event — the exact tab indentation differed from what was visible in the plan. Resolved by re-reading the exact surrounding lines and using the correct indentation. No logic changes required.

## Known Stubs

None — all inspector controls are wired to real Dictionary reads/writes; no placeholder data flows to UI rendering.

## Next Phase Readiness

- Inspector fully functional for all 5 item types
- Plan 03 (JSON) can reference `isToggleActive` Dictionary key in BuildJSON/LoadFromJSON
- Plan 04 (code generator) can reference all 5 type strings in GenerateCode Select Case blocks
- No blockers

---
*Phase: 06-designer-v2-0*
*Completed: 2026-04-20*
