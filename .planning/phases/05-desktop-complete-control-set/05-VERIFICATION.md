---
phase: 05-desktop-complete-control-set
verified: 2026-04-20T18:00:00Z
status: human_needed
score: 16/16 must-haves verified
overrides_applied: 0
human_verification:
  - test: "SplitButton body vs arrow click fires distinct events"
    expected: "Clicking the left ~80% of Navigation pane fires ItemPressed (no menu); clicking the rightmost 20px fires DropdownMenuAction popup menu with 3 items"
    why_human: "Mouse hit-zone split (kArrowZoneWidth=20) requires physical click testing to confirm correct threshold; grep confirms code paths but not pixel accuracy at runtime"
  - test: "CheckBox glyph toggles between unchecked and checked states"
    expected: "Clicking 'Item check boxes' renders empty bordered rect; second click renders blue filled rect with white checkmark"
    why_human: "IsToggleActive rendering via DrawCheckBoxItem requires visual confirmation; grep verifies code exists but not correct rendering output"
  - test: "Hidden items checkbox starts in checked (blue) state on launch"
    expected: "On app launch, 'Hidden items' checkbox shows blue filled glyph with white checkmark"
    why_human: "Initial state driven by AddCheckBox(..., True) — confirmed in code but runtime visual state requires human observation"
  - test: "Separator creates visible gap between checkboxes and Hide selected button"
    expected: "A clear horizontal gap (kItemGap width) separates the checkbox column from the small button"
    why_human: "Separator sets mBoundsW=0 and advances itemX — layout result requires visual confirmation that the gap is visible and proportioned correctly"
  - test: "Existing Home and Insert tab controls still work unchanged"
    expected: "Large buttons, small buttons, toggle buttons, and dropdown 'Shapes' button all function as before Phase 5"
    why_human: "Backward compatibility of IsSplitButton=False code paths requires runtime interaction to confirm no regression"
---

# Phase 5: Desktop Complete Control Set — Verification Report

**Phase Goal:** Add CheckBox item, SplitButton mode, and Separator item to the desktop ribbon library to reach full coverage of the Windows File Explorer reference control set.
**Verified:** 2026-04-20T18:00:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|---------|
| 1 | XjRibbonItem exposes a public `IsSplitButton As Boolean = False` property | VERIFIED | Line 44 of `XjRibbonItem.xojo_code`: `IsSplitButton As Boolean = False` |
| 2 | `AddSplitButton(caption, tag)` returns XjRibbonItem with ItemType=2 and IsSplitButton=True | VERIFIED | `XjRibbonGroup.xojo_code` lines 55-63: sets `item.ItemType = 2` and `item.IsSplitButton = True` |
| 3 | `AddCheckBox(caption, tag, initialState=False)` returns XjRibbonItem with ItemType=3, IsToggle=True, IsToggleActive=initialState | VERIFIED | `XjRibbonGroup.xojo_code` lines 67-76: all three flags set correctly |
| 4 | `AddSeparator()` appends XjRibbonItem with ItemType=4, no return value | VERIFIED | `XjRibbonGroup.xojo_code` lines 80-84: Sub with `item.ItemType = 4` |
| 5 | `kItemTypeCheckBox = 3` and `kItemTypeSeparator = 4` constants exist (Public scope) | VERIFIED | `XjRibbon.xojo_code` lines 1457-1460: both constants present, `Scope = Public` |
| 6 | SplitButton draws vertical separator line at body/arrow boundary with chevron in arrow area only | VERIFIED | `XjRibbon.xojo_code` lines 667-685: `g.FillRectangle(sepX, ...)` + chevron in arrow zone using `kArrowZoneWidth=20` |
| 7 | SplitButton body click fires `ItemPressed`; arrow click opens popup menu | VERIFIED | `XjRibbon.xojo_code` lines 81-93: `pressed.IsSplitButton And Not mPressedOnArrow` routes to `RaiseEvent ItemPressed`; else opens menu |
| 8 | CheckBox draws 13x13 glyph (empty bordered rect when unchecked, blue+checkmark when checked) plus text label | VERIFIED | `XjRibbon.xojo_code` lines 704-752: `DrawCheckBoxItem` method with `glyphSize = 13`, `FillRoundRectangle`+`DrawRoundRectangle` for both states |
| 9 | CheckBox layout: `[13px glyph] [4px gap] [text]` — no icon slot | VERIFIED | `XjRibbon.xojo_code` line 750: `textX = glyphX + glyphSize + kSmallButtonTextPadding` (kSmallButtonTextPadding=4) |
| 10 | CheckBox stacks in columns of up to 3 (same batch logic as small button) | VERIFIED | `XjRibbon.xojo_code` lines 383-405: `cbBatch.Count < 3` limit, same row/column assignment structure |
| 11 | CheckBox click flips `IsToggleActive` and raises `ItemPressed` | VERIFIED | `XjRibbon.xojo_code` line 96-97: `AddCheckBox` sets `IsToggle=True`, so existing `If pressed.IsToggle Then pressed.IsToggleActive = Not pressed.IsToggleActive` handles it automatically |
| 12 | Separator causes `LayoutTabs` to advance `itemX` by `kItemGap` with zero bounds; no render, no interaction | VERIFIED | `XjRibbon.xojo_code` lines 406-411: `item.mBoundsW = 0`, `item.mBoundsH = 0`, `itemX = itemX + kItemGap`; `DrawGroups` Case 4 is a no-op |
| 13 | `mPressedOnArrow` private property exists on XjRibbon canvas for split-button hit tracking | VERIFIED | `XjRibbon.xojo_code` line 1318: `Private mPressedOnArrow As Boolean = False`; set in MouseDown (lines 61/63), read in MouseUp (line 81) |
| 14 | Demo View tab has "Show/hide" group with 3 checkboxes (1 starts checked), separator, and small button | VERIFIED | `MainWindow.xojo_window` lines 186-192: all 5 items present; "Hidden items" passes `True` as third argument |
| 15 | Demo View tab has "Panes" group with SplitButton "Navigation pane" and 3 menu items | VERIFIED | `MainWindow.xojo_window` lines 196-199: SplitButton + 3 `AddMenuItem` calls with correct tag strings |
| 16 | Existing code paths backward-compatible (IsSplitButton defaults False, no new ItemType for existing controls) | VERIFIED | `XjRibbonItem.xojo_code` line 44: `= False`; `DrawDropdownButton` Else branch (lines 686-699) preserves original chevron behavior |

