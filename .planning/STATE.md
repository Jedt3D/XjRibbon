---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: Full Control Set + Release
status: unknown
last_updated: "2026-04-20T13:05:21.058Z"
progress:
  total_phases: 8
  completed_phases: 1
  total_plans: 4
  completed_plans: 4
  percent: 100
---

milestone: v1.0

# XjRibbon — Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-20)

**Core value:** Drop-in ribbon toolbar covering all MS Office control types for Xojo Desktop and Web, with a visual designer.
**Current focus:** Phase --phase — 5

## Current Status

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 1 | Desktop MVP | ✓ Complete | — |
| 2 | Desktop Polish | ✓ Complete | — |
| 3 | Desktop Collapse | ✓ Complete | — |
| 4 | Desktop Keyboard | ✓ Complete | — |
| **5** | **Desktop Complete Control Set** | **In Progress (3/4)** | 4 |
| 6 | Designer v2.0 | Planned | 0 |
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

- v1.0.0 complete — knows `"large"`, `"small"`, `"dropdown"` itemTypes
- v2.0 will add `"splitbutton"`, `"toggle"`, `"checkbox"` to JSON schema + inspector + code gen

## Last Activity

2026-04-20T13:01:11Z — Completed 05-03-PLAN.md. All canvas changes applied to XjRibbon.xojo_code: constants kItemTypeCheckBox/kItemTypeSeparator, mPressedOnArrow property, DrawCheckBoxItem method, DrawGroups Case 3/4 dispatch, LayoutTabs CheckBox batch + Separator branch, DrawDropdownButton SplitButton separator, MouseDown/MouseUp SplitButton dispatch (commits 69d6ad9, b17e2f0, e67e430, 19d8995). Phase 5 plan 3/4 done.
