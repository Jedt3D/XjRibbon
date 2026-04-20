---
phase: 05-desktop-complete-control-set
plan: "03"
subsystem: desktop-canvas
tags: [canvas, rendering, layout, mouse-dispatch, split-button, checkbox, separator]
dependency_graph:
  requires: ["05-01", "05-02"]
  provides: ["05-04"]
  affects: ["desktop/XjRibbon.xojo_code"]
tech_stack:
  added: []
  patterns:
    - "SplitButton 80/20 hit-split via mPressedOnArrow canvas property"
    - "CheckBox uses existing IsToggle/IsToggleActive dispatch path — zero new MouseUp branches"
    - "Separator explicit Case 4 prevents DrawLargeButton render artifact on zero-bounds item"
    - "CheckBox batch loop mirrors Small batch but uses 13px glyph formula instead of 16px icon"
key_files:
  modified:
    - desktop/XjRibbon.xojo_code
decisions:
  - "mPressedOnArrow placed on XjRibbon canvas (not XjRibbonItem) — transient per-interaction state, avoids polluting item data model"
  - "Separator advances itemX by kItemGap (4px) to create visible column gap without new constant"
  - "DrawDropdownButton IsSplitButton=False path is byte-for-byte identical to original — full backward compatibility"
  - "Case 4 must be explicit in DrawGroups Select Case — Else branch would call DrawLargeButton on zero-bounds Separator causing render artifact"
metrics:
  duration: "5 minutes"
  completed: "2026-04-20"
  tasks_completed: 4
  tasks_total: 4
  files_modified: 1
---

# Phase 5 Plan 03: Canvas Complete Control Set Summary

**One-liner:** Eight surgical edits to XjRibbon.xojo_code implement SplitButton draw/dispatch, CheckBox glyph rendering and column layout, and Separator no-op — all using existing patterns and constants with zero new dependencies.

## Tasks Completed

| Task | Name | Commit | Key Changes |
|------|------|--------|-------------|
| A | Constants + mPressedOnArrow property | 69d6ad9 | kItemTypeCheckBox=3, kItemTypeSeparator=4 (both Public), Private mPressedOnArrow As Boolean = False |
| B | DrawCheckBoxItem + DrawGroups dispatch | b17e2f0 | New DrawCheckBoxItem method, Case 3/Case 4 in DrawGroups Select Case |
| C | LayoutTabs CheckBox batch + Separator | e67e430 | ElseIf ItemType=3 batch loop (13px glyph), ElseIf ItemType=4 zero-bounds + itemX bump |
| D | DrawDropdownButton SplitButton + MouseDown + MouseUp | 19d8995 | Separator line at 80%, chevron in 20% zone, mPressedOnArrow assignment, body-vs-arrow dispatch |

## Eight Changes Applied

### 1. Constants (Task A)
`kItemTypeCheckBox = 3` and `kItemTypeSeparator = 4` added as Public constants after `kItemTypeDropdown` in the constants block. Sequential integer values maintain consistency with existing 0/1/2 set.

### 2. mPressedOnArrow Property (Task A)
Private canvas property `mPressedOnArrow As Boolean = False` inserted after `mExpandedHeight`. Lifecycle: set in MouseDown immediately after hit-test confirms a SplitButton item; read in MouseUp to choose body-vs-arrow dispatch path; reset to False for any non-SplitButton press.

### 3. DrawCheckBoxItem Method (Task B)
New private method inserted after `DrawDropdownButton`. Draws:
- Hover/pressed background (FillRoundRectangle, radius 3) when `mIsPressed` or `mIsHovered`
- 13×13 glyph at bx+2, vertically centered: blue fill + white checkmark (two PenSize=1.5 lines) when `IsToggleActive`; white interior + cBorder border when unchecked
- Text label at glyphX + 13 + kSmallButtonTextPadding, vertically centered

### 4. DrawGroups Select Case (Task B)
Added `Case 3 → DrawCheckBoxItem(g, item)` and `Case 4 → // Separator — no rendering` before the existing `Else → DrawLargeButton`. Explicit Case 4 prevents Separator's zero-bounds item from reaching DrawLargeButton.

