# Phase 7: Web Phase 5 — Control Set Parity Research

**Researched:** 2026-04-20
**Domain:** Xojo WebCanvas rendering, hit-testing, JS hash-based event routing
**Confidence:** HIGH — all findings extracted directly from source files in this session

---

## Summary

Phase 7 ports the desktop Phase 5 control types (CheckBox, SplitButton mode, Separator) to the
web ribbon library. This is a port, not a greenfield feature. The reference implementation in
`desktop/XjRibbon.xojo_code` is complete (desktop Phase 5 is done). The task is to apply
equivalent changes to the three web files, adapting for web-specific API differences.

The web library is structurally identical to the desktop library — same class names, same method
naming convention, same rendering dispatch pattern. The divergence points are: (1) `WebGraphics`
vs `Graphics` API differences, (2) 120%-scaled constants, (3) the `Pressed` event replacing
`MouseDown`/`MouseUp`, and (4) the JS hash mechanism replacing native `MouseMove`.

**Primary recommendation:** Implement all changes in a single pass per file in this sequence:
`XjRibbonItem` (1 property), `XjRibbonGroup` (3 methods), `XjRibbon` (constants + layout +
draw + hit-test dispatch + Pressed handler). No new JS injection needed. No new session hash
prefixes needed. Demo additions go in `MainWebPage.xojo_code`.

---

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| IsSplitButton property storage | XjRibbonItem | — | All item state lives on XjRibbonItem |
| SplitButton body/arrow hit-split | XjRibbon (Pressed event) | — | Pressed event handles all item clicks |
| SplitButton separator line draw | XjRibbon.DrawDropdownButton | — | Rendering owned by XjRibbon |
| CheckBox glyph draw | XjRibbon.DrawCheckBoxItem (new) | — | Dispatched from DrawGroups like other types |
| CheckBox layout stacking | XjRibbon.LayoutTabs (inner loop) | — | Same loop that handles Small columns |
| Separator column bump | XjRibbon.LayoutTabs (inner loop) | — | Only needs itemX advance; no draw |
| New convenience methods | XjRibbonGroup | — | All AddXxx factory methods live here |
| Demo setup | MainWebPage.Shown event | — | All current demo code is in this event |
| Hover state | JS `xjmm:` hash + HandleMouseMove | — | No new mechanism needed |

---

## Complete Diff: What Web/ Has vs What Desktop Phase 5 Added

### XjRibbonItem.xojo_code

| Property | Desktop (after Phase 5) | Web (current) | Action |
|----------|------------------------|---------------|--------|
| `IsSplitButton As Boolean = False` | EXISTS (line 44) | MISSING | ADD |
| `KeyTip As String` | EXISTS (line 48) | MISSING | Not needed (Phase 4 skipped) |
| `mMenuItems() As DesktopMenuItem` | DesktopMenuItem | `mMenuItems() As WebMenuItem` | Already correct in web |

**Net for web XjRibbonItem:** Add `IsSplitButton As Boolean = False` after `IsToggleActive`.

### XjRibbonGroup.xojo_code

| Method | Desktop (after Phase 5) | Web (current) | Action |
|--------|------------------------|---------------|--------|
| `AddSplitButton(caption, tag)` | EXISTS (line 55) | MISSING | ADD |
| `AddCheckBox(caption, tag, initialState)` | EXISTS (line 67) | MISSING | ADD |
| `AddSeparator()` | EXISTS (line 80) | MISSING | ADD |

**Net for web XjRibbonGroup:** Add all three methods after `AddDropdownButton`.

### XjRibbon.xojo_code — Constants Block

| Constant | Desktop Value | Web Value | Status |
|----------|---------------|-----------|--------|
| `kItemTypeCheckBox` | 3 (Public) | MISSING | ADD |
| `kItemTypeSeparator` | 4 (Public) | MISSING | ADD |
| `kArrowZoneWidth` | 20 (Private) | MISSING | ADD (scaled: 24) |

**All other constants already exist in web but with 120% scaling applied.**

### XjRibbon.xojo_code — Constants Scaling Reference

The web already has all pre-existing constants with 120% scaling. Confirmed from source:

