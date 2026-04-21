# XjRibbon — Roadmap

## 🚧 **v1.0 Full Control Set + Release**

### Milestone Goal

Ship a complete MS Office–style ribbon library for Xojo covering every control type visible in the Windows File Explorer reference, with a visual designer and full Desktop/Web parity.

### Phase Summary

- [x] **Phase 1: Desktop MVP** — Tabs, groups, large buttons, events
- [x] **Phase 2: Desktop Polish** — Small buttons, dropdown, dark mode, icons, HiDPI, tooltips
- [x] **Phase 3: Desktop Collapse** — Ribbon collapse, contextual tabs
- [x] **Phase 4: Desktop Keyboard** — Toggle buttons, keyboard navigation (KeyTips)
- [x] **Phase 5: Desktop Complete Control Set** — SplitButton, CheckBox item, Separator item
- [x] **Phase 6: Designer v2.0** — New control types in designer + code gen (5/5 plans complete)
- [x] **Phase 7: Web Phase 5** — CheckBox, SplitButton, Separator parity on Web
- [ ] **Phase 8: Library v1.0 Release** — Package, README, distribution

---

### Phase 5: Desktop Complete Control Set

**Goal:** Add CheckBox item, SplitButton mode, and Separator item to the desktop ribbon library to reach full coverage of the Windows File Explorer reference control set.
**Status:** Complete (4/4 plans complete)
**Depends on:** Phase 4
**Plans:** 4 plans

Plans:
- [x] 05-01-PLAN.md — Add IsSplitButton property to XjRibbonItem
- [x] 05-02-PLAN.md — Add AddSplitButton, AddCheckBox, AddSeparator factory methods to XjRibbonGroup
- [x] 05-03-PLAN.md — Core canvas changes: constants, DrawCheckBoxItem, layout, draw dispatch, SplitButton mouse handling
- [x] 05-04-PLAN.md — Demo update: Show/hide group and Panes SplitButton in MainWindow

#### Files to Modify

- `desktop/XjRibbonItem.xojo_code` — add `IsSplitButton As Boolean` property
- `desktop/XjRibbonGroup.xojo_code` — add `AddSplitButton`, `AddCheckBox`, `AddSeparator` methods
- `desktop/XjRibbon.xojo_code` — add constants, drawing methods, hit-test, mouse handling
- `desktop/MainWindow.xojo_window` — update demo with Show/hide group and Panes SplitButton

#### Steps

1. SplitButton mode — `IsSplitButton` flag on ItemType=2, hit-test split at 80%/20%, separator line draw
2. CheckBox item — `kItemTypeCheckBox=3`, glyph draw (13×13 rounded rect + checkmark), layout stack
3. Separator item — `kItemTypeSeparator=4`, column bump in `LayoutGroupItems`, no render
4. Demo update — Show/hide group (3 checkboxes + separator + small button), Panes group (SplitButton)

#### New Public API

```xojo
XjRibbonItem.IsSplitButton As Boolean
XjRibbonGroup.AddSplitButton(caption, tag) As XjRibbonItem
XjRibbonGroup.AddCheckBox(caption, tag, initialState) As XjRibbonItem
XjRibbonGroup.AddSeparator()
```

---

### Phase 6: Designer v2.0

**Goal:** Add SplitButton, Toggle Button, and CheckBox item types to the designer — including inspector panels, JSON schema, and code generator support.
**Status:** Complete (5/5 plans complete)
**Depends on:** Phase 5
**Plans:** 5 plans

Plans:
- [x] 06-01-PLAN.md — AddItemPopup + SelectionChanged new types + CascadeTagUpdate + UpdateDropdownColumn
- [x] 06-02-PLAN.md — IsToggleActive control + SetInspectorState + PopulateInspector + ValueChanged event
- [x] 06-03-PLAN.md — BuildJSON isToggleActive emission + LoadFromJSON Select Case fix + isToggleActive parse
- [x] 06-04-PLAN.md — GenerateCode Select Case restructure with splitbutton, toggle, checkbox cases
- [x] 06-05-PLAN.md — Version bump to 2.0.0 in all 4 locations

