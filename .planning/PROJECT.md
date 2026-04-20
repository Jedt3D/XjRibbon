# XjRibbon

## What This Is

XjRibbon is a production-quality MS Office–style ribbon toolbar control library for Xojo Desktop and Web applications. It provides tabs, groups, and all standard ribbon control types (large/small buttons, dropdowns, split buttons, checkboxes, toggle buttons) rendered on a DesktopCanvas. A companion visual designer tool lets developers build ribbon layouts and generate Xojo code.

## Core Value

A drop-in ribbon toolbar that covers every control type seen in Windows File Explorer, works identically on Desktop and Web, and ships with a visual designer — so Xojo developers can build Office-style UIs without writing low-level canvas rendering code.

## Requirements

### Validated

- ✓ Tabs, groups, large buttons, events — Phase 1
- ✓ Small buttons, dropdown, dark mode, icons, HiDPI, tooltips — Phase 2
- ✓ Ribbon collapse, contextual tabs — Phase 3
- ✓ Toggle buttons, keyboard navigation (KeyTips) — Phase 4 (desktop)
- ✓ Web parity through Phase 3, hover via JS mousemove injection — Web Phases MVP–2.5
- ✓ Designer v1.0.0: Tab/Group/Large/Small/Dropdown hierarchy, Save/Load, Code gen — Designer v1

### Active

- [ ] SplitButton — two independent hit areas (body = action, arrow = menu)
- [ ] CheckBox item — ☐/☑ glyph, text-only row, stacks in groups
- [ ] Separator item — column boundary inside a group
- [ ] Designer v2.0 — Toggle, CheckBox, SplitButton in inspector + code gen
- [ ] Web Phase 5 — port SplitButton/CheckBox/Separator to WebCanvas
- [ ] Library v1.0 — package + README for distribution

### Out of Scope

- Web keyboard navigation (KeyTips) — web is mouse-driven; JS injection complexity not worth it for undiscoverable feature
- Custom drawing per-item by caller — renders inside library canvas, not composited
- Native OS widgets — pure DesktopCanvas rendering throughout

## Context

- Xojo 2025 Desktop and Web targets
- Pure DesktopCanvas (desktop) and WebCanvas (web) rendering — no native control compositing
- Web constraints: no native MouseMove, no `g.TextWidth`, no `g.Transparency`, `FillRoundRectangle` single corner param, 120% scaling applied throughout
- Reference: Windows File Explorer ribbon (`image ref/explorer_ribbon_toolbar.json`) — Home, Share, View tabs

## Constraints

- **Platform**: Xojo 2025 API 2.0 — no deprecated API
- **Rendering**: DesktopCanvas/WebCanvas only — no third-party controls or native widgets
- **Backward compat**: New item types must not break existing code; `IsSplitButton` default `False`, `kItemTypeSeparator` non-interactive
- **Web**: Apply 120% scaling throughout; no JS beyond existing mousemove hash injection pattern

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| `IsSplitButton` flag on ItemType=2 | Avoids new ItemType; backward compatible | — Pending |
| `kItemTypeCheckBox = 3` reuses `IsToggleActive` | No new state; consistent toggle API | — Pending |
| No web keyboard nav (Phase 4) | Web users don't discover Alt-key shortcuts; ~200 lines for 0 discoverability | ✓ Good |
| Designer uses JSON `.ribbon` schema | Human-readable, easy to extend, versionable | ✓ Good |
| Canvas rendering (not native) | Identical look on mac/win/linux; full control over HiDPI/dark mode | ✓ Good |

---
*Last updated: 2026-04-20 — project bootstrapped from DEV_PLAN.md*
