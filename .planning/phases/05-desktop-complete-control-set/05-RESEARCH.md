# Phase 5: Desktop Complete Control Set — Research

**Researched:** 2026-04-20
**Domain:** Xojo Desktop Canvas rendering, hit-testing, mouse dispatch
**Confidence:** HIGH — all findings extracted directly from the four source files

---

## Summary

Phase 5 adds three new control types (CheckBox, SplitButton mode, Separator) to the existing
desktop ribbon library. The codebase is highly consistent: each new control type follows the
same four-step pattern already established for Small buttons, Large buttons, and Dropdown buttons:
(1) constant defined, (2) layout branch added in `LayoutGroupItems` (inside `LayoutTabs`),
(3) draw method added and dispatched from `DrawGroups`, and (4) hit-test and mouse-event
handlers updated. All four files that need changes are small and well-structured, making
insertion points unambiguous.

The `LayoutGroupItems` loop lives inside the private `LayoutTabs(g)` method (lines 328–391
of `XjRibbon.xojo_code`). The Small-button stacking column logic is a `While` loop that
consumes up to 3 consecutive ItemType=1 items into a batch, computes `colWidth` from the
widest text, then places them. CheckBox items must be treated identically to Small items in
this loop. SplitButton hit-split requires a new private field `mPressedOnArrow As Boolean`
and changes to `HitTestItems`, `MouseDown`, and `MouseUp`. Separator only needs a branch
in the layout loop — no drawing, no hit response.

**Primary recommendation:** Implement all four changes in a single pass per file, sequenced
as: XjRibbonItem (1 property), XjRibbonGroup (3 methods), XjRibbon (constants + layout +
draw + hit-test + mouse), MainWindow (demo additions). No architectural changes required.

---

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| IsSplitButton property storage | XjRibbonItem class | — | All item state lives on XjRibbonItem |
| SplitButton body/arrow hit-split | XjRibbon (Canvas) | — | All hit-testing is in XjRibbon.HitTestItems |
| SplitButton separator line draw | XjRibbon.DrawDropdownButton | — | Rendering owned by XjRibbon |
| CheckBox glyph draw | XjRibbon.DrawCheckBoxItem (new) | — | Dispatched from DrawGroups like other types |
| CheckBox layout stacking | XjRibbon.LayoutTabs (inner loop) | — | Same loop that handles Small columns |
| Separator column bump | XjRibbon.LayoutTabs (inner loop) | — | Only needs groupX advance; no draw |
| New convenience methods | XjRibbonGroup | — | All AddXxx factory methods live here |
| Demo setup | MainWindow.Opening event | — | All current demo code is in this one event |

---

## Existing Constants (all in XjRibbon.xojo_code)

Scope = Private unless noted as Public.

| Constant | Value | Type | Scope | Relevance to Phase 5 |
|----------|-------|------|-------|----------------------|
| kSmallButtonHeight | 22 | Double | Private | CheckBox row height — reuse directly |
| kSmallButtonIconSize | 16 | Double | Private | Not used by CheckBox (no icon slot) |
| kSmallButtonMinWidth | 60 | Double | Private | CheckBox columns — same min-width applies |
| kSmallButtonTextPadding | 4 | Double | Private | Gap after CheckBox glyph |
| kSmallRowGap | 2 | Double | Private | Vertical gap between stacked CheckBox rows |
| kLargeButtonWidth | 56 | Double | Private | SplitButton width (ItemType=2 uses this) |
| kLargeButtonIconSize | 32 | Double | Private | Icon in SplitButton body area |
| kItemGap | 4 | Double | Private | Gap between columns (used after each column) |
| kGroupPaddingH | 8 | Double | Private | Horizontal padding at group edges |
| kGroupGap | 8 | Double | Private | Gap between groups |
| kGroupLabelHeight | 16 | Double | Private | Reserved at bottom for group caption |
| kDropdownArrowSize | 6 | Double | Private | Chevron drawn in DrawDropdownButton |
| kContentTop | 26 | Double | Private | Top of content area (below tab strip) |
| kContentPadding | 4 | Double | Private | Vertical padding inside content area |
| kItemTypeLarge | 0 | Double | **Public** | Large button |
| kItemTypeSmall | 1 | Double | **Public** | Small button |
| kItemTypeDropdown | 2 | Double | **Public** | Dropdown/SplitButton |
| kKeyTipNone | 0 | Double | Private | (not Phase 5 concern) |
| kKeyTipLevel1 | 1 | Double | Private | (not Phase 5 concern) |
| kKeyTipLevel2 | 2 | Double | Private | (not Phase 5 concern) |