**Score:** 16/16 truths verified

### Deferred Items

None.

### Required Artifacts

| Artifact | Expected | Status | Details |
|---------|---------|--------|---------|
| `desktop/XjRibbonItem.xojo_code` | `IsSplitButton As Boolean = False` property | VERIFIED | Present at line 44, between IsToggleActive and KeyTip, exactly one occurrence |
| `desktop/XjRibbonGroup.xojo_code` | `AddSplitButton`, `AddCheckBox`, `AddSeparator` factory methods | VERIFIED | All 3 methods present; method count = 8 (was 5) |
| `desktop/XjRibbon.xojo_code` | `kItemTypeCheckBox`, `kItemTypeSeparator`, `mPressedOnArrow`, `DrawCheckBoxItem`, updated dispatch, layout, draw, and mouse logic | VERIFIED | All 8 changes confirmed by grep |
| `desktop/MainWindow.xojo_window` | Show/hide group (3 checkboxes + separator + small button) and Panes group (SplitButton + 3 menu items) | VERIFIED | All items present with correct tags and initial state |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `AddSplitButton` | `XjRibbonItem.IsSplitButton` | `item.IsSplitButton = True` | WIRED | `XjRibbonGroup.xojo_code` line 60 |
| `AddCheckBox` | `XjRibbonItem.IsToggle / IsToggleActive` | `item.IsToggle = True`, `item.IsToggleActive = initialState` | WIRED | `XjRibbonGroup.xojo_code` lines 72-73 |
| `MouseDown` | `mPressedOnArrow` | `x >= hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth` | WIRED | `XjRibbon.xojo_code` line 61 |
| `MouseUp` | `ItemPressed / DropdownMenuAction` | `IsSplitButton And Not mPressedOnArrow` dispatch | WIRED | `XjRibbon.xojo_code` lines 81-93 |
| `DrawGroups` Select Case | `DrawCheckBoxItem` | `Case 3` | WIRED | `XjRibbon.xojo_code` lines 511-512 |
| `DrawGroups` Select Case | Separator no-op | `Case 4` with comment | WIRED | `XjRibbon.xojo_code` lines 513-514 |
| `LayoutTabs` ElseIf | CheckBox column batch | `ElseIf item.ItemType = 3` | WIRED | `XjRibbon.xojo_code` lines 383-405 |
| `LayoutTabs` ElseIf | Separator zero-bounds + itemX bump | `ElseIf item.ItemType = 4` | WIRED | `XjRibbon.xojo_code` lines 406-411 |
| `MainWindow.Opening` | `viewTab.AddNewGroup("Show/hide")` | `showHide` local variable | WIRED | `MainWindow.xojo_window` line 186 |
| `navPane.AddMenuItem` | `DropdownMenuAction` event | XjRibbon menu dispatch | WIRED | `MainWindow.xojo_window` lines 197-199; event handler at line ~215 |