#### Files to Modify

- `designer/MainWindow.xojo_window` — update `AddItemPopup`, `PopulateInspector`, `GenerateCode`
- `designer/AboutBox.xojo_window` — update `CopyrightLabel` version string
- `.ribbon` JSON schema — extend `itemType` to include `"splitbutton"`, `"toggle"`, `"checkbox"`

#### New JSON Schema Fields

```json
"itemType": "large" | "small" | "dropdown" | "splitbutton" | "toggle" | "checkbox"
"isToggleActive": true | false    (for toggle and checkbox types)
```

---

### Phase 7: Web Phase 5

**Goal:** Port desktop Phase 5 control types (CheckBox, SplitButton, Separator) to the WebCanvas ribbon library.
**Status:** Complete (3/3 plans complete — human verification passed)
**Depends on:** Phase 5
**Plans:** 3 plans

Plans:
- [x] 07-01-PLAN.md — Add IsSplitButton property to web XjRibbonItem
- [x] 07-02-PLAN.md — Add AddSplitButton, AddCheckBox, AddSeparator factory methods to web XjRibbonGroup
- [x] 07-03-PLAN.md — All canvas changes: constants, DrawCheckBoxItem, layout, draw dispatch, SplitButton Pressed dispatch, visual polish

#### Web Adaptations

- `DrawCheckBoxItem`: `g.FillRoundRectangle(x, y, w, h, 3)` single corner param (5 args not 6)
- Hit-test: `kArrowZoneWidth = 24` inline in Pressed event (no mPressedOnArrow needed)
- No new JS injection required; existing hover infrastructure handles SplitButton
- 120% scaling throughout: glyph=16, arrowZone=24, icon=38, buttonWidth=67

#### Files to Modify

- `web/XjRibbonItem.xojo_code` — add `IsSplitButton As Boolean`
- `web/XjRibbonGroup.xojo_code` — add `AddSplitButton`, `AddCheckBox`, `AddSeparator`
- `web/XjRibbon.xojo_code` — constants, drawing, hit-test, Pressed dispatch, visual polish

---

### Phase 8: Library v1.0 Release

**Goal:** Package XjRibbon for distribution with updated README, doc comments, version tag, and example project.
**Status:** Planned
**Depends on:** Phase 7

#### Deliverables

- Updated README covering Desktop, Web, Designer with code examples for all control types
- Public API doc comments throughout
- Example project demonstrating all 7 control types (Large, Small, Toggle, Dropdown, SplitButton, CheckBox, Separator)
- Git tag `v1.0.0` on main branch

---

<details>
<summary>✅ v0.x — Foundation (Phases 1–4, Complete)</summary>

### Phase 1: Desktop MVP (Complete)

**Goal:** Tabs, groups, large buttons, event system.
**Status:** Complete

### Phase 2: Desktop Polish (Complete)

**Goal:** Small buttons, dropdown buttons, dark mode, icon support, HiDPI rendering, tooltips.
**Status:** Complete

### Phase 3: Desktop Collapse (Complete)

**Goal:** Ribbon collapse/expand with chevron, contextual tabs with accent color.
**Status:** Complete

### Phase 4: Desktop Keyboard (Complete)

**Goal:** Toggle buttons (IsToggle/IsToggleActive), keyboard navigation (KeyTip badges, Alt-key state machine).
**Status:** Complete

</details>

---

## Post-v1.0 Backlog

### Phase 9: Designer v3.0 — Live Preview

**Goal:** Embed a live XjRibbon canvas in the designer window (WYSIWYG preview pane).
**Status:** Future — post-v1.0
**Depends on:** Phase 6

`RebuildPreview()` traverses the same JSON data model as `GenerateCode`, calling real XjRibbon API methods instead of generating string code. Triggered on every edit.