**New constants needed (Phase 5):**
```xojo
#tag Constant, Name = kItemTypeCheckBox, Type = Double, Dynamic = False, Default = "3", Scope = Public
#tag EndConstant
#tag Constant, Name = kItemTypeSeparator, Type = Double, Dynamic = False, Default = "4", Scope = Public
#tag EndConstant
```
Place these after `kItemTypeDropdown` in the constants block (around line 1302–1303).

**Color variables relevant to CheckBox rendering:**
- `cBorder` — used for glyph border rectangle (light/dark mode resolved each paint)
- `cTabAccent` — blue fill when checkbox is checked (light: `RGB(0,120,212)`, dark: `RGB(60,150,230)`)
- `cItemText` — text label color
- `cItemDisabledText` — disabled text color
- `cItemHoverBackground` — hover background for glyph area
- `cItemPressedBackground` — pressed state background

---

## Existing Method Signatures (extracted from source)

### XjRibbonGroup.xojo_code — All AddXxx methods

```xojo
Function AddLargeButton(caption As String, tag As String) As XjRibbonItem
Function AddLargeButton(caption As String, tag As String, icon As Picture) As XjRibbonItem
Function AddSmallButton(caption As String, tag As String) As XjRibbonItem
Function AddDropdownButton(caption As String, tag As String) As XjRibbonItem
Sub AddItem(item As XjRibbonItem)   // low-level: appends pre-built item
```

All `AddXxx` functions follow this exact pattern:
1. `Var item As New XjRibbonItem`
2. Set `item.Caption`, `item.Tag`, `item.ItemType`, any extra flags
3. `mItems.Add(item)`
4. `Return item`

### XjRibbon.xojo_code — Key private methods

```xojo
// Layout: called every Paint, computes mBoundsX/Y/W/H on all items and groups
Private Sub LayoutTabs(g As Graphics)

// Drawing: iterates activeTab.mGroups, dispatches per ItemType
Private Sub DrawGroups(g As Graphics)

// Per-type draw methods
Private Sub DrawLargeButton(g As Graphics, item As XjRibbonItem)
Private Sub DrawSmallButton(g As Graphics, item As XjRibbonItem)
Private Sub DrawDropdownButton(g As Graphics, item As XjRibbonItem)

// Hit-test: returns first XjRibbonItem whose mBounds contains (x,y)
Private Function HitTestItems(x As Double, y As Double) As XjRibbonItem

// Mouse events (Xojo event handlers — not Private)
Function MouseDown(x As Integer, y As Integer) As Boolean
Sub MouseUp(x As Integer, y As Integer)
Sub MouseMove(x As Integer, y As Integer)
```

---

## Layout Algorithm — Small Button Column Stacking

This is the exact loop structure from `LayoutTabs` (lines 349–380) that CheckBox must replicate:

```xojo
Var idx As Integer = 0
While idx <= group.mItems.LastIndex
  Var item As XjRibbonItem = group.mItems(idx)
  If item.ItemType = 1 Then
    // --- SMALL BUTTON COLUMN BATCH ---
    Var batch() As XjRibbonItem
    Var maxTextW As Double = 0
    While idx <= group.mItems.LastIndex And group.mItems(idx).ItemType = 1 And batch.Count < 3
      batch.Add(group.mItems(idx))
      g.FontSize = 11
      Var tw As Double = g.TextWidth(group.mItems(idx).Caption)
      If tw > maxTextW Then maxTextW = tw
      idx = idx + 1
    Wend
    Var colWidth As Double = kSmallButtonIconSize + kSmallButtonTextPadding + maxTextW + kSmallButtonTextPadding * 2
    If colWidth < kSmallButtonMinWidth Then colWidth = kSmallButtonMinWidth
    Var totalRowH As Double = batch.Count * kSmallButtonHeight + (batch.Count - 1) * kSmallRowGap
    Var startY As Double = contentY + (itemAreaH - totalRowH) / 2
    For row As Integer = 0 To batch.LastIndex
      batch(row).mBoundsX = itemX
      batch(row).mBoundsY = startY + row * (kSmallButtonHeight + kSmallRowGap)
      batch(row).mBoundsW = colWidth
      batch(row).mBoundsH = kSmallButtonHeight
    Next
    itemX = itemX + colWidth + kItemGap
  Else
    // --- LARGE / DROPDOWN BUTTON (single item, full height) ---
    item.mBoundsX = itemX
    item.mBoundsY = contentY
    item.mBoundsW = kLargeButtonWidth
    item.mBoundsH = itemAreaH
    itemX = itemX + kLargeButtonWidth + kItemGap
    idx = idx + 1
  End If
Wend
```

