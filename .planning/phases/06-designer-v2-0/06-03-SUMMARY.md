---
phase: 06-designer-v2-0
plan: 03
subsystem: ui
tags: [xojo, designer, ribbon, json, serialization, round-trip]

# Dependency graph
requires:
  - phase: 06-01
    provides: splitbutton/toggle/checkbox type strings established in RibbonStructure row Dictionaries
  - phase: 06-02
    provides: isToggleActive field in row Dictionary (written by IsToggleActive.ValueChanged)
provides:
  - BuildJSON emits isToggleActive field for toggle and checkbox item types
  - LoadFromJSON Select Case covers all 5 item types with correct col-1 labels
  - LoadFromJSON parses isToggleActive field from JSON into row Dictionary
  - Full JSON round-trip correctness for all 5 item types
affects:
  - 06-04 (code generator plan — all 5 type strings fully persisted, safe to generate code from loaded files)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "BuildJSON conditional emission: If type = toggle Or checkbox Then emit isToggleActive field — avoids polluting JSON schema for non-toggle types"
    - "LoadFromJSON Select Case iType with Else fallback for forward-compatibility with unknown future types"
    - "isToggleActive Lookup with False default in both BuildJSON (read) and LoadFromJSON (parse) — consistent nil-safe pattern"

key-files:
  created: []
  modified:
    - designer/MainWindow.xojo_window

key-decisions:
  - "isToggleActive field emitted only for toggle and checkbox types in BuildJSON — large/small/splitbutton rows do not include this field in JSON output"
  - "Select Case Else fallback emits raw iType string as col-1 label — forward-compatible for any type string added in future designer versions"
  - "isToggleActive parsed for ALL item types in LoadFromJSON (not just toggle/checkbox) via Lookup with False default — avoids conditional logic overhead and is harmless for types that never set it"

patterns-established:
  - "LoadFromJSON type-dispatch pattern: Select Case iType with explicit Case per type + Else fallback — must be maintained when adding future item types"
  - "JSON round-trip completeness: every field written by BuildJSON must have a corresponding Lookup in LoadFromJSON with the same default value"

requirements-completed:
  - REQ-602
  - REQ-603

# Metrics
duration: 2min
completed: 2026-04-20
---

# Phase 06 Plan 03: Designer v2.0 — JSON Round-Trip Fix Summary

**BuildJSON now emits isToggleActive for toggle/checkbox; LoadFromJSON replaces binary If/Else with Select Case covering all 5 item types, fixing save/load round-trip correctness**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-20T18:20:20Z
- **Completed:** 2026-04-20T18:22:30Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments

- BuildJSON extended with conditional isToggleActive emission: toggle and checkbox rows now include `"isToggleActive": true/false` in the JSON output; other types are unchanged
- LoadFromJSON binary `If iType = "large" Then ... Else "Small Button"` replaced with full Select Case covering large, small, splitbutton, toggle, checkbox with correct col-1 display labels plus a forward-compatible Else fallback
- LoadFromJSON now parses `isToggleActive` from JSON and stores it in the row Dictionary via `id.Value("isToggleActive") = itemObj.Lookup("isToggleActive", False)`
- JSON round-trip is now lossless for all 5 item types — a .ribbon file saved with new types loads back with correct labels and isToggleActive state preserved

## Task Commits

1. **Task 1: Extend BuildJSON to emit isToggleActive for toggle and checkbox types** - `44c7fc2` (feat)
2. **Task 2: Fix LoadFromJSON col-1 label (Select Case) and add isToggleActive parse** - `7866193` (feat)

## Files Created/Modified

- `designer/MainWindow.xojo_window` — BuildJSON isToggleActive conditional emission block; LoadFromJSON Select Case iType replacing binary If/Else; LoadFromJSON id.Value("isToggleActive") field parse

## Decisions Made

- isToggleActive is emitted only for toggle and checkbox types in BuildJSON (not for large/small/splitbutton) — matches the JSON schema spec from DEV_PLAN.md; avoids schema pollution for types that don't use this field
- The Select Case Else fallback in LoadFromJSON emits `iType` as the raw col-1 label string — forward-compatible with any future type strings without crashing

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

Exact whitespace in the source file uses a mix of tabs and spaces (`\t\t` + spaces indentation). The Edit tool's string matching failed on the first attempt because the blank line between `tooltipText` and `menuItemsArr` in BuildJSON contained trailing whitespace (`\t\t            `). Resolved by inspecting raw bytes with Python and using byte-level replacement. No logic changes required.

## Known Stubs

None — all new JSON fields are fully wired; no placeholder data flows to UI rendering.

## Threat Flags

No new network endpoints, auth paths, file access patterns, or schema changes at trust boundaries introduced. The existing T-06-05/T-06-06 threat model is unchanged.

## Next Phase Readiness

- JSON persistence fully correct for all 5 item types
- Plan 04 (code generator) can read loaded .ribbon files with confidence that all 5 type strings and isToggleActive values are preserved
- No blockers

---
*Phase: 06-designer-v2-0*
*Completed: 2026-04-20*