### 5. LayoutTabs CheckBox Batch (Task C)
New `ElseIf item.ItemType = 3` branch with its own batch loop. Identical structure to the Small (ItemType=1) batch but uses colWidth formula: `13 + kSmallButtonTextPadding + maxTextW + kSmallButtonTextPadding * 2` (glyph=13px instead of kSmallButtonIconSize=16px). Stacks up to 3 CheckBoxes per column, vertically centered.

### 6. LayoutTabs Separator (Task C)
New `ElseIf item.ItemType = 4` branch: sets `item.mBoundsW = 0` and `item.mBoundsH = 0` (makes it unhittable), advances `itemX` by `kItemGap` (4px) for a visual column gap, increments `idx`.

### 7. DrawDropdownButton SplitButton Drawing (Task D)
When `item.IsSplitButton = True`:
- Draws 1px vertical separator line at `mBoundsX + mBoundsW * 0.80` using `g.FillRectangle`
- Draws chevron centered in the 20% arrow zone only

When `item.IsSplitButton = False`: original code path unchanged — full backward compatibility.

### 8. MouseDown + MouseUp Dispatch (Task D)
**MouseDown:** After `mPressedItem = hitItem`, checks `hitItem.ItemType = 2 And hitItem.IsSplitButton`. If true, sets `mPressedOnArrow = x >= hitItem.mBoundsX + hitItem.mBoundsW * 0.80`. Otherwise resets to False.

**MouseUp:** The `ItemType = 2` path now checks `pressed.IsSplitButton And Not mPressedOnArrow`. If true (body click), fires `RaiseEvent ItemPressed`. Otherwise (arrow click or plain Dropdown), opens popup menu and fires `DropdownMenuAction`. CheckBox (ItemType=3) falls through to the `Else` branch where `IsToggle = True` flips `IsToggleActive` — no new branch needed.

## Backward Compatibility

- `IsSplitButton` defaults to `False` → existing Dropdown items use original `DrawDropdownButton` path unchanged
- `kItemTypeCheckBox` and `kItemTypeSeparator` are new values — no existing code tests ItemType for 3 or 4
- All existing Large (0), Small (1), Dropdown (2) layout and draw paths are byte-for-byte unchanged

## Deviations from Plan

### Minor count discrepancies in acceptance criteria (not functional issues)

**1. [Not a bug] mPressedOnArrow count = 4, plan expected 3**
- The implementation has: declaration + `mPressedOnArrow = x >= ...` (True path) + `mPressedOnArrow = False` (Else path) + `Not mPressedOnArrow` (MouseUp read) = 4 occurrences. The plan assumed one assignment, but two conditional assignments is the correct and safer implementation.

**2. [Not a bug] Case 3 matches = 3, plan expected 1**
- Pre-existing `Case 30` and `Case 31` in the keyboard navigation `HandleKeyDown` method contain the substring "Case 3". The actual standalone `Case 3` in DrawGroups exists exactly once (line 501). Grep substring match artifact.

**3. [Not a bug] g.PenSize = 1.5 count = 3, plan expected 2**
- Pre-existing `DrawCollapseChevron` method also uses `g.PenSize = 1.5`. The plan's expected count of 2 did not account for this pre-existing occurrence. DrawDropdownButton and DrawCheckBoxItem each correctly set and reset PenSize.

**4. [Not a bug] RaiseEvent ItemPressed count = 3, RaiseEvent DropdownMenuAction count = 2**
- Pre-existing `ActivateItemByKeyboard` method (keyboard navigation) contains one of each. The plan's expected counts didn't account for these pre-existing occurrences. New code adds exactly the intended calls.

None of these are functional bugs — all reflect pre-existing code the plan's grep counts didn't anticipate.

## Known Stubs

None. All new code paths are fully wired: DrawCheckBoxItem reads live item state, LayoutTabs assigns real bounds, MouseDown/MouseUp use the real hit-test and event system.

## Self-Check: PASSED

- FOUND: desktop/XjRibbon.xojo_code
- FOUND: 05-03-SUMMARY.md
- FOUND commit: 69d6ad9 (Task A)
- FOUND commit: b17e2f0 (Task B)
- FOUND commit: e67e430 (Task C)
- FOUND commit: 19d8995 (Task D)