**Key insight for Phase 5:** The outer `While` loop uses a manual `idx` counter because the
Small-button batch consumes multiple items per iteration. The `Else` branch (large/dropdown)
increments `idx` manually after placing one item. The CheckBox must join the Small-button
batch condition (`ItemType = 1 OR ItemType = 3`). The Separator does NOT enter either batch
— it gets its own branch that bumps `itemX` and then manually increments `idx`.

**CheckBox column width formula** — CheckBox has no icon slot, so the colWidth formula
differs from Small button:
```
colWidth = 13 + kSmallButtonTextPadding + maxTextW + kSmallButtonTextPadding * 2
//         glyph  gap                    text         right pad
```
The inner batch `While` condition must accept both ItemType=1 and ItemType=3, OR the two
types must be kept in separate branch blocks. The cleanest approach given DEV_PLAN spec is
a separate `ElseIf item.ItemType = 3 Then` block with its own batch loop, because the
colWidth formula differs (13px glyph instead of kSmallButtonIconSize=16px).

---

## DrawDropdownButton — Exact Code (source of SplitButton changes)

```xojo
Private Sub DrawDropdownButton(g As Graphics, item As XjRibbonItem)
  DrawLargeButton(g, item)                          // draws background, icon, text
  Var arrowW As Double = kDropdownArrowSize         // = 6
  Var arrowX As Double = item.mBoundsX + (item.mBoundsW - arrowW) / 2
  Var arrowY As Double = item.mBoundsY + item.mBoundsH - 6
  If item.IsEnabled Then
    g.DrawingColor = cItemText
  Else
    g.DrawingColor = cItemDisabledText
  End If
  Var midX As Double = arrowX + arrowW / 2
  g.PenSize = 1.5
  g.DrawLine(arrowX, arrowY, midX, arrowY + arrowW / 2)
  g.DrawLine(midX, arrowY + arrowW / 2, arrowX + arrowW, arrowY)
  g.PenSize = 1
End Sub
```

**Current behavior:** The entire button width is one hit area; all clicks open the popup menu.
The chevron is drawn centered in the full button width.

**SplitButton changes required in this method:**

When `item.IsSplitButton = True`:
1. Compute `arrowAreaW = item.mBoundsW * 0.20` (the 20% arrow zone)
2. Draw the vertical separator line at `item.mBoundsX + item.mBoundsW * 0.80`
3. Draw the chevron centered in the arrow area only (not full button width)

Separator line draw pattern (follow existing `cGroupSeparator` / `cBorder` style):
```xojo
Var sepX As Double = item.mBoundsX + item.mBoundsW * 0.80
g.DrawingColor = cBorder
g.FillRectangle(sepX, item.mBoundsY + 4, 1, item.mBoundsH - 8)
```

When `IsSplitButton = False` (default): existing code runs unchanged (backward compatible).

---

## HitTestItems — Exact Code and SplitButton Extension

Current code (lines 716–727):

```xojo
Private Function HitTestItems(x As Double, y As Double) As XjRibbonItem
  If mIsCollapsed Then Return Nil
  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return Nil
  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
  For Each group As XjRibbonGroup In activeTab.mGroups
    For Each item As XjRibbonItem In group.mItems
      If x >= item.mBoundsX And x < item.mBoundsX + item.mBoundsW And y >= item.mBoundsY And y < item.mBoundsY + item.mBoundsH Then Return item
    Next
  Next
  Return Nil
End Function
```

**Problem:** `HitTestItems` returns an `XjRibbonItem` — it has no way to signal "hit the
arrow zone vs body zone" of a SplitButton. Two approaches exist:

**Approach A (recommended — matches DEV_PLAN spec):** Set `mPressedOnArrow As Boolean`
as a private property on `XjRibbon` in `MouseDown` — immediately after `HitTestItems`
confirms an item. In `HitTestItems` itself, only check whether (x,y) is within bounds
(unchanged). In `MouseDown`, after getting `hitItem`, check `hitItem.IsSplitButton` and
compute whether x falls in the 20% arrow zone — set `mPressedOnArrow` accordingly.

`MouseDown` already does:
```xojo
Var hitItem As XjRibbonItem = HitTestItems(x, y)
If hitItem <> Nil And hitItem.IsEnabled Then
  mPressedItem = hitItem
  hitItem.mIsPressed = True
  Me.Refresh
  Return True
End If
```

Insert after `mPressedItem = hitItem`:
```xojo
If hitItem.ItemType = 2 And hitItem.IsSplitButton Then
  mPressedOnArrow = x >= hitItem.mBoundsX + hitItem.mBoundsW * 0.80
Else
  mPressedOnArrow = False
End If
```

**Approach B (alternative):** Return a special sentinel item or add an `mLastHitWasArrow`
flag on XjRibbonItem. Avoid — more invasive, flag on item would be mutable shared state.