| Constant | Desktop | Web (actual) | Scale Factor |
|----------|---------|--------------|-------------|
| `kTabStripHeight` | 24 | 29 | ~1.2x |
| `kContentTop` | 26 | 31 | ~1.2x |
| `kLargeButtonWidth` | 56 | 67 | ~1.2x |
| `kLargeButtonIconSize` | 32 | 38 | ~1.2x |
| `kSmallButtonHeight` | 22 | 26 | ~1.2x |
| `kSmallButtonIconSize` | 16 | 19 | ~1.2x |
| `kSmallButtonMinWidth` | 60 | 72 | ~1.2x |
| `kSmallButtonTextPadding` | 4 | 5 | ~1.2x |
| `kDropdownArrowSize` | 6 | 7 | ~1.2x |
| `kGroupPaddingH` | 8 | 10 | ~1.2x |
| `kGroupGap` | 8 | 10 | ~1.2x |
| `kGroupLabelHeight` | 16 | 19 | ~1.2x |
| `kItemGap` | 4 | 5 | ~1.2x |
| `kCollapseChevronSize` | 12 | 14 | ~1.2x |

**New constant `kArrowZoneWidth`:** Desktop = 20; web should = 24 (20 * 1.2).

**New CheckBox glyph size:** Desktop uses hardcoded `13` in DrawCheckBoxItem and LayoutTabs.
Web should use `16` (13 * 1.2, rounded up). However, the desktop research recommended
a separate constant; given web uses inline values in some places, the safest approach is
to define a local variable `Var glyphSize As Double = 16` inside both the draw method and
the layout batch loop for visual consistency.

### XjRibbon.xojo_code — LayoutTabs Method

| Branch | Desktop | Web (current) | Action |
|--------|---------|---------------|--------|
| `If item.ItemType = 1` (small batch) | EXISTS | EXISTS (line 300) | No change |
| `ElseIf item.ItemType = 3` (CheckBox batch) | EXISTS | MISSING | ADD |
| `ElseIf item.ItemType = 4` (Separator) | EXISTS | MISSING | ADD |
| `Else` (large/dropdown) | EXISTS | EXISTS (line 325) | Needs SplitButton auto-expand addition |

**Web LayoutTabs Else branch (current):** Sets `item.mBoundsW = kLargeButtonWidth` as a
fixed value (line 329). Desktop Phase 5 added auto-expand logic and SplitButton width
adjustment. The web Else branch also needs this update.

**Critical difference in web LayoutTabs:** Web uses `MeasureTextWidth(text, fontSize, bold)`
(a private helper that creates a `Picture.Graphics`) instead of `g.TextWidth(text)`. The
CheckBox batch loop and the large button auto-expand must use `MeasureTextWidth`.

**Desktop `Else` branch after Phase 5 (reference):**
```
item.mBoundsW = Max(kLargeButtonWidth, maxCapW + 16)
If item.IsSplitButton Then btnW = btnW + kArrowZoneWidth
```
Web equivalent will use `MeasureTextWidth` for `maxCapW`.

### XjRibbon.xojo_code — DrawGroups Dispatch

| Case | Desktop | Web (current) | Action |
|------|---------|---------------|--------|
| `Case 1` → DrawSmallButton | EXISTS | EXISTS (line 469) | No change |
| `Case 2` → DrawDropdownButton | EXISTS | EXISTS (line 471) | No change |
| `Case 3` → DrawCheckBoxItem | EXISTS | MISSING | ADD |
| `Case 4` → (no render) | EXISTS | MISSING | ADD |
| `Else` → DrawLargeButton | EXISTS | EXISTS (line 473) | No change |

**Risk:** Without `Case 4`, the `Else` branch would call `DrawLargeButton` on a Separator item
which has `mBoundsW = 0` and `mBoundsH = 0`. This would render garbage at (0,0). `Case 4`
with a comment is mandatory.

### XjRibbon.xojo_code — DrawDropdownButton Method

Current web `DrawDropdownButton` (lines 609–630) is identical to the old desktop version:
draws the chevron centered in the full button width with no SplitButton branch. Phase 5 must
add the SplitButton branch exactly as desktop did.

**Desktop Phase 5 DrawDropdownButton structure:**
```
If item.IsSplitButton Then
  sepX = item.mBoundsX + item.mBoundsW - kArrowZoneWidth
  [draw separator line]
  [draw chevron centered in kArrowZoneWidth zone]
Else
  [existing: chevron centered in full width]
End If
```

**Web adaptation:** Identical logic; replace `kArrowZoneWidth` with the web value (24).

### XjRibbon.xojo_code — DrawLargeButton Method

Current web `DrawLargeButton` (lines 495–552) does not know about `IsSplitButton`. In the
desktop Phase 5 version, `DrawLargeButton` was updated to:
- Compute `drawBodyW = If(item.IsSplitButton, bw - kArrowZoneWidth, bw)` for centering text
- Handle multi-line caption (Split on `Chr(10)`)
- Right-align text in body zone for SplitButton vs center for regular