### Data-Flow Trace (Level 4)

Not applicable — this is a Xojo Desktop Canvas project. All "data" is in-memory object state (`IsToggleActive`, `IsSplitButton`) set by user interaction events and directly consumed by paint methods on the next `Refresh`. No async fetch, store, or API involved.

### Behavioral Spot-Checks

Step 7b: SKIPPED — no runnable entry point accessible without Xojo IDE. Human verification (Task 2 checkpoint in Plan 04) was completed and approved by the user during development, covering all interactive behaviors. This approval is documented in the `05-04-SUMMARY.md`.

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|---------|
| REQ-501 | 05-01 | `IsSplitButton As Boolean` property on `XjRibbonItem` (default False) | SATISFIED | `XjRibbonItem.xojo_code` line 44 |
| REQ-502 | 05-03 | SplitButton hit-test separates body vs arrow area | SATISFIED | MouseDown line 61: `x >= ... + mBoundsW - kArrowZoneWidth`; arrow zone = 20px fixed (improved from 20% ratio — see note) |
| REQ-503 | 05-03 | SplitButton body click fires `ItemPressed` (no menu) | SATISFIED | MouseUp lines 81-83: `IsSplitButton And Not mPressedOnArrow` → `RaiseEvent ItemPressed` |
| REQ-504 | 05-03 | SplitButton arrow click opens popup menu → `DropdownMenuAction` | SATISFIED | MouseUp lines 85-93: Else branch opens menu, fires `DropdownMenuAction` |
| REQ-505 | 05-03 | SplitButton draws vertical separator line; chevron in 20% area only | SATISFIED | `DrawDropdownButton` lines 667-685: `FillRectangle(sepX, ...)` separator + chevron in `kArrowZoneWidth` zone |
| REQ-506 | 05-03 | `kItemTypeCheckBox = 3` constant | SATISFIED | `XjRibbon.xojo_code` line 1457, `Scope = Public` |
| REQ-507 | 05-03 | CheckBox draws 13×13 rounded-rect glyph | SATISFIED | `DrawCheckBoxItem` line 721: `glyphSize = 13`; FillRoundRectangle for both checked/unchecked |
| REQ-508 | 05-03 | CheckBox layout: `[13px glyph][4px gap][text]` — no icon slot | SATISFIED | `DrawCheckBoxItem` line 750: `textX = glyphX + glyphSize + kSmallButtonTextPadding` |
| REQ-509 | 05-03 | CheckBox stacks in columns of 3 | SATISFIED | `LayoutTabs` lines 387-404: `cbBatch.Count < 3` limit |
| REQ-510 | 05-03 | CheckBox click flips `IsToggleActive`, raises `ItemPressed` | SATISFIED | `AddCheckBox` sets `IsToggle=True`; existing MouseUp `IsToggle` branch handles it |
| REQ-511 | 05-03 | `kItemTypeSeparator = 4` constant | SATISFIED | `XjRibbon.xojo_code` line 1459, `Scope = Public` |
| REQ-512 | 05-03 | Separator causes layout to start new sub-column; no render, no interaction | SATISFIED | `LayoutTabs` lines 406-411: zero bounds, `itemX += kItemGap`; `DrawGroups` Case 4: no-op |
| REQ-513 | 05-02 | `XjRibbonGroup.AddSplitButton(caption, tag)` | SATISFIED | `XjRibbonGroup.xojo_code` lines 55-63 |
| REQ-514 | 05-02 | `XjRibbonGroup.AddCheckBox(caption, tag, initialState)` | SATISFIED | `XjRibbonGroup.xojo_code` lines 67-76, optional third param |
| REQ-515 | 05-02 | `XjRibbonGroup.AddSeparator()` — Sub (no return value) | SATISFIED | `XjRibbonGroup.xojo_code` lines 80-84 |
| REQ-516 | 05-04 | Demo window updated with Show/hide group and Panes group | SATISFIED | `MainWindow.xojo_window` lines 186-199 |