---

## MouseUp Dispatch — Full Current Code and Phase 5 Changes

Current `MouseUp` (lines 69–92):

```xojo
Sub MouseUp(x As Integer, y As Integer)
  If mPressedItem <> Nil Then
    Var pressed As XjRibbonItem = mPressedItem
    mPressedItem = Nil
    Var hitItem As XjRibbonItem = HitTestItems(x, y)
    If hitItem Is pressed And pressed.IsEnabled Then
      If pressed.ItemType = 2 And pressed.mMenuItems.Count > 0 Then
        // --- DROPDOWN PATH ---
        Var baseMenu As New DesktopMenuItem
        For Each mi As DesktopMenuItem In pressed.mMenuItems
          Var menuItem As New DesktopMenuItem(mi.Text)
          menuItem.Tag = mi.Tag
          baseMenu.AddMenu(menuItem)
        Next
        Var selected As DesktopMenuItem = baseMenu.PopUp
        If selected <> Nil Then RaiseEvent DropdownMenuAction(pressed.Tag, selected.Tag.StringValue)
      Else
        // --- TOGGLE / NORMAL PATH ---
        If pressed.IsToggle Then pressed.IsToggleActive = Not pressed.IsToggleActive
        RaiseEvent ItemPressed(pressed.Tag)
      End If
    End If
    pressed.mIsPressed = False
    Me.Refresh
  End If
End Sub
```

**IsToggle dispatch pattern** (the pattern to replicate for CheckBox):
```xojo
If pressed.IsToggle Then pressed.IsToggleActive = Not pressed.IsToggleActive
RaiseEvent ItemPressed(pressed.Tag)
```

**Phase 5 changes to MouseUp:**

The `ItemType = 2` condition must be split into SplitButton body hit vs arrow hit vs
plain dropdown:

```xojo
If pressed.ItemType = 2 And pressed.mMenuItems.Count > 0 Then
  If pressed.IsSplitButton And Not mPressedOnArrow Then
    // SplitButton body click — treat like normal button
    RaiseEvent ItemPressed(pressed.Tag)
  Else
    // Arrow click (or plain dropdown) — open menu
    Var baseMenu As New DesktopMenuItem
    For Each mi As DesktopMenuItem In pressed.mMenuItems
      Var menuItem As New DesktopMenuItem(mi.Text)
      menuItem.Tag = mi.Tag
      baseMenu.AddMenu(menuItem)
    Next
    Var selected As DesktopMenuItem = baseMenu.PopUp
    If selected <> Nil Then RaiseEvent DropdownMenuAction(pressed.Tag, selected.Tag.StringValue)
  End If
Else
  If pressed.IsToggle Then pressed.IsToggleActive = Not pressed.IsToggleActive
  RaiseEvent ItemPressed(pressed.Tag)
End If
```

**CheckBox (ItemType=3) dispatch:** CheckBox items have `IsToggle = True` set automatically
by `AddCheckBox`. Therefore they are handled by the existing `Else` branch automatically —
`pressed.IsToggle` is True, so `IsToggleActive` flips and `ItemPressed` fires. No additional
branch needed for CheckBox in `MouseUp`. This is the correct behavior per REQ-510.

---

## DrawGroups — Dispatch Table and CheckBox Insertion Point

Current `Select Case` in `DrawGroups` (lines 456–463):

```xojo
For Each item As XjRibbonItem In group.mItems
  Select Case item.ItemType
  Case 1
    DrawSmallButton(g, item)
  Case 2
    DrawDropdownButton(g, item)
  Else
    DrawLargeButton(g, item)
  End Select
Next
```

**Phase 5 insertion:** Add `Case 3` before `Else`. Case 4 (Separator) has no draw — the
`Else` would try to call `DrawLargeButton` for it, which would render incorrectly. Separator
must be explicitly skipped:

```xojo
Select Case item.ItemType
Case 1
  DrawSmallButton(g, item)
Case 2
  DrawDropdownButton(g, item)
Case 3
  DrawCheckBoxItem(g, item)
Case 4
  // Separator — no rendering
Else
  DrawLargeButton(g, item)
End Select
```

---

## DrawCheckBoxItem — Implementation Specification

New private method to add after `DrawDropdownButton` (around line 604):

