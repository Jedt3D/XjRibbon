# XjRibbon Desktop Phase 4 — Keyboard Navigation + Toggle Buttons

## Context

Phases 1-3 complete: tabs, groups, large/small/dropdown buttons, dark mode, icons, tooltips, collapse/expand, contextual tabs. Phase 4 adds keyboard-driven navigation with KeyTip badges and toggle button state for Bold/Italic-style buttons. QAT deferred — may revisit later.

## Scope

| Feature | Complexity | Steps |
|---------|-----------|-------|
| Toggle Buttons | Low | Steps 1-2 |
| Keyboard Navigation + KeyTips | High | Steps 3-7 |
| Demo + Integration | Low | Step 8 |

---

## Feature 1: Toggle Buttons (Steps 1-2)

### Step 1: Data Model — XjRibbonItem Properties

**File: `desktop/XjRibbonItem.xojo_code`**

Add two public properties:
```
Property IsToggle As Boolean = False
Property IsToggleActive As Boolean = False
```

Any item type (large/small) can be a toggle. Dropdown (type=2) should NOT be a toggle.

### Step 2: Visual Rendering + Click Logic

**File: `desktop/XjRibbon.xojo_code`**

New colors in ResolveColors:
- `cToggleActiveBackground` — Light: RGB(200,220,240), Dark: RGB(55,70,90)
- `cToggleActiveHoverBackground` — Light: RGB(185,210,235), Dark: RGB(65,80,100)

Modify DrawLargeButton/DrawSmallButton — add toggle active state between pressed and hovered checks:
```
ElseIf item.IsToggle And item.IsToggleActive Then
  // highlighted background + subtle inset border
```

Modify MouseUp — before `RaiseEvent ItemPressed`:
```
If mPressedItem.IsToggle Then
  mPressedItem.IsToggleActive = Not mPressedItem.IsToggleActive
End If
```

New public convenience methods:
```
Function GetToggleState(tag As String) As Boolean
Sub SetToggleState(tag As String, value As Boolean)
```

New private helper (reused later by keyboard nav):
```
Private Function FindItemByTag(tag As String) As XjRibbonItem
```

---

## Feature 2: Keyboard Navigation + KeyTips (Steps 3-7)

### Step 3: Enable Keyboard Input

**File: `desktop/XjRibbon.xojo_code`**

Add `Opening` event: `Me.AllowFocus = True`, `Me.AllowTabs = True`, `Me.AllowFocusRing = False`

Add events: `KeyDown(key)` → calls `HandleKeyDown(key)`, `KeyUp(key)`, `FocusLost` → `DismissKeyTips()`

### Step 4: KeyTip Assignment System

**File: `desktop/XjRibbonTab.xojo_code`** — add `Property KeyTip As String`
**File: `desktop/XjRibbonItem.xojo_code`** — add `Property KeyTip As String`

**File: `desktop/XjRibbon.xojo_code`**:
- `AssignKeyTips()` — auto-assign letters from captions (first letter, then fallback)
- `AutoPickLetter(caption, usedDict) As String` — pick unique letter

### Step 5: KeyTip State Machine + Key Handling

State properties:
```
mKeyTipMode As Integer = 0    // 0=none, 1=tabs, 2=items
mKeyTipsAssigned As Boolean = False
mFocusedTabIndex, mFocusedGroupIndex, mFocusedItemIndex As Integer = -1
```

`HandleKeyDown(key)`:
- **Activation**: Ctrl+Option (macOS) or Alt (Windows) or F6 → enter Level 1
- **Escape**: back one level (L2→L1→dismiss)
- **Arrow keys**: Left/Right between tabs (L1) or items (L2), Down enters L2, Up returns to L1
- **Enter/Space**: activate focused element
- **Tab key**: cycle through items in L2
- **Letter matching**: L1 matches tab KeyTips, L2 matches item KeyTips

`MatchKeyTipLevel1/Level2`, `ActivateItemByKeyboard(item)`, `DismissKeyTips()`, `ClearFocusState()`

### Step 6: KeyTip Badge Drawing

New colors: `cKeyTipBackground`, `cKeyTipBorder`, `cKeyTipText`, `cFocusRing`

`DrawKeyTips(g)` — called at end of Paint, draws small rounded-rect badges:
- Level 1: badges centered below each tab header
- Level 2: badges on items (centered for large, right-edge for small)

`DrawKeyTipBadge(g, letter, cx, cy)` — white rounded rect with letter, 14px tall

### Step 7: Focus Ring + Mouse Dismissal

In DrawGroups — draw 2px accent-colored ring around keyboard-focused item.
In DrawTabStrip — draw ring around focused tab in Level 1.
In MouseDown — `If mKeyTipMode <> kKeyTipNone Then DismissKeyTips()` at top.

---

## Step 8: Demo + Integration

**File: `desktop/MainWindow.xojo_window`**

1. Mark Bold/Italic/Underline as `IsToggle = True`
2. Optional manual KeyTips: `homeTab.KeyTip = "H"`, etc.
3. Update ItemPressed handler to show toggle state
4. Test keyboard navigation flows

---

## Files Modified

| File | Steps | Changes |
|------|-------|---------|
| `desktop/XjRibbonItem.xojo_code` | 1, 4 | IsToggle, IsToggleActive, KeyTip properties |
| `desktop/XjRibbonTab.xojo_code` | 4 | KeyTip property |
| `desktop/XjRibbon.xojo_code` | 2-7 | Toggle rendering, keyboard events, KeyTip state machine, badge drawing |
| `desktop/MainWindow.xojo_window` | 8 | Demo toggle buttons, keyboard nav |

## New Public API Summary

```xojo
// Toggle Buttons
XjRibbonItem.IsToggle As Boolean
XjRibbonItem.IsToggleActive As Boolean
XjRibbon.GetToggleState(tag As String) As Boolean
XjRibbon.SetToggleState(tag As String, value As Boolean)

// KeyTips (optional — auto-assigned if empty)
XjRibbonTab.KeyTip As String
XjRibbonItem.KeyTip As String
```

All actions fire through existing `ItemPressed` and `DropdownMenuAction` events. No new events.

## Backward Compatibility

- Toggle: `IsToggle = False` default — no visual change
- Keyboard: `AllowFocus = True` set automatically, but keyboard mode only activates on explicit shortcut. Mouse operation unaffected.
- All existing API unchanged

## Verification

1. Toggle: click Bold → stays highlighted → click again → normal. GetToggleState returns correct value
2. SetToggleState programmatically → visual updates correctly
3. KeyTips: Ctrl+Option → badges on tabs → press letter → badges on items → press letter → item activates → dismissed
4. Arrow keys navigate between tabs and items with visible focus ring
5. Escape backs out one level, mouse click dismisses all
6. Dark mode: all new visuals (toggle highlight, KeyTip badges) readable
7. Keyboard activation of dropdown → popup menu appears
8. Keyboard activation of toggle → toggles state
9. All Phase 1-3 features still work (regression check)