This change is needed in web too for correct visual appearance. However, the current web
`DrawLargeButton` text centering (line 549: `Var textX As Double = bx + (bw - textW) / 2`)
is simpler — no multi-line support yet. The Phase 7 plan can implement SplitButton body-text
alignment without necessarily adding multi-line support (which is a separate concern).

**Minimum web DrawLargeButton change:** Add `drawBodyW` calculation and use it for `textX`:
```
Var drawBodyW As Double = If(item.IsSplitButton, bw - kArrowZoneWidth, bw)
Var textX As Double = bx + (drawBodyW - textW) / 2
```
This prevents the text from appearing under the arrow zone.

### XjRibbon.xojo_code — Pressed Event (Hit-Test and Dispatch)

**Critical difference:** Desktop uses `MouseDown` + `MouseUp` (two events). Web uses a single
`Pressed` event (WebCanvas fires `Pressed(x, y)` on click completion).

**Current web Pressed event structure (lines 28–81):**
```
1. Hit-test collapse chevron → SetCollapsed
2. Hit-test tabs → tab switch or double-click collapse
3. HitTestItems → if ItemType=2 and has menu → ShowDropdownMenu
                  else if IsToggle → flip IsToggleActive → RaiseEvent ItemPressed
                       → RaiseEvent ItemPressed
```

**Phase 5 change to Pressed:** Add `mPressedOnArrow` determination and SplitButton dispatch.

**Current problematic code (line 70–78):**
```xojo
If hitItem.ItemType = 2 And hitItem.mMenuItems.Count > 0 Then
  mDropdownPendingItem = hitItem
  ShowDropdownMenu(hitItem, x, y)
```

This must become:
```xojo
If hitItem.ItemType = 2 And hitItem.mMenuItems.Count > 0 Then
  If hitItem.IsSplitButton And (x < hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth) Then
    // SplitButton body click — no menu
    If hitItem.IsToggle Then hitItem.IsToggleActive = Not hitItem.IsToggleActive
    RaiseEvent ItemPressed(hitItem.Tag)
    Me.Refresh
  Else
    // Arrow click or plain dropdown — show menu
    mDropdownPendingItem = hitItem
    ShowDropdownMenu(hitItem, x, y)
  End If
```

**No `mPressedOnArrow` property needed in web:** Because the web `Pressed` event fires on
click release (not press+release like desktop MouseDown/MouseUp), the x coordinate is
available at dispatch time — no stored intermediate state needed. The split decision is
made inline in `Pressed`.

### XjRibbon.xojo_code — Private Properties

| Property | Desktop | Web | Action |
|----------|---------|-----|--------|
| `mPressedOnArrow As Boolean` | EXISTS (line 1318) | NOT NEEDED | Skip — web decides inline in Pressed |

### New Method: DrawCheckBoxItem

Needs to be added as a new `Private Sub DrawCheckBoxItem(g As WebGraphics, item As XjRibbonItem)`.

### Session.xojo_code — Hash Routing

**No changes needed.** The existing `xjmm:` hash for hover and `xjdd:` hash for dropdown
already cover all Phase 7 use cases:
- Hover over SplitButton → `xjmm:` → `HandleMouseMove` → `HitTestItems` → sets `mIsHovered`
- Click SplitButton arrow → `Pressed` event → SplitButton dispatch above
- CheckBox hover → same `xjmm:` path
- CheckBox click → `Pressed` → existing `IsToggle` branch handles it

**No new hash prefix required.**

---

## Web-Specific Adaptation Notes Per Feature

### 1. kItemTypeCheckBox and kItemTypeSeparator Constants

Add after `kItemTypeDropdown` (or at end of constants block, around line 1083).

```xojo
#tag Constant, Name = kItemTypeCheckBox, Type = Double, Dynamic = False, Default = "3", Scope = Public
#tag EndConstant
#tag Constant, Name = kItemTypeSeparator, Type = Double, Dynamic = False, Default = "4", Scope = Public
#tag EndConstant
```

Also add:
```xojo
#tag Constant, Name = kArrowZoneWidth, Type = Double, Dynamic = False, Default = "24", Scope = Private
#tag EndConstant
```

### 2. IsSplitButton Property (XjRibbonItem)

Insert after `IsToggleActive` (line 41), before `mMenuItems`:

```xojo
#tag Property, Flags = &h0
  IsSplitButton As Boolean = False
#tag EndProperty
```

No other properties change. Web uses `WebMenuItem` for `mMenuItems` — already correct.

### 3. AddSplitButton / AddCheckBox / AddSeparator (XjRibbonGroup)