```xojo
Private Sub DrawCheckBoxItem(g As Graphics, item As XjRibbonItem)
  Var bx As Double = item.mBoundsX
  Var by As Double = item.mBoundsY
  Var bw As Double = item.mBoundsW
  Var bh As Double = item.mBoundsH   // = kSmallButtonHeight = 22
  
  // Hover / pressed background for the whole row
  If item.mIsPressed Then
    g.DrawingColor = cItemPressedBackground
    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
  ElseIf item.mIsHovered Then
    g.DrawingColor = cItemHoverBackground
    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
  End If
  
  // Glyph: 13x13 rounded rect, vertically centered
  Var glyphSize As Double = 13
  Var glyphX As Double = bx + 2
  Var glyphY As Double = by + (bh - glyphSize) / 2
  
  If item.IsToggleActive Then
    // Checked: blue fill
    g.DrawingColor = cTabAccent
    g.FillRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2, 2)
    // White checkmark (two line segments)
    g.DrawingColor = Color.RGB(255, 255, 255)
    g.PenSize = 1.5
    g.DrawLine(glyphX + 2, glyphY + 6, glyphX + 5, glyphY + 9)
    g.DrawLine(glyphX + 5, glyphY + 9, glyphX + 11, glyphY + 3)
    g.PenSize = 1
  Else
    // Unchecked: white interior, cBorder border
    g.DrawingColor = cContentBackground
    g.FillRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2, 2)
    g.DrawingColor = cBorder
    g.DrawRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2, 2)
  End If
  
  // Text label
  If item.IsEnabled Then
    g.DrawingColor = cItemText
  Else
    g.DrawingColor = cItemDisabledText
  End If
  g.FontSize = 11
  g.Bold = False
  Var textX As Double = glyphX + glyphSize + kSmallButtonTextPadding
  g.DrawText(item.Caption, textX, by + (bh + g.TextHeight) / 2 - 1)
End Sub
```

Note: `FillRoundRectangle` and `DrawRoundRectangle` in desktop Xojo take two corner radius
parameters (unlike web which takes one). All existing calls in the codebase use `(bx, by, bw, bh, r, r)`.

---

## LayoutGroupItems Changes — Separator and CheckBox

The full `LayoutTabs` method (lines 328–391) contains the item placement loop. The current
outer `While` branch structure is:

```
If item.ItemType = 1 Then
  [batch of up to 3 small buttons → column]
Else
  [single large/dropdown item → full height]
```

**Phase 5 additions — after the `ItemType = 1` branch:**

```xojo
ElseIf item.ItemType = 3 Then
  // CheckBox column batch (same 3-per-column, different colWidth)
  Var cbBatch() As XjRibbonItem
  Var cbMaxTextW As Double = 0
  While idx <= group.mItems.LastIndex And group.mItems(idx).ItemType = 3 And cbBatch.Count < 3
    cbBatch.Add(group.mItems(idx))
    g.FontSize = 11
    Var cbTw As Double = g.TextWidth(group.mItems(idx).Caption)
    If cbTw > cbMaxTextW Then cbMaxTextW = cbTw
    idx = idx + 1
  Wend
  Var cbGlyph As Double = 13
  Var cbColWidth As Double = cbGlyph + kSmallButtonTextPadding + cbMaxTextW + kSmallButtonTextPadding * 2
  If cbColWidth < kSmallButtonMinWidth Then cbColWidth = kSmallButtonMinWidth
  Var cbTotalH As Double = cbBatch.Count * kSmallButtonHeight + (cbBatch.Count - 1) * kSmallRowGap
  Var cbStartY As Double = contentY + (itemAreaH - cbTotalH) / 2
  For row As Integer = 0 To cbBatch.LastIndex
    cbBatch(row).mBoundsX = itemX
    cbBatch(row).mBoundsY = cbStartY + row * (kSmallButtonHeight + kSmallRowGap)
    cbBatch(row).mBoundsW = cbColWidth
    cbBatch(row).mBoundsH = kSmallButtonHeight
  Next
  itemX = itemX + cbColWidth + kItemGap

ElseIf item.ItemType = 4 Then
  // Separator: zero-width column bump, no bounds needed, no draw
  item.mBoundsW = 0
  item.mBoundsH = 0
  idx = idx + 1

Else
  // Large / Dropdown button (existing code)
  item.mBoundsX = itemX
  item.mBoundsY = contentY
  item.mBoundsW = kLargeButtonWidth
  item.mBoundsH = itemAreaH
  itemX = itemX + kLargeButtonWidth + kItemGap
  idx = idx + 1
End If
```

**Separator note:** The Separator branch must manually increment `idx` and must NOT advance
`itemX` (or advance it by a small visual gap if desired — DEV_PLAN says "bump column
boundary" which in context means start a fresh column, so itemX stays where it is and the
next batch starts fresh). Since the CheckBox batch loop stops at a non-CheckBox item anyway,
the Separator naturally terminates the preceding CheckBox batch. The effective visual result
is a column gap between CheckBox columns and whatever follows.

---

## XjRibbonItem Properties — Insertion Point for IsSplitButton

