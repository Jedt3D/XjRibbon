# XjRibbon Phase 2 Plan — Enhanced Ribbon Features

## Context

Phase 1 MVP is complete and merged to `main`. The ribbon has tab switching, groups with labels/separators, and large buttons with placeholder icons. Phase 2 adds real icons, small buttons, dropdowns, dark mode, HiDPI, and tooltips — making the component production-quality.

## Implementation Order (7 steps, each independently committable)

| Step | Feature | Depends On |
|------|---------|------------|
| 1 | Item Type enum + Icon/Tooltip properties | — |
| 2 | Real icon drawing | Step 1 |
| 3 | Dark mode color scheme | — |
| 4 | Small buttons (layout + drawing) | Steps 1, 3 |
| 5 | Dropdown buttons with popup menus | Steps 1, 3 |
| 6 | HiDPI scaling | Steps 2, 4 |
| 7 | Per-item tooltips | Step 1 |

---

## Step 1: Item Type + New Properties on XjRibbonItem

**File: `XjRibbonItem.xojo_code`** — Add properties:
```
Property ItemType As Integer = 0    // 0=Large, 1=Small, 2=Dropdown
Property Icon As Picture            // Real icon (Nil = placeholder)
Property TooltipText As String      // Per-item tooltip text
Property mMenuItems() As DesktopMenuItem  // For dropdown type
```

Add method:
```
Sub AddMenuItem(caption As String, tag As String)
```

**File: `XjRibbonGroup.xojo_code`** — Add convenience methods:
```
Function AddSmallButton(caption As String, tag As String) As XjRibbonItem
Function AddDropdownButton(caption As String, tag As String) As XjRibbonItem
Function AddLargeButton(caption As String, tag As String, icon As Picture) As XjRibbonItem  // overload
```

**File: `XjRibbon.xojo_code`** — Add public constants:
```
kItemTypeLarge = 0, kItemTypeSmall = 1, kItemTypeDropdown = 2
```

---

## Step 2: Real Icon Drawing

**File: `XjRibbon.xojo_code`** — Modify `DrawLargeButton`:
- If `item.Icon <> Nil`: draw Picture centered in icon area
- If `item.Icon Is Nil`: keep existing placeholder (blue rect + letter)
- Disabled state: use `g.Transparency = 60` for grayed-out icons

---

## Step 3: Dark Mode Color Scheme

**File: `XjRibbon.xojo_code`** — Add 15 private color properties:
```
cBackground, cContentBackground, cBorder, cTabText, cTabActiveBackground,
cTabHoverBackground, cTabAccent, cItemText, cItemDisabledText,
cItemHoverBackground, cItemPressedBackground, cGroupLabelText,
cGroupSeparator, cPlaceholderIcon, cPlaceholderIconDisabled, cPlaceholderIconText
```

Add `ResolveColors()` method called at top of Paint:
- `Color.IsDarkMode` = True → dark palette (grays 40-70, blue accent 60/150/230)
- `Color.IsDarkMode` = False → light palette (current hardcoded values, no visual change)

Replace all `Color.RGB(...)` in draw methods with color properties.

---

## Step 4: Small Buttons

**File: `XjRibbon.xojo_code`** — Add constants:
```
kSmallButtonHeight = 22, kSmallButtonIconSize = 16
kSmallButtonMinWidth = 60, kSmallButtonTextPadding = 4, kSmallRowGap = 2
```

Modify `LayoutTabs` — extract `LayoutGroupItems(g, group, groupX, contentY, contentH)`:
- Process items sequentially within a group
- Large/dropdown items: one per column, full height
- Small items: batch consecutive small items (up to 3) into vertical columns
- Each column of small buttons stacks vertically, centered in available height

Add `DrawSmallButton(g, item)`:
- 16x16 icon on left + text to the right
- Hover/pressed round-rect background
- Same icon fallback as large button (small colored square)

Modify `DrawGroups` to dispatch: `Select Case item.ItemType` → DrawLargeButton / DrawSmallButton / DrawDropdownButton

---

## Step 5: Dropdown Buttons

**File: `XjRibbon.xojo_code`** — Add constants:
```
kDropdownArrowSize = 6
```

Add `DrawDropdownButton(g, item)`:
- Draws like a large button + small downward chevron arrow below caption

Add event definition:
```
Event DropdownMenuAction(itemTag As String, menuItemTag As String)
```

Modify `MouseUp`:
- If pressed item is dropdown with mMenuItems: create `DesktopMenuItem`, add children, call `.PopUp`, raise `DropdownMenuAction` with selected tag
- If no menu items: fall through to regular `ItemPressed`

---

## Step 6: HiDPI Scaling

**File: `XjRibbon.xojo_code`** — Modify icon drawing in `DrawLargeButton` and `DrawSmallButton`:
- Use full `DrawPicture(pic, destX, destY, destW, destH, srcX, srcY, srcW, srcH)` signature
- Always draw icons at logical size (32x32 or 16x16) regardless of source pixel dimensions
- Xojo's Graphics handles the rest when HiDPI=True

No layout changes needed — all constants are already in logical points.

---

## Step 7: Per-Item Tooltips

**File: `XjRibbon.xojo_code`** — Modify `MouseMove`:
- If hovered item has `TooltipText`: set `Me.Tooltip = item.TooltipText`
- If hovered tab: set `Me.Tooltip = tab.Caption`
- Otherwise: clear `Me.Tooltip`
- Guard with `If Me.Tooltip <> ...` to avoid flicker

---

## Files Modified per Step

| File | S1 | S2 | S3 | S4 | S5 | S6 | S7 |
|------|----|----|----|----|----|----|-----|
| XjRibbonItem.xojo_code | **Major** | — | — | — | — | — | — |
| XjRibbonGroup.xojo_code | **Mod** | — | — | — | — | — | — |
| XjRibbon.xojo_code | Minor | Mod | **Major** | **Major** | Mod | Minor | Minor |
| MainWindow.xojo_window | — | Demo | — | Demo | Demo | — | Demo |

## New Public API (after all steps)

```xojo
// XjRibbonGroup
Function AddSmallButton(caption, tag) As XjRibbonItem
Function AddDropdownButton(caption, tag) As XjRibbonItem
Function AddLargeButton(caption, tag, icon) As XjRibbonItem  // overload

// XjRibbonItem
Property Icon As Picture
Property TooltipText As String
Property ItemType As Integer
Sub AddMenuItem(caption, tag)

// XjRibbon — new event
Event DropdownMenuAction(itemTag, menuItemTag)
```

All existing MVP APIs remain unchanged. Fully backward-compatible.

## Verification

1. Compile and run — no errors
2. Home tab: mix of large buttons (with placeholder icons) and verify layout unchanged
3. Toggle macOS dark mode (System Settings > Appearance) — ribbon colors adapt
4. Add small buttons to a group — verify they stack in columns of 3
5. Add a dropdown button — click it, verify popup menu appears, selection fires event
6. Hover over items with TooltipText set — verify native tooltip appears
7. Test on Retina display — verify icons render crisply at logical size
