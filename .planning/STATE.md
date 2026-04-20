---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: Full Control Set + Release
status: unknown
last_updated: "2026-04-20T18:29:44.685Z"
progress:
  total_phases: 8
  completed_phases: 2
  total_plans: 9
  completed_plans: 9
  percent: 100
---

milestone: v1.0

# XjRibbon — Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-20)

**Core value:** Drop-in ribbon toolbar covering all MS Office control types for Xojo Desktop and Web, with a visual designer.
**Current focus:** Phase 6 — Designer v2.0

## Current Status

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 1 | Desktop MVP | ✓ Complete | — |
| 2 | Desktop Polish | ✓ Complete | — |
| 3 | Desktop Collapse | ✓ Complete | — |
| 4 | Desktop Keyboard | ✓ Complete | — |
| **5** | **Desktop Complete Control Set** | **✓ Complete (4/4)** | 4 |
| 6 | Designer v2.0 | In Progress (5/5) | 5 |
| 7 | Web Phase 5 | Planned | 0 |
| 8 | Library v1.0 Release | Planned | 0 |

## Key Decisions

- `IsSplitButton` added as flag on `ItemType=2` — no new ItemType needed, backward compatible
- `kItemTypeCheckBox=3` reuses `IsToggleActive` for checked state — consistent toggle API
- `kItemTypeSeparator=4` — zero-width item, column boundary only, no interaction
- Web keyboard navigation (Phase 4 equivalent) — deliberately deferred; web is mouse-driven
- Web rendering applies 120% scaling throughout; uses single-corner `FillRoundRectangle`
- `mPressedOnArrow` placed on canvas not XjRibbonItem — transient interaction state, avoids polluting item data model
- Case 4 explicit in DrawGroups prevents Separator triggering DrawLargeButton render artifact
- `kArrowZoneWidth=20` fixed-pixel constant chosen over 80/20 ratio — consistent SplitButton hit-test across all button widths
- Group caption font settled at 10pt after iterating 11pt (too large) and 9pt (too small)
- IsToggleActive placed at Top=248 (same row as ResourceNameField) — always-disabled ResourceNameField creates no functional conflict
- CheckBox inspector excludes IsEnabled and Tooltip controls — gated on hasIsEnabled not isItem per DEV_PLAN spec
- GenerateCode Select Case pattern chosen over ElseIf chain — toggle Case always uses Var form since .IsToggle = True requires item reference; checkbox Var/Call split on isActive value
- LoadSampleRibbon hardcoded JSON version bumped from "1.0" to "2.0" alongside BuildJSON — consistent schema version across all ribbon JSON sources

## Technical Context

### desktop/ Library

- Current `ItemType` constants: 0=Large, 1=Small, 2=Dropdown
- `IsToggle` flag: adds pressed/depressed state to type 0 or 1
- Phase 5 adds: `IsSplitButton` on type 2, `kItemTypeCheckBox=3`, `kItemTypeSeparator=4`

### web/ Library

- No native MouseMove — hover via `window.location.hash` + `Session.HashTagChanged`
- No `g.TextWidth` — use `Picture.Graphics` workaround
- No `g.Transparency` — use Color alpha
- `FillRoundRectangle` takes single corner param
- 120% scaling applied throughout

### designer/ Tool

- v2.0.0 complete — knows `"large"`, `"small"`, `"dropdown"`, `"splitbutton"`, `"toggle"`, `"checkbox"` itemTypes
- Version string updated to 2.0.0 across StatusBar, AboutBox, GenerateCode header, BuildJSON, and LoadSampleRibbon

## Last Activity

2026-04-20T18:30:00Z — Completed 06-04-PLAN.md. GenerateCode item dispatch restructured from If/End If to Select Case with Case blocks for all 5 item types: splitbutton (AddSplitButton + menu loop), toggle (AddLargeButton + .IsToggle = True + conditional .IsToggleActive = True), checkbox (conditional Var/Call form of AddCheckBox). Case "large","small" unchanged — no regression. Commit d08dd44. REQ-607 complete.

2026-04-20T18:40:00Z — Completed 06-05-PLAN.md. Version strings bumped from 1.0.0 to 2.0.0 in all four locations: StatusBar Text, AboutBox CopyrightLabel, GenerateCode header comment, BuildJSON root.Value("version"). Also bumped LoadSampleRibbon sample JSON from "1.0" to "2.0" for schema consistency (Rule 2 auto-fix). Commit 5dcaa57. REQ-608 complete.