Current properties in `XjRibbonItem.xojo_code` (lines 11–75):

```
Caption As String
Tag As String
IsEnabled As Boolean = True
ItemType As Integer = 0
Icon As Picture
TooltipText As String
IsToggle As Boolean = False
IsToggleActive As Boolean = False
KeyTip As String
mMenuItems() As DesktopMenuItem
mBoundsX, mBoundsY, mBoundsW, mBoundsH As Double
mIsHovered As Boolean
mIsPressed As Boolean
```

**Insertion:** Add `IsSplitButton As Boolean = False` after `IsToggleActive` and before
`KeyTip` (keeping toggle-related properties grouped together).

Xojo property block syntax to add:
```
#tag Property, Flags = &h0
  IsSplitButton As Boolean = False
#tag EndProperty
```

---

## XjRibbonGroup — Insertion Points for Three New Methods

Current methods in `XjRibbonGroup.xojo_code`:
- `Sub AddItem(item)` — line 4
- `Function AddLargeButton(caption, tag)` — line 10
- `Function AddLargeButton(caption, tag, icon)` — line 22
- `Function AddSmallButton(caption, tag)` — line 34
- `Function AddDropdownButton(caption, tag)` — line 44

**Add three new method blocks after `AddDropdownButton` (before the `#tag Property` block):**

```xojo
#tag Method, Flags = &h0
  Function AddSplitButton(caption As String, tag As String) As XjRibbonItem
    Var item As New XjRibbonItem
    item.Caption = caption
    item.Tag = tag
    item.ItemType = 2
    item.IsSplitButton = True
    mItems.Add(item)
    Return item
  End Function
#tag EndMethod

#tag Method, Flags = &h0
  Function AddCheckBox(caption As String, tag As String, initialState As Boolean = False) As XjRibbonItem
    Var item As New XjRibbonItem
    item.Caption = caption
    item.Tag = tag
    item.ItemType = 3
    item.IsToggle = True
    item.IsToggleActive = initialState
    mItems.Add(item)
    Return item
  End Function
#tag EndMethod

#tag Method, Flags = &h0
  Sub AddSeparator()
    Var item As New XjRibbonItem
    item.ItemType = 4
    mItems.Add(item)
  End Sub
#tag EndMethod
```

---

## XjRibbon — New Private Property for mPressedOnArrow

Add after `mExpandedHeight As Double = 0` (around line 1168):

```
#tag Property, Flags = &h21
  Private mPressedOnArrow As Boolean = False
#tag EndProperty
```

---

## KeyTip Navigation — Phase 5 Interaction

The existing `DrawKeyTips` method (lines 628–651) dispatches KeyTip badge position based
on `item.ItemType`:

```xojo
If item.ItemType = 1 Then
  DrawKeyTipBadge(g, item.KeyTip, item.mBoundsX + item.mBoundsW - 8, item.mBoundsY + item.mBoundsH / 2)
Else
  DrawKeyTipBadge(g, item.KeyTip, item.mBoundsX + item.mBoundsW / 2, item.mBoundsY + item.mBoundsH - 2)
End If
```

CheckBox (ItemType=3) will fall into the `Else` branch and render the badge at the bottom
center, which is acceptable for Phase 5. Separator (ItemType=4) has no KeyTip (Caption = "",
so `item.KeyTip` will be "" after `AssignKeyTips` — the `If item.KeyTip = "" … Continue`
guard will skip it). No changes needed in `DrawKeyTips`.

The `MoveFocusItemVertical` method (lines 1001–1017) restricts vertical arrow navigation to
`ItemType = 1` items in the same column:
```xojo
If currentItem.ItemType <> 1 Then Return False
If group.mItems(newIdx).ItemType <> 1 Then Return False
```
This means CheckBox items (ItemType=3) will not participate in vertical keyboard navigation.
This is acceptable for Phase 5 (keyboard nav is a Phase 4 feature; CheckBox is a new type
and the planner should note this limitation).

---

## Demo Window — Current Structure and Insertion Points

Current `MainWindow.Opening` event builds this structure:

