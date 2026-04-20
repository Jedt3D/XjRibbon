# XjRibbon — Requirements

## Phase 5: Desktop Phase 5 — Complete Control Set

- [ ] REQ-501: Add `IsSplitButton As Boolean` property to `XjRibbonItem` (default `False`)
- [ ] REQ-502: SplitButton hit-test separates body (≥80% width) vs arrow area (≤20% width)
- [ ] REQ-503: SplitButton body click fires `RaiseEvent ItemPressed(tag)` (no menu)
- [ ] REQ-504: SplitButton arrow click opens popup menu → `RaiseEvent DropdownMenuAction(itemTag, menuItemTag)`
- [ ] REQ-505: SplitButton draws thin vertical separator line at 80% width; chevron in 20% area only
- [ ] REQ-506: Add `kItemTypeCheckBox = 3` constant to `XjRibbon`
- [ ] REQ-507: CheckBox draws 13×13 rounded-rect glyph (unfilled = unchecked, blue + checkmark = checked)
- [ ] REQ-508: CheckBox layout: `[13px glyph] [4px gap] [text]` — no icon slot, no icon background
- [ ] REQ-509: CheckBox stacks in columns of 3 (same as small button in `LayoutGroupItems`)
- [ ] REQ-510: CheckBox click flips `IsToggleActive`, raises `ItemPressed`
- [ ] REQ-511: Add `kItemTypeSeparator = 4` constant to `XjRibbon`
- [ ] REQ-512: Separator causes `LayoutGroupItems` to start a new sub-column (bump groupX); no render, no interaction
- [ ] REQ-513: `XjRibbonGroup.AddSplitButton(caption, tag)` — sets ItemType=2, IsSplitButton=True
- [ ] REQ-514: `XjRibbonGroup.AddCheckBox(caption, tag, initialState)` — sets ItemType=3, IsToggle=True, IsToggleActive=initialState
- [ ] REQ-515: `XjRibbonGroup.AddSeparator()` — sets ItemType=4
- [ ] REQ-516: Demo window updated with "Show/hide" group (3 checkboxes + separator + small button) and "Panes" group (SplitButton with menu items)

## Phase 6: Designer v2.0 — New Control Types

- [ ] REQ-601: `AddItemPopup` in designer lists SplitButton, Toggle Button, CheckBox as new options
- [ ] REQ-602: `.ribbon` JSON schema supports `"itemType": "splitbutton" | "toggle" | "checkbox"`
- [ ] REQ-603: `BuildJSON` and `LoadFromJSON` handle new item types
- [ ] REQ-604: Inspector for SplitButton: identical to Dropdown (has MenuItem list)
- [ ] REQ-605: Inspector for Toggle Button: same as Large Button + "Default Active?" checkbox
- [ ] REQ-606: Inspector for CheckBox: Caption, Tag, Default Checked, Tooltip (no MenuItems)
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
