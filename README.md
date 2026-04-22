# XjRibbon

[screenshot](full ribbon with all 7 control types visible — Home tab showing Large/Small/Toggle buttons, View tab showing SplitButton + CheckBox items + Separator)

> MS Office-style ribbon toolbar for Xojo Desktop and Web.

## Features

- 7 control types: Large Button, Small Button, Toggle Button, Dropdown, SplitButton, CheckBox, Separator
- Desktop (DesktopCanvas) and Web (WebCanvas) — identical API
- Dark mode, HiDPI, keyboard navigation (KeyTips) on Desktop
- Visual designer with code generator

## Requirements

- Xojo 2024r3 or later
- macOS, Windows, or Linux (Desktop); any web browser (Web)

## Quick Start (Desktop)

[screenshot](ribbon running in the demo app — Home tab active)

```xojo
// 1. Add XjRibbon canvas to your window (Height = 122)
// 2. In Opening event:

Var homeTab As XjRibbonTab = XjRibbon1.AddTab("Home")
homeTab.KeyTip = "H"

Var clipGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
Call clipGroup.AddLargeButton("Paste", "clipboard.paste")
Call clipGroup.AddSmallButton("Cut", "clipboard.cut")
Call clipGroup.AddSmallButton("Copy", "clipboard.copy")
```

Handle events in XjRibbon1:
```xojo
Sub ItemPressed(tag As String)
  MessageBox "Pressed: " + tag
End Sub

Sub DropdownMenuAction(itemTag As String, menuItemTag As String)
  MessageBox itemTag + " → " + menuItemTag
End Sub
```

## Quick Start (Web)

[screenshot](web ribbon in browser — same layout as desktop)

Same API — add XjRibbon to your WebPage instead of a DesktopWindow.

## Control Types

[screenshot](all 7 control types labeled — View tab with SplitButton, CheckBox rows, Separator gap visible)

| Type | Method | Description |
|------|--------|-------------|
| Large Button | `group.AddLargeButton(caption, tag)` | 32px icon + label below, full group height |
| Small Button | `group.AddSmallButton(caption, tag)` | 16px icon + label right, stacks 3-per-column |
| Toggle Button | `group.AddLargeButton(caption, tag)` + `.IsToggle = True` | Pressed/active state |
| Dropdown Button | `group.AddDropdownButton(caption, tag)` + `.AddMenuItem(...)` | Opens popup menu |
| SplitButton | `group.AddSplitButton(caption, tag)` + `.AddMenuItem(...)` | Body fires ItemPressed; arrow opens menu |
| CheckBox | `group.AddCheckBox(caption, tag, initialChecked)` | ☐/☑ glyph with label |
| Separator | `group.AddSeparator()` | Visual gap between control clusters |

## API Reference

### XjRibbon (Canvas)

#### Tabs
```xojo
Function AddTab(caption As String) As XjRibbonTab
Function AddContextualTab(caption As String, contextGroup As String, accentColor As Color) As XjRibbonTab
Sub ShowContextualTabs(contextGroup As String)
Sub HideContextualTabs(contextGroup As String)
Sub SelectTab(index As Integer)
```

#### Items
```xojo
Function GetToggleState(tag As String) As Boolean
Sub SetToggleState(tag As String, value As Boolean)
Sub SetCollapsed(value As Boolean)
Function IsCollapsed() As Boolean
Sub Clear()
```

#### Events
```xojo
Event ItemPressed(tag As String)
Event DropdownMenuAction(itemTag As String, menuItemTag As String)
Event CollapseStateChanged(isCollapsed As Boolean)
```

#### Constants
```xojo
kXjRibbonVersion As String  // "1.0.0"
```

### XjRibbonTab
```xojo
Function AddNewGroup(caption As String) As XjRibbonGroup
Property KeyTip As String
```

### XjRibbonGroup
```xojo
Function AddLargeButton(caption As String, tag As String) As XjRibbonItem
Function AddLargeButton(caption As String, tag As String, icon As Picture) As XjRibbonItem
Function AddSmallButton(caption As String, tag As String) As XjRibbonItem
Function AddDropdownButton(caption As String, tag As String) As XjRibbonItem
Function AddSplitButton(caption As String, tag As String) As XjRibbonItem
Function AddCheckBox(caption As String, tag As String, initialChecked As Boolean = False) As XjRibbonItem
Sub AddSeparator()
```

### XjRibbonItem
```xojo
Property Icon As Picture
Property TooltipText As String
Property IsEnabled As Boolean
Property IsToggle As Boolean
Property IsToggleActive As Boolean
Property IsSplitButton As Boolean
Property KeyTip As String
Sub AddMenuItem(caption As String, tag As String)
```

## Advanced Topics

### Multi-line Button Labels
Use Chr(10) to split a label across two lines:
```xojo
Var navPane As XjRibbonItem = group.AddSplitButton("Navigation" + Chr(10) + "pane", "nav")
```

### Icons
```xojo
Var btn As XjRibbonItem = group.AddLargeButton("Save", "file.save")
btn.Icon = SaveIcon  // 32×32 Picture
```

### Contextual Tabs
[screenshot](contextual tab with accent color visible — Table Tools style)
```xojo
Var tableTab As XjRibbonTab = XjRibbon1.AddContextualTab("Table Tools", "table", Color.RGB(68, 114, 196))
// Show when table is selected:
XjRibbon1.ShowContextualTabs("table")
```

### KeyTips (Desktop only)
```xojo
homeTab.KeyTip = "H"
pasteItem.KeyTip = "V"
// Press Alt to reveal badges; type key to activate
```

### Dark Mode
XjRibbon detects the system dark mode automatically. No code required.

## Web Notes

The Web library shares the same API with these constraints:
- No KeyTip keyboard navigation (web is mouse-driven)
- Hover via JS mousemove injection (automatic — no setup needed)
- Apply 120% scaling in your layout (canvas height = 146 instead of 122)

## Designer

[screenshot](XjRibbon Designer v2.0.0 — showing tree structure with all 7 control types, inspector panel, and Copy Code button)

**XjRibbon Designer v2.0.0** — visual ribbon builder with code generator.

Supports all 7 control types. Build your ribbon visually, then click **Copy Code** to paste Xojo code directly into your project's Opening/Shown event.

- Save/load `.ribbon` project files
- Dark mode aware
- Generates ready-to-run Xojo code for Desktop or Web

## License
MIT — see [LICENSE](LICENSE)