```
XjRibbon1
├── Tab "Home" (KeyTip="H")
│   ├── Group "Clipboard"  → Large "Paste", Small "Cut", Small "Copy"
│   ├── Group "Font"       → Small "Bold"(toggle), Small "Italic"(toggle), Small "Underline"(toggle)
│   └── Group "Paragraph"  → Small "Left", Small "Center", Small "Right"
├── Tab "Insert" (KeyTip="N")
│   ├── Group "Tables"     → Large "Table"
│   └── Group "Illustrations" → Large "Picture", Dropdown "Shapes"(3 items), Large "Chart"
├── Tab "View" (KeyTip="W")
│   ├── Group "Zoom"       → Large "Zoom In", Large "Zoom Out", Large "100%"
│   └── Group "Show"       → Small "Ruler"(toggle), Small "Grid"(toggle), Small "Guides"(toggle)
├── ContextualTab "Design" (contextGroup="Table Tools", accent=green)
│   └── Group "Table Styles" → Large "Style 1", Large "Style 2", Large "Style 3"
└── ContextualTab "Format" (contextGroup="Picture Tools", accent=orange)
    └── Group "Adjust"     → Large "Brightness", Large "Contrast", Large "Crop"
```

**Phase 5 addition (append at end of Opening event, after the "Adjust" group):**

```xojo
// Add "Show/hide" group to View tab (viewTab already declared above)
Var showHide As XjRibbonGroup = viewTab.AddNewGroup("Show/hide")
Var cb1 As XjRibbonItem = showHide.AddCheckBox("Item check boxes", "view.checkboxes")
#Pragma Unused cb1
Var cb2 As XjRibbonItem = showHide.AddCheckBox("File name extensions", "view.extensions")
#Pragma Unused cb2
Var cb3 As XjRibbonItem = showHide.AddCheckBox("Hidden items", "view.hidden", True)
#Pragma Unused cb3
showHide.AddSeparator()
Call showHide.AddSmallButton("Hide selected", "view.hide_selected")

// Add "Panes" group to View tab
Var navGroup As XjRibbonGroup = viewTab.AddNewGroup("Panes")
Var navPane As XjRibbonItem = navGroup.AddSplitButton("Navigation pane", "view.nav_pane")
navPane.AddMenuItem("Navigation pane", "view.nav_pane.toggle")
navPane.AddMenuItem("Expand to open folder", "view.nav_pane.expand")
navPane.AddMenuItem("Show all folders", "view.nav_pane.allfolders")
```

**Important:** `viewTab` is a local variable declared in `Opening` (line 169:
`Var viewTab As XjRibbonTab = XjRibbon1.AddTab("View")`). The new groups must be appended
in the same `Opening` event handler, after the existing `viewTab` code. The variable is
in scope throughout the entire `Opening` event.

**ItemPressed handler update:** The current `ItemPressed` handler checks
`tag.BeginsWith("font.")` or `tag.BeginsWith("view.ruler")` etc. for toggle feedback.
The handler should be extended to cover CheckBox and SplitButton body tags:
```xojo
If tag.BeginsWith("view.") Then
  // catch all view.* toggles and actions
  If XjRibbon1.GetToggleState(tag) Then
    MessageBox(tag + " checked: ON")
  Else
    MessageBox("Ribbon item pressed: " + tag)
  End If
```
Or keep simple: `MessageBox("Ribbon item pressed: " + tag)` is already the fallthrough
that works for all non-toggle tags.

---

## Xojo-Specific Gotchas (from MEMORY.md and codebase patterns)

1. **Use `Me.Refresh`, not `Me.Invalidate`** — existing code uses `Me.Refresh` throughout.
   All new code must follow this convention.