**All 16 requirements REQ-501 through REQ-516: SATISFIED**

### Anti-Patterns Found

| File | Pattern | Severity | Impact |
|------|---------|----------|--------|
| `XjRibbon.xojo_code` line 185 | Comment block marker uses `/ ===` instead of `// ===` (single slash) | Info | Non-functional; Xojo parses as valid comment in the window XML. Does not affect behavior. |

No TODO/FIXME/placeholder comments found in any phase 5 modified files. No empty implementations. No hardcoded empty data stubs. No `return null` patterns. All event handlers are fully wired.

Note on REQ-502/REQ-505 deviation: The plan specified an 80%/20% percentage split for the hit zone. The implementation uses `kArrowZoneWidth = 20` (fixed 20px constant). This was an intentional improvement discovered during human checkpoint (see `05-04-SUMMARY.md`, Deviation 1) — the fixed pixel approach gives consistent arrow zone width across different button widths. The observable requirement behavior (body vs arrow separation with visual separator line and chevron in arrow area) is fully satisfied. This deviation improves on the requirement, not undermines it.

### Human Verification Required

The following items require human interaction with the running Xojo application. The user has already completed these checks as part of the Plan 04 checkpoint (approved), but they are listed here for the formal record:

#### 1. SplitButton Hit-Zone Accuracy

**Test:** Run the desktop demo project. Go to the View tab. Click the LEFT portion of the "Navigation pane" button (body area).
**Expected:** No menu appears. A MessageBox shows "Ribbon item pressed: view.nav_pane". Then click the RIGHT 20px strip (arrow area). A popup menu with 3 items appears.
**Why human:** kArrowZoneWidth=20 pixel boundary requires physical click testing to confirm the threshold feels correct and the separator line is clearly visible between the two zones.

#### 2. CheckBox Glyph Toggle

**Test:** Run the demo. View tab, Show/hide group. Click "Item check boxes".
**Expected:** The glyph switches from an empty bordered square to a blue filled square with a white checkmark. MessageBox shows "Ribbon item pressed: view.checkboxes". Click again — glyph returns to empty.
**Why human:** Rendering of FillRoundRectangle + DrawLine checkmark requires visual confirmation; grep verifies code presence but not rendering correctness.

#### 3. Initially-Checked State on Launch

**Test:** Run the demo and immediately navigate to the View tab without clicking anything.
**Expected:** "Hidden items" checkbox shows a blue filled glyph with white checkmark on initial render.
**Why human:** Initial state from `AddCheckBox("Hidden items", "view.hidden", True)` requires visual confirmation on app launch.

#### 4. Separator Gap Visibility

**Test:** View tab, Show/hide group — observe the layout between the third checkbox and the "Hide selected" small button.
**Expected:** A clear gap (approximately 4px) separates the checkbox column from the small button. The separator itself has no visual element.
**Why human:** Layout gap produced by `itemX = itemX + kItemGap` requires visual confirmation that the gap is proportioned correctly and looks like the Windows File Explorer reference.

#### 5. Existing Controls Regression Check

**Test:** Navigate to the Home tab. Click large buttons, small buttons, toggle buttons. Navigate to Insert tab, click "Shapes" dropdown.
**Expected:** All controls behave identically to Phase 4 (Large buttons fire ItemPressed, Shapes opens a popup menu, toggle buttons show active state).
**Why human:** Backward compatibility of `IsSplitButton=False` code path and all pre-existing rendering logic requires runtime confirmation.

### Gaps Summary

No gaps found. All 16 requirements are satisfied in the codebase. The only human verification items are runtime visual/behavioral checks — the code paths that implement them are fully present and wired. These were already approved by the user during the Plan 04 checkpoint on 2026-04-20.

---

_Verified: 2026-04-20T18:00:00Z_
_Verifier: Claude (gsd-verifier)_
