# XjRibbon — Requirements

## Phase 5: Desktop Phase 5 — Complete Control Set

- [ ] REQ-501: Add `IsSplitButton As Boolean` property to `XjRibbonItem` (default `False`)
- [x] REQ-502
: SplitButton hit-test separates body (≥80% width) vs arrow area (≤20% width)
- [x] REQ-503
: SplitButton body click fires `RaiseEvent ItemPressed(tag)` (no menu)
- [x] REQ-504
: SplitButton arrow click opens popup menu → `RaiseEvent DropdownMenuAction(itemTag, menuItemTag)`
- [x] REQ-505
: SplitButton draws thin vertical separator line at 80% width; chevron in 20% area only
- [x] REQ-506
: Add `kItemTypeCheckBox = 3` constant to `XjRibbon`
- [x] REQ-507
: CheckBox draws 13×13 rounded-rect glyph (unfilled = unchecked, blue + checkmark = checked)
- [x] REQ-508
: CheckBox layout: `[13px glyph] [4px gap] [text]` — no icon slot, no icon background
- [x] REQ-509
: CheckBox stacks in columns of 3 (same as small button in `LayoutGroupItems`)
- [x] REQ-510
: CheckBox click flips `IsToggleActive`, raises `ItemPressed`
- [x] REQ-511
: Add `kItemTypeSeparator = 4` constant to `XjRibbon`
- [x] REQ-512
: Separator causes `LayoutGroupItems` to start a new sub-column (bump groupX); no render, no interaction
- [x] REQ-513: `XjRibbonGroup.AddSplitButton(caption, tag)` — sets ItemType=2, IsSplitButton=True
- [x] REQ-514: `XjRibbonGroup.AddCheckBox(caption, tag, initialState)` — sets ItemType=3, IsToggle=True, IsToggleActive=initialState
- [x] REQ-515: `XjRibbonGroup.AddSeparator()` — sets ItemType=4
- [x] REQ-516
: Demo window updated with "Show/hide" group (3 checkboxes + separator + small button) and "Panes" group (SplitButton with menu items)

## Phase 6: Designer v2.0 — New Control Types

- [x] REQ-601
: `AddItemPopup` in designer lists SplitButton, Toggle Button, CheckBox as new options
- [ ] REQ-602: `.ribbon` JSON schema supports `"itemType": "splitbutton" | "toggle" | "checkbox"`
- [ ] REQ-603: `BuildJSON` and `LoadFromJSON` handle new item types
- [x] REQ-604
: Inspector for SplitButton: identical to Dropdown (has MenuItem list)
- [x] REQ-605
: Inspector for Toggle Button: same as Large Button + "Default Active?" checkbox
- [x] REQ-606
: Inspector for CheckBox: Caption, Tag, Default Checked, Tooltip (no MenuItems)
- [ ] REQ-607: Code generator handles `"splitbutton"`, `"toggle"`, `"checkbox"` cases
- [ ] REQ-608: Version bumped to 2.0.0 in StatusBar and AboutBox

## Phase 7: Web Phase 5 — Control Set Parity

- [ ] REQ-701: Web `XjRibbonItem` gains `IsSplitButton As Boolean` property
- [ ] REQ-702: Web SplitButton hit-test and rendering mirrors desktop Phase 5
- [ ] REQ-703: Web `DrawCheckBoxItem` uses `g.FillRoundRectangle(x, y, w, h, 3)` (single corner param)
- [ ] REQ-704: Web `kItemTypeCheckBox = 3` and `kItemTypeSeparator = 4` added
- [ ] REQ-705: Web `XjRibbonGroup.AddSplitButton`, `AddCheckBox`, `AddSeparator` methods added

## Phase 8: Library v1.0 — Package & Release

- [ ] REQ-801: README updated covering Desktop, Web, and Designer with code examples
- [ ] REQ-802: All public API documented with doc comments
- [ ] REQ-803: Version tagged v1.0.0 on main branch
- [ ] REQ-804: Example project included demonstrating all control types