2. **`Call` for unused return values** — `AddSeparator` returns nothing (it's a `Sub`),
   so no `Call` needed. For `AddCheckBox` calls where the return value is not used,
   prefix with `Call`: `Call showHide.AddCheckBox(...)`. In the demo the DEV_PLAN uses
   `Var cb1 As XjRibbonItem = ...` to capture results — both styles are valid, but for
   items where state is not later manipulated, `Call` is cleaner.

3. **Quit Xojo IDE before editing/committing files** — `.xojo_code` and `.xojo_window`
   files are binary-adjacent XML; editing while Xojo is open causes merge conflicts on
   re-open.

4. **`FillRoundRectangle` takes two corner radii on desktop** — signature is
   `(x, y, w, h, xRadius, yRadius)`. Web version takes one. All existing desktop calls
   use `(bx, by, bw, bh, r, r)` — match this pattern.

5. **`DrawRoundRectangle` for borders** — uses same two-radius signature. Existing pattern
   for toggle active border: `g.DrawRoundRectangle(bx + 0.5, by + 0.5, bw - 1, bh - 1, r, r)`
   (offset by 0.5 to align on pixel boundary). Use same pattern for CheckBox glyph border.

6. **`g.PenSize` must be reset after use** — all chevron/checkmark drawing sets PenSize
   temporarily and resets to 1.0 afterward. Follow this pattern in `DrawCheckBoxItem`.

7. **Constants are class-level, not file-level** — all `#tag Constant` blocks are inside
   the `XjRibbon` class. New constants go in the constants block inside `Class XjRibbon`.

8. **`Select Case item.ItemType`** — Xojo's `Select Case` uses `Else` (not `Default`) as
   the fallthrough. The Separator `Case 4` must be explicit to prevent the `Else` branch
   from calling `DrawLargeButton` on a zero-height item.

---

## Validation Architecture

The project has no automated test framework (no `pytest.ini`, `jest.config.*`, or test
directories found). Testing is manual: run the desktop demo app and exercise each control.

**Manual verification checklist per requirement:**

| REQ | Manual Test |
|-----|-------------|
| REQ-501 | Compile without error; `navPane.IsSplitButton` accessible |
| REQ-502 | Click left 80% of SplitButton body — no menu appears |
| REQ-502 | Click right 20% arrow area — menu appears |
| REQ-503 | Body click fires `ItemPressed("view.nav_pane")` |
| REQ-504 | Arrow click → select menu item → fires `DropdownMenuAction` |
| REQ-505 | Vertical separator line visible at 80% of button width |
| REQ-506 | Compile with `kItemTypeCheckBox = 3` referenced |
| REQ-507 | Unchecked: empty rounded rect border. Checked: blue fill + white checkmark |
| REQ-508 | No icon column in CheckBox rows; glyph immediately at left |
| REQ-509 | 4 checkboxes stack into two columns of 2 (not one column of 4) |
| REQ-510 | Click CheckBox → state flips → `ItemPressed` fires |
| REQ-511 | Compile with `kItemTypeSeparator = 4` referenced |
| REQ-512 | Separator creates visible gap between CheckBox column and "Hide selected" button |
| REQ-513 | `navGroup.AddSplitButton(...)` returns XjRibbonItem, menu items attach |
| REQ-514 | `showHide.AddCheckBox("Hidden items", ..., True)` starts checked |
| REQ-515 | `showHide.AddSeparator()` does not crash, creates visual gap |
| REQ-516 | Demo shows "Show/hide" group with 3 checkboxes + separator + small button; "Panes" group with SplitButton |

---

## Open Questions

1. **Separator visual gap width** — DEV_PLAN says "bump column boundary (groupX)" but the
   layout loop uses `itemX` not `groupX`. Separator should advance `itemX` by a small gap
   amount (e.g., `kItemGap = 4`) to produce a visible visual break, or leave `itemX`
   unchanged to produce zero gap (the next item's column just starts). The DEV_PLAN intent
   appears to be a non-zero visual gap. Recommendation: advance `itemX` by `kItemGap` (4px)
   in the Separator branch to create a subtle visual break without requiring a new constant.

2. **CheckBox + Small mixing** — DEV_PLAN shows `showHide.AddSeparator()` followed by
   `showHide.AddSmallButton(...)`. The separator terminates the CheckBox batch and the
   Small button starts a new column. The layout loop handles this correctly if Separator
   and CheckBox each have their own `ElseIf` branches (each batch loop only consumes
   matching types). Verify in demo that the "Hide selected" small button renders in its
   own column after the separator gap.

3. **SplitButton body draw** — `DrawDropdownButton` calls `DrawLargeButton(g, item)` first
   (which draws background, icon centered in full width, and text centered in full width).
   For a SplitButton, the icon and text should logically appear in the body (80%) zone, not
   centered across the whole button. Since `kLargeButtonWidth = 56` and 80% = ~45px, and
   the icon is 32px, centering in full width vs body zone differs by only a few pixels.
   For Phase 5, centering remains in the full width (no change to `DrawLargeButton`) — the
   visual difference is minor. The separator line drawn on top makes the split clear.

---

## Sources

### Primary (HIGH confidence)
All findings extracted directly from the four source files in this session:
- `desktop/XjRibbonItem.xojo_code` — full file read (76 lines)
- `desktop/XjRibbonGroup.xojo_code` — full file read (79 lines)
- `desktop/XjRibbon.xojo_code` — full file read (1492 lines)
- `desktop/MainWindow.xojo_window` — full file read (501 lines)
- `DEV_PLAN.md` — design decisions and code patterns specified
- `.planning/REQUIREMENTS.md` — REQ-501 through REQ-516 confirmed

### No external sources consulted
Phase 5 is entirely an internal code change with no new dependencies. All patterns are
established by the existing codebase.

---

## Metadata

**Confidence breakdown:**
- Standard Stack: HIGH — no new dependencies; all patterns extracted from source
- Architecture: HIGH — all method signatures, loop structures, and dispatch tables read directly
- Pitfalls: HIGH — Xojo gotchas confirmed from MEMORY.md and codebase patterns

**Research date:** 2026-04-20
**Valid until:** N/A — this is codebase research, not external library research; valid
until the source files change.

---

## RESEARCH COMPLETE