Add after `AddDropdownButton` (line 52, before `#tag Property`). Code is identical to
desktop except the class names are web classes (no DesktopMenuItem references in these
factory methods — they don't touch menu items).

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

### 4. LayoutTabs — CheckBox Batch Branch

Insert `ElseIf item.ItemType = 3 Then` after the `ItemType = 1` batch (line 324) and before
the `Else` (line 325). Uses `MeasureTextWidth` (not `g.TextWidth`). Uses web-scaled glyph
size (16 instead of 13).

```xojo
ElseIf item.ItemType = 3 Then
  // CheckBox column batch: same 3-per-column stacking as small buttons
  Var cbBatch() As XjRibbonItem
  Var cbMaxTextW As Double = 0
  While idx <= group.mItems.LastIndex And group.mItems(idx).ItemType = 3 And cbBatch.Count < 3
    cbBatch.Add(group.mItems(idx))
    Var cbTw As Double = MeasureTextWidth(group.mItems(idx).Caption, 11, False)
    If cbTw > cbMaxTextW Then cbMaxTextW = cbTw
    idx = idx + 1
  Wend
  Var cbGlyph As Double = 16
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
```

### 5. LayoutTabs — Separator Branch

Insert `ElseIf item.ItemType = 4 Then` after the CheckBox branch, before `Else`:

```xojo
ElseIf item.ItemType = 4 Then
  // Separator: visual column gap, no bounds needed, no draw
  item.mBoundsW = 0
  item.mBoundsH = 0
  itemX = itemX + kItemGap
  idx = idx + 1
```

### 6. LayoutTabs — Else Branch (SplitButton auto-expand)

Current web `Else` branch sets fixed `kLargeButtonWidth` (line 329). Desktop Phase 5 added
auto-expand based on text width and a `kArrowZoneWidth` addition for SplitButtons.

The web `Else` branch currently does NOT use `MeasureTextWidth` for button width — it uses
the fixed constant. Update to match desktop Phase 5 behavior:

```xojo
Else
  item.mBoundsX = itemX
  item.mBoundsY = contentY
  Var captionLines() As String = item.Caption.Split(Chr(10))
  Var maxCapW As Double = 0
  For Each cl As String In captionLines
    Var clw As Double = MeasureTextWidth(cl, 11, False)
    If clw > maxCapW Then maxCapW = clw
  Next
  Var btnW As Double = Max(kLargeButtonWidth, maxCapW + 16)
  If item.IsSplitButton Then btnW = btnW + kArrowZoneWidth
  item.mBoundsW = btnW
  item.mBoundsH = itemAreaH
  itemX = itemX + btnW + kItemGap
  idx = idx + 1
End If
```

### 7. DrawGroups — Case 3 and Case 4

In `DrawGroups` (lines 467–475), insert before `Else`:

```xojo
Case 3
  DrawCheckBoxItem(g, item)
Case 4
  // Separator — no rendering
```

Full updated Select Case:
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

### 8. DrawDropdownButton — SplitButton Separator and Chevron

In `DrawDropdownButton` (lines 609–630), replace the single unconditional chevron block with
an If/Else:

```xojo
Private Sub DrawDropdownButton(g As WebGraphics, item As XjRibbonItem)
  DrawLargeButton(g, item)

  Var arrowW As Double = kDropdownArrowSize

  If item.IsSplitButton Then
    // Separator at kArrowZoneWidth from right edge
    Var sepX As Double = item.mBoundsX + item.mBoundsW - kArrowZoneWidth
    g.DrawingColor = cBorder
    g.FillRectangle(sepX, item.mBoundsY + 5, 1, item.mBoundsH - 10)
    // Chevron centered in arrow zone
    Var arrowX As Double = sepX + (kArrowZoneWidth - arrowW) / 2
    Var arrowY As Double = item.mBoundsY + item.mBoundsH - 7
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
  Else
    // Plain dropdown: chevron centered in full button width (unchanged)
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
  End If
End Sub
```

**Separator line y-offset:** Desktop uses `+4` top offset and `-8` height reduction on a
22px-tall item. Web small button height is 26px, so `+5` top offset and `-10` height
reduction produces equivalent proportional result.

### 9. DrawLargeButton — SplitButton Text Centering

In `DrawLargeButton` (lines 495–552), after computing `textW` (line 548), add:

```xojo
Var drawBodyW As Double = If(item.IsSplitButton, bw - kArrowZoneWidth, bw)
Var textX As Double = bx + (drawBodyW - textW) / 2
```

Replace the existing line:
```xojo
Var textX As Double = bx + (bw - textW) / 2
```

This keeps text inside the body zone and out of the arrow zone.

### 10. New DrawCheckBoxItem Method

Add as a new `Private Sub` after `DrawDropdownButton` (around line 631):

```xojo
Private Sub DrawCheckBoxItem(g As WebGraphics, item As XjRibbonItem)
  Var bx As Double = item.mBoundsX
  Var by As Double = item.mBoundsY
  Var bw As Double = item.mBoundsW
  Var bh As Double = item.mBoundsH   // = kSmallButtonHeight = 26

  // Hover/pressed background for whole row
  If item.mIsPressed Then
    g.DrawingColor = cItemPressedBackground
    g.FillRoundRectangle(bx, by, bw, bh, 3)
  ElseIf item.mIsHovered Then
    g.DrawingColor = cItemHoverBackground
    g.FillRoundRectangle(bx, by, bw, bh, 3)
  End If

  // Glyph: 16x16 rounded rect (scaled from desktop 13x13), vertically centered
  Var glyphSize As Double = 16
  Var glyphX As Double = bx + 2
  Var glyphY As Double = by + (bh - glyphSize) / 2

  If item.IsToggleActive Then
    // Checked: blue fill + white checkmark
    g.DrawingColor = cTabAccent
    g.FillRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2)
    g.DrawingColor = Color.RGB(255, 255, 255)
    g.PenSize = 1.5
    // Checkmark scaled proportionally to 16px glyph
    g.DrawLine(glyphX + 3, glyphY + 8, glyphX + 6, glyphY + 11)
    g.DrawLine(glyphX + 6, glyphY + 11, glyphX + 13, glyphY + 4)
    g.PenSize = 1
  Else
    // Unchecked: white interior with cBorder border
    g.DrawingColor = cContentBackground
    g.FillRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2)
    g.DrawingColor = cBorder
    g.DrawRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2)
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
  Var textY As Double = by + (bh + MeasureTextHeight(11)) / 2 - 1
  g.DrawText(item.Caption, textX, textY)
End Sub
```

**Key web adaptations in this method:**
- `g.FillRoundRectangle(x, y, w, h, r)` — single corner radius (not two like desktop)
- `g.DrawRoundRectangle(x, y, w, h, r)` — single corner radius
- `MeasureTextHeight(11)` instead of `g.TextHeight` for vertical text centering
- Glyph size 16 instead of 13 (120% scale)
- Checkmark coordinates scaled proportionally: `(+2,+6), (+5,+9), (+11,+3)` on 13px becomes
  `(+3,+8), (+6,+11), (+13,+4)` on 16px

### 11. Pressed Event — SplitButton Dispatch

In the `Pressed` event (lines 28–81), replace the item dispatch block (lines 68–80):

**Current (web):**
```xojo
Var hitItem As XjRibbonItem = HitTestItems(x, y)
If hitItem <> Nil And hitItem.IsEnabled Then
  If hitItem.ItemType = 2 And hitItem.mMenuItems.Count > 0 Then
    mDropdownPendingItem = hitItem
    ShowDropdownMenu(hitItem, x, y)
  Else
    If hitItem.IsToggle Then
      hitItem.IsToggleActive = Not hitItem.IsToggleActive
    End If
    RaiseEvent ItemPressed(hitItem.Tag)
    Me.Refresh
  End If
End If
```

**Phase 7 replacement:**
```xojo
Var hitItem As XjRibbonItem = HitTestItems(x, y)
If hitItem <> Nil And hitItem.IsEnabled Then
  If hitItem.ItemType = 2 And hitItem.mMenuItems.Count > 0 Then
    If hitItem.IsSplitButton And x < hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth Then
      // SplitButton body click — fire ItemPressed, no menu
      RaiseEvent ItemPressed(hitItem.Tag)
      Me.Refresh
    Else
      // Arrow click or plain dropdown — open JS menu
      mDropdownPendingItem = hitItem
      ShowDropdownMenu(hitItem, x, y)
    End If
  Else
    If hitItem.IsToggle Then
      hitItem.IsToggleActive = Not hitItem.IsToggleActive
    End If
    RaiseEvent ItemPressed(hitItem.Tag)
    Me.Refresh
  End If
End If
```

**CheckBox (ItemType=3) dispatch:** CheckBox items are set with `IsToggle = True` by
`AddCheckBox`. They fall into the `Else` branch naturally. `hitItem.IsToggle` is True, so
`IsToggleActive` flips and `ItemPressed` fires. No extra branch needed for CheckBox.

---

## Text Measurement Pattern in Web

Web `XjRibbon.xojo_code` has no `g.TextWidth` on `WebGraphics`. The existing codebase
uses a private helper (lines 718–739):

```xojo
Private Function MeasureTextWidth(text As String, fontSize As Double, bold As Boolean) As Double
  If mMeasurePic = Nil Then
    mMeasurePic = New Picture(1, 1)
  End If
  Var mg As Graphics = mMeasurePic.Graphics
  mg.FontSize = fontSize
  mg.Bold = bold
  Return mg.TextWidth(text)
End Function

Private Function MeasureTextHeight(fontSize As Double) As Double
  If mMeasurePic = Nil Then
    mMeasurePic = New Picture(1, 1)
  End If
  Var mg As Graphics = mMeasurePic.Graphics
  mg.FontSize = fontSize
  Return mg.TextHeight
End Function
```

`mMeasurePic` is already declared as a private property (`Private mMeasurePic As Picture`,
line 938). All Phase 7 code that needs text measurement must call `MeasureTextWidth` and
`MeasureTextHeight`. Never call `g.TextWidth` or `g.TextHeight` on a `WebGraphics` object.

---

## MouseDown / Hit-Test Pattern in Web

**There is no `MouseDown` or `MouseMove` event on WebCanvas.** The web ribbon uses:

1. **`Pressed(x As Integer, y As Integer)`** — WebCanvas event, fires on click. This is the
   ONLY native mouse click event. It handles everything desktop handles in both `MouseDown`
   and `MouseUp`.

2. **`HandleMouseMove(x, y)`** — a public method called by `Session.HashtagChanged` when the
   JS injects `xjmm:x:y` into `window.location.hash`. Fires via mousemove throttled at 60ms.
   It calls `HitTestItems` and `HitTestTabs` to update `mIsHovered` states.

3. **`HandleMouseLeave()`** — called by Session when JS fires `xjml`. Clears all hover states.

4. **`InjectMouseTracking()`** — injects the JS mousemove/mouseleave listeners on first paint.
   Already fully implemented. No changes needed for Phase 7.

**SplitButton hover distinction:** The web does NOT need to visually distinguish between hovering
the body zone vs the arrow zone of a SplitButton (unlike some native ribbon implementations).
The entire button shows `mIsHovered = True` when moused over. This is acceptable for Phase 7.

---

## FillRoundRectangle Signature Difference

**CONFIRMED from actual source files:**

- **Desktop** (`desktop/XjRibbon.xojo_code`, `DrawCheckBoxItem` line 714):
  ```xojo
  g.FillRoundRectangle(bx, by, bw, bh, 3, 3)   // two corner radius params
  g.DrawRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2, 2)
  ```

- **Web** (`web/XjRibbon.xojo_code`, `DrawSmallButton` line 565):
  ```xojo
  g.FillRoundRectangle(bx, by, bw, bh, 3)       // single corner radius param
  g.DrawRoundRectangle(bx + 0.5, by + 0.5, bw - 1, bh - 1, 3)
  ```

All web `FillRoundRectangle` and `DrawRoundRectangle` calls use a single radius. Every occurrence
in `DrawCheckBoxItem` must use the single-param form.

---

## JS Hover Hash Injection — How It Works

The `InjectMouseTracking` method (lines 858–879) runs once on first paint. It attaches:
- `mousemove` listener → throttled → sets `window.location.hash = 'xjmm:' + x + ':' + y`
- `mouseleave` listener → sets `window.location.hash = 'xjml'`

`Session.HashtagChanged` (Session.xojo_code) routes:
- `xjmm:x:y` → `MainWebPage.XjRibbon1.HandleMouseMove(x, y)`
- `xjml` → `MainWebPage.XjRibbon1.HandleMouseLeave`
- `xjdd:itemTag:menuTag` → `HandleDropdownSelection(itemTag, menuTag)`

**For Phase 7:** No new hash prefix or new JS listener is needed. SplitButton hover is handled
by the existing `xjmm:` path. The SplitButton body/arrow click distinction is computed in the
`Pressed` event using the x coordinate (no JS involvement).

---

## Exact Insertion Points in web/XjRibbon.xojo_code

| Change | Location | What to Do |
|--------|----------|-----------|
| Constants kItemTypeCheckBox, kItemTypeSeparator, kArrowZoneWidth | After line 1083 (`kDoubleClickUs`) | Insert 3 constant blocks |
| DrawGroups Case 3, Case 4 | Lines 468–474 (Select Case) | Insert Case 3 and Case 4 before Else |
| DrawDropdownButton SplitButton branch | Lines 609–630 | Replace chevron block with If/Else |
| DrawLargeButton SplitButton text centering | Lines 548–551 | Add drawBodyW, replace textX |
| DrawCheckBoxItem new method | After line 630 (end of DrawDropdownButton) | Insert full new method |
| LayoutTabs CheckBox batch branch | Lines 324–325 (between `itemX = itemX + colWidth + kItemGap` and `Else`) | Insert ElseIf ItemType=3 batch |
| LayoutTabs Separator branch | Between CheckBox branch and Else | Insert ElseIf ItemType=4 |
| LayoutTabs Else branch auto-expand | Lines 326–333 | Replace fixed-width with auto-expand + IsSplitButton |
| Pressed event SplitButton dispatch | Lines 70–80 | Replace simple dropdown block with If/Else |

---

## Demo Update (MainWebPage.xojo_code)

Add to `Shown` event after the existing contextual tab setup, using the same `viewTab` variable
declared on line 214:

```xojo
// Show/hide group on View tab
Var showHide As XjRibbonGroup = viewTab.AddNewGroup("Show/hide")
Var cb1 As XjRibbonItem = showHide.AddCheckBox("Item check boxes", "view.checkboxes")
#Pragma Unused cb1
Var cb2 As XjRibbonItem = showHide.AddCheckBox("File name extensions", "view.extensions")
#Pragma Unused cb2
Var cb3 As XjRibbonItem = showHide.AddCheckBox("Hidden items", "view.hidden", True)
#Pragma Unused cb3
showHide.AddSeparator()
Call showHide.AddSmallButton("Hide selected", "view.hide_selected")

// Panes group on View tab (SplitButton)
Var navGroup As XjRibbonGroup = viewTab.AddNewGroup("Panes")
Var navPane As XjRibbonItem = navGroup.AddSplitButton("Navigation pane", "view.nav_pane")
navPane.AddMenuItem("Navigation pane", "view.nav_pane.toggle")
navPane.AddMenuItem("Expand to open folder", "view.nav_pane.expand")
navPane.AddMenuItem("Show all folders", "view.nav_pane.allfolders")
```

**Note:** `viewTab` is declared at line 214. The new groups must be appended in the same `Shown`
event, in scope. The demo `ItemPressed` handler already uses a fallback `MessageBox` for unknown
tags — no handler change needed for basic demo.

---

## Common Pitfalls

### Pitfall 1: Two-radius FillRoundRectangle
**What goes wrong:** Copying desktop draw code verbatim without removing the second radius arg.
**Why it happens:** Desktop uses `(x, y, w, h, r, r)`. Web API only accepts `(x, y, w, h, r)`.
**How to avoid:** Search for all `FillRoundRectangle` and `DrawRoundRectangle` calls in new code;
verify each has exactly 5 args, not 6.

### Pitfall 2: g.TextWidth on WebGraphics
**What goes wrong:** `g.TextWidth(item.Caption)` compiles but returns 0 or wrong values.
**Why it happens:** `WebGraphics` does not expose `TextWidth`.
**How to avoid:** Every text measurement call in web code must use `MeasureTextWidth(text, size, bold)`.
Check: LayoutTabs CheckBox batch loop, LayoutTabs Else branch (auto-expand).

### Pitfall 3: mPressedOnArrow not needed (and would cause compile error)
**What goes wrong:** Adding `mPressedOnArrow As Boolean` as a property and setting it in Pressed.
**Why it happens:** Misreading the desktop approach.
**How to avoid:** Web has a single `Pressed` event. The x coordinate is available right at dispatch
time. Compute `x < hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth` inline.

### Pitfall 4: CheckBox not handled in Pressed (unnecessary branch)
**What goes wrong:** Adding a separate `Case 3` branch in Pressed for CheckBox.
**Why it happens:** Over-engineering.
**How to avoid:** CheckBox has `IsToggle = True` set by `AddCheckBox`. The existing `Else` branch
in Pressed handles all toggle types via `If hitItem.IsToggle Then hitItem.IsToggleActive = Not ...`.
No extra branch needed.

### Pitfall 5: Separator Else-branch fallthrough
**What goes wrong:** Separator (ItemType=4) falls into the `Else` branch of DrawGroups and
calls `DrawLargeButton` with zero bounds, rendering a filled rectangle at (0,0).
**How to avoid:** `Case 4` with a comment (no code) is mandatory in the DrawGroups Select Case.

### Pitfall 6: viewTab out of scope in demo
**What goes wrong:** Declaring new groups outside the scope of `viewTab` local variable.
**Why it happens:** If the Phase 7 code is added as a separate event handler or sub.
**How to avoid:** All demo additions go inside the same `Shown` event, after line 227.

### Pitfall 7: Editing while Xojo is open
**What goes wrong:** Xojo IDE re-saves the `.xojo_code` file on next compile, discarding edits.
**How to avoid:** Quit Xojo IDE before editing `.xojo_code` files. (From MEMORY.md.)

---

## Validation Architecture

No automated test framework exists. Manual validation checklist for Phase 7:

| REQ | Manual Test |
|-----|-------------|
| REQ-701 | Compile without error; `navPane.IsSplitButton` accessible in web demo |
| REQ-702 | Click left 80% of web SplitButton → no menu; click arrow zone → JS menu appears |
| REQ-702 | Web SplitButton body fires `ItemPressed("view.nav_pane")` |
| REQ-702 | Arrow click → select menu item → `DropdownMenuAction` fires |
| REQ-702 | Vertical separator line visible at 80% width on web SplitButton |
| REQ-703 | `DrawCheckBoxItem` uses `g.FillRoundRectangle(x,y,w,h,r)` (5 args, not 6) |
| REQ-703 | Unchecked: rounded rect border. Checked: blue fill + white checkmark |
| REQ-704 | Constants `kItemTypeCheckBox = 3` and `kItemTypeSeparator = 4` compile cleanly |
| REQ-705 | `showHide.AddSplitButton(...)`, `AddCheckBox(...)`, `AddSeparator()` all callable |
| — | 3 checkboxes stack in correct column layout; separator creates visible gap |
| — | "Hide selected" small button renders after separator in its own column |
| — | CheckBox click flips state; `ItemPressed` fires; second click reverses |
| — | Hover state works on CheckBox rows via existing `xjmm:` hash |

---

## Open Questions

1. **CheckBox glyph size 16 vs 13:** The DEV_PLAN says "draw a 13x13 rounded rect border"
   (from the desktop spec). For the web at 120% scale, 16 is the natural value. Since no
   explicit web glyph size is specified in the requirements, 16 is recommended — consistent
   with all other web constants being ~1.2x desktop values.

2. **SplitButton body zone threshold:** Desktop uses `kArrowZoneWidth` (a fixed pixel width
   from the right edge) rather than the 80% percentage described in the DEV_PLAN. The actual
   desktop implementation uses `hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth`
   as the threshold. This is cleaner than a percentage. Web should use the same approach
   with `kArrowZoneWidth = 24`.

3. **DrawLargeButton multi-line caption:** Desktop Phase 5 added multi-line caption support
   (split on `Chr(10)`) to DrawLargeButton. Web DrawLargeButton does not have this. Phase 7
   can add the SplitButton text centering fix without adding full multi-line support (it's
   a separate, non-required feature for Phase 7).

---

## Sources

### Primary (HIGH confidence — all extracted directly from source files in this session)
- `web/XjRibbonItem.xojo_code` — full file read (72 lines)
- `web/XjRibbonGroup.xojo_code` — full file read (79 lines)
- `web/XjRibbon.xojo_code` — full file read (1277 lines)
- `web/Session.xojo_code` — full file read (57 lines)
- `web/MainWebPage.xojo_code` — full file read (555 lines)
- `desktop/XjRibbonItem.xojo_code` — full file read (80 lines)
- `desktop/XjRibbonGroup.xojo_code` — full file read (112 lines)
- `desktop/XjRibbon.xojo_code` — full file read (1459 lines)
- `.planning/phases/05-desktop-complete-control-set/05-RESEARCH.md` — reference (836 lines)
- `DEV_PLAN.md` — web-specific constraints and Phase 7 scope
- `.planning/REQUIREMENTS.md` — REQ-701 through REQ-705 confirmed

### No external sources needed
Phase 7 is entirely an internal code port with no new dependencies.

---

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Web glyph size 16 is appropriate (13 * 1.2 = 15.6, rounded to 16) | DrawCheckBoxItem | Glyph slightly larger than proportionally exact — cosmetic only |
| A2 | kArrowZoneWidth = 24 (20 * 1.2) matches 120% scaling convention | Constants | Arrow zone too wide or narrow — cosmetic only |

**Both assumptions are cosmetic and low-risk. All other claims are VERIFIED from source.**

---

## Metadata

**Confidence breakdown:**
- Standard Stack: HIGH — all patterns read directly from web source files
- Architecture: HIGH — exact method signatures, loop structures, event handlers extracted
- Pitfalls: HIGH — confirmed from direct comparison of desktop vs web APIs

**Research date:** 2026-04-20
**Valid until:** N/A — codebase research; valid until source files change.

---

## RESEARCH COMPLETE
