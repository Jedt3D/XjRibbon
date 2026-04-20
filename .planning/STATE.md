---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: Full Control Set + Release
status: unknown
last_updated: "2026-04-20T12:52:00Z"
progress:
  total_phases: 8
  completed_phases: 0
  total_plans: 4
  completed_plans: 2
  percent: 50
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
| **5** | **Desktop Complete Control Set** | **In Progress (2/4)** | 4 |
| 6 | Designer v2.0 | Planned | 0 |
| 7 | Web Phase 5 | Planned | 0 |
| 8 | Library v1.0 Release | Planned | 0 |

## Key Decisions

- `IsSplitButton` added as flag on `ItemType=2` — no new ItemType needed, backward compatible
- `kItemTypeCheckBox=3` reuses `IsToggleActive` for checked state — consistent toggle API
- `kItemTypeSeparator=4` — zero-width item, column boundary only, no interaction
- Web keyboard navigation (Phase 4 equivalent) — deliberately deferred; web is mouse-driven
- Web rendering applies 120% scaling throughout; uses single-corner `FillRoundRectangle`

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

2026-04-20T12:52:00Z — Completed 05-02-PLAN.md. AddSplitButton, AddCheckBox, AddSeparator factory methods added to XjRibbonGroup (commits 74f2fde, 09fdc3f, d9befdc). Phase 5 plan 2/4 done.
