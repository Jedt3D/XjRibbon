milestone: v1.0

# XjRibbon — Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-04-20)

**Core value:** Drop-in ribbon toolbar covering all MS Office control types for Xojo Desktop and Web, with a visual designer.
**Current focus:** Phase 5 — Desktop Complete Control Set

## Current Status

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 1 | Desktop MVP | ✓ Complete | — |
| 2 | Desktop Polish | ✓ Complete | — |
| 3 | Desktop Collapse | ✓ Complete | — |
| 4 | Desktop Keyboard | ✓ Complete | — |
| **5** | **Desktop Complete Control Set** | **Ready to Execute** | 4 |
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

2026-04-20 — Phase 5 planning complete. 4 plans in 3 waves verified and committed. Ready to execute.
