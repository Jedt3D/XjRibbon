---
phase: 07-web-phase-5
verified: 2026-04-20T10:45:00Z
status: human_needed
score: 10/10 must-haves verified
overrides_applied: 0
human_verification:
  - test: "Open web subproject in Xojo IDE and compile — confirm zero errors"
    expected: "Project compiles without errors. No unknown-property or missing-method compile errors."
    why_human: "Xojo compilation requires the IDE — cannot grep-verify syntax correctness for all 9 changes simultaneously."
  - test: "Run in browser, navigate to View tab. Inspect the Show/hide group."
    expected: "3 checkbox items stacked vertically in one column. Unchecked items show an empty rounded-rect border (white fill, border). 'Hidden items' starts checked — blue fill + white checkmark glyph."
    why_human: "Visual rendering correctness requires a running browser session."
  - test: "Click an unchecked checkbox in the Show/hide group, then click it again."
    expected: "First click: glyph changes to blue+checkmark; ItemPressed event fires with the correct tag. Second click: glyph reverts to white+border."
    why_human: "Toggle state and event firing can only be confirmed at runtime."
  - test: "Verify the Separator gap between the checkbox column and the 'Hide selected' small button."
    expected: "A visible blank-space column gap exists between the last checkbox and the small button — no separator line is rendered (gap only)."
    why_human: "Layout gap visibility requires visual inspection in browser."
  - test: "In the Panes group, inspect the SplitButton ('Navigation pane')."
    expected: "A thin vertical separator line is visible approximately 24px from the right edge of the button. Left of the line is the body area; right is the arrow zone with a chevron."
    why_human: "Pixel-accurate rendering of the separator line requires browser inspection."
  - test: "Click the LEFT side (body area) of the SplitButton."
    expected: "No menu appears. The ItemPressed event fires with tag 'view.nav_pane'."
    why_human: "Hit-test correctness (body vs arrow zone) requires runtime click testing."
  - test: "Click the RIGHT side (arrow zone) of the SplitButton."
    expected: "A JS dropdown menu appears with 3 items: 'Navigation pane', 'Expand to open folder', 'Show all folders'. Selecting one fires DropdownMenuAction with itemTag='view.nav_pane' and the appropriate menuItemTag."
    why_human: "Dropdown menu appearance and event routing require browser runtime."
  - test: "Compare group caption font size vs item label font size across all tabs."
    expected: "Group captions ('Show/hide', 'Panes', etc.) render visibly smaller than item button labels — group captions are 10pt, item labels 11pt."
    why_human: "Font size visual difference requires human judgement in the running UI."
---

# Phase 7: Web Phase 5 Verification Report

**Phase Goal:** Port desktop Phase 5 control types (CheckBox, SplitButton, Separator) to the WebCanvas ribbon library, with full visual polish parity.
**Verified:** 2026-04-20T10:45:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|---------|
| 1 | web/XjRibbonItem has an IsSplitButton property defaulting to False | VERIFIED | `web/XjRibbonItem.xojo_code` line 43-45: `IsSplitButton As Boolean = False` between IsToggleActive and mMenuItems |
| 2 | XjRibbonGroup.AddSplitButton sets ItemType=2 and IsSplitButton=True | VERIFIED | `web/XjRibbonGroup.xojo_code` lines 55-64: method confirmed with correct assignments |
| 3 | XjRibbonGroup.AddCheckBox sets ItemType=3, IsToggle=True, IsToggleActive=initialState | VERIFIED | `web/XjRibbonGroup.xojo_code` lines 67-77: all three flag assignments present; `initialState As Boolean = False` default confirmed |
| 4 | XjRibbonGroup.AddSeparator sets ItemType=4 only | VERIFIED | `web/XjRibbonGroup.xojo_code` lines 80-85: Sub with `item.ItemType = 4` only, no Caption or Tag |
| 5 | kItemTypeCheckBox=3, kItemTypeSeparator=4, kArrowZoneWidth=24 constants present | VERIFIED | `web/XjRibbon.xojo_code` lines 1223, 1226, 1229: all three constants confirmed |
| 6 | DrawGroups dispatches Case 3 to DrawCheckBoxItem and Case 4 silently (no Separator fallthrough) | VERIFIED | Lines 516-519: `Case 3` calls `DrawCheckBoxItem(g, item)`; `Case 4` has comment-only body |
| 7 | DrawCheckBoxItem renders 16px glyph with FillRoundRectangle using exactly 5 args | VERIFIED | Lines 718-768: glyph=16, all FillRoundRectangle/DrawRoundRectangle calls have 5 args (confirmed by arg-count grep — every call in file shows count=5) |
| 8 | Pressed event SplitButton body/arrow hit-test inline via kArrowZoneWidth | VERIFIED | Line 71: `If hitItem.IsSplitButton And x < hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth Then` |
| 9 | LayoutTabs handles CheckBox batch (3-per-col), Separator bump, Else auto-expand with IsSplitButton | VERIFIED | Lines 332-376: ElseIf ItemType=3 (cbBatch loop), ElseIf ItemType=4 (itemX bump), Else branch with MeasureTextWidth auto-expand and `If item.IsSplitButton Then btnW = btnW + kArrowZoneWidth` |
| 10 | Group caption font size changed from 11 to 10 matching desktop | VERIFIED | Lines 526-528: `g.FontSize = 10` and `MeasureTextWidth(group.Caption, 10, False)` — both updated consistently |

**Score:** 10/10 truths verified

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `web/XjRibbonItem.xojo_code` | IsSplitButton property storage | VERIFIED | Line 43-45, correct position between IsToggleActive and mMenuItems, default=False |
| `web/XjRibbonGroup.xojo_code` | Three factory methods: AddSplitButton, AddCheckBox, AddSeparator | VERIFIED | Lines 54-85; all three methods present with correct signatures and property assignments |
| `web/XjRibbon.xojo_code` | All rendering, layout, hit-test, dispatch | VERIFIED | kItemTypeCheckBox/Separator constants; DrawCheckBoxItem private method; Case 3/4 dispatch; LayoutTabs branches; DrawDropdownButton SplitButton branch; DrawLargeButton polish; Pressed inline hit-test |
| `web/MainWebPage.xojo_code` | Phase 5 demo on View tab | VERIFIED | Lines 232-243: Show/hide group (3 checkboxes + separator), Panes group (SplitButton with 3 menu items) |

---

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `web/XjRibbonGroup.AddSplitButton` | `XjRibbonItem.IsSplitButton` | `item.IsSplitButton = True` | WIRED | Line 60 in XjRibbonGroup.xojo_code |
| `web/XjRibbon.DrawGroups` | `web/XjRibbon.DrawCheckBoxItem` | `Case 3` dispatch | WIRED | Line 516-517 |
| `web/XjRibbon.Pressed` | `XjRibbonItem.IsSplitButton` | inline hit-test `x < hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth` | WIRED | Line 71 |
| `web/XjRibbon.LayoutTabs` | `MeasureTextWidth` | CheckBox batch loop and Else branch auto-expand | WIRED | Lines 338, 367 |
| `web/MainWebPage.Shown` | `XjRibbonGroup.AddSplitButton` | `navGroup.AddSplitButton(...)` | WIRED | Line 243 in MainWebPage.xojo_code |
| `web/MainWebPage.Shown` | `XjRibbonGroup.AddCheckBox` | `showHide.AddCheckBox(...)` | WIRED | Lines 232, 234, 236 |

---

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|----------|---------------|--------|--------------------|--------|
| `web/XjRibbon.xojo_code` DrawCheckBoxItem | `item.IsToggleActive` | Set by `AddCheckBox(initialState)` in MainWebPage.Shown; toggled by Pressed event | Yes — real boolean driven by user click | FLOWING |
| `web/XjRibbon.xojo_code` DrawDropdownButton | `item.IsSplitButton` | Set by `AddSplitButton` factory method | Yes — real flag from factory call | FLOWING |
| `web/XjRibbon.xojo_code` LayoutTabs | `item.ItemType` | Set by all factory methods (AddCheckBox=3, AddSeparator=4, AddSplitButton=2) | Yes | FLOWING |

---

### Behavioral Spot-Checks

Step 7b: SKIPPED — Xojo web project requires IDE compilation and browser execution; no runnable CLI entry point.

---

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|---------|
| REQ-701 | 07-01 | Web XjRibbonItem gains IsSplitButton As Boolean | SATISFIED | Confirmed at line 43-45 of web/XjRibbonItem.xojo_code |
| REQ-702 | 07-03 | Web SplitButton hit-test and rendering mirrors desktop Phase 5 | SATISFIED | DrawDropdownButton IsSplitButton branch (lines 681-713); Pressed inline hit-test (line 71); LayoutTabs auto-expand (line 371) |
| REQ-703 | 07-03 | Web DrawCheckBoxItem uses g.FillRoundRectangle(x, y, w, h, 3) single corner param | SATISFIED | All 15 FillRoundRectangle/DrawRoundRectangle calls in file have exactly 5 args — arg-count grep confirmed |
| REQ-704 | 07-03 | Web kItemTypeCheckBox=3 and kItemTypeSeparator=4 added | SATISFIED | Lines 1223, 1226 of web/XjRibbon.xojo_code confirmed |
| REQ-705 | 07-02 | Web XjRibbonGroup.AddSplitButton, AddCheckBox, AddSeparator methods added | SATISFIED | Lines 55-85 of web/XjRibbonGroup.xojo_code confirmed |

**NOTE:** REQUIREMENTS.md file shows REQ-702 through REQ-705 with unchecked `[ ]` checkboxes despite implementations being present in code. This is a documentation-only gap — the REQUIREMENTS.md was not updated at phase completion. Recommend checking off REQ-702 through REQ-705 in `.planning/REQUIREMENTS.md`.

---

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `web/XjRibbon.xojo_code` | 864-875 | `mg.TextWidth` / `mg.TextHeight` in MeasureTextWidth/MeasureTextHeight helpers | INFO | These are inside dedicated helper methods that wrap a MemoryGraphics object — not WebGraphics. This is correct and intentional; the helpers exist precisely to avoid calling g.TextWidth on WebGraphics. Not a stub. |

No blockers found. No TODO/FIXME/placeholder patterns found. No empty return stubs. No hardcoded-empty data passed to rendering. All FillRoundRectangle calls use 5 args (web-correct API).

---

### Human Verification Required

The automated checks pass completely (10/10 truths verified, all artifacts substantive and wired, data flows real). Human verification is required only for runtime visual and behavioral confirmation.

#### 1. Compile Check

**Test:** Open the web subproject in Xojo IDE and compile.
**Expected:** Zero compile errors. No unknown-property or missing-method errors.
**Why human:** Xojo compilation requires the IDE.

#### 2. CheckBox Rendering

**Test:** Run in browser, navigate to View tab, inspect the Show/hide group.
**Expected:** Three checkbox items stacked vertically. Unchecked = empty rounded-rect border. "Hidden items" starts checked = blue fill + white checkmark glyph (16px).
**Why human:** Visual rendering requires a running browser session.

#### 3. CheckBox Toggle Behavior

**Test:** Click an unchecked checkbox, then click it again.
**Expected:** First click: glyph switches to blue+checkmark; ItemPressed fires with correct tag. Second click: glyph reverts to white+border.
**Why human:** Toggle state and event firing require runtime interaction.

#### 4. Separator Gap

**Test:** Inspect the gap between the checkbox column and "Hide selected" button.
**Expected:** A visible blank-space column gap — no line drawn, no interaction.
**Why human:** Layout gap visibility requires visual inspection.

#### 5. SplitButton Visual

**Test:** Inspect the "Navigation pane" SplitButton in the Panes group.
**Expected:** Thin vertical separator line ~24px from right edge; chevron in arrow zone.
**Why human:** Pixel rendering of separator line requires browser inspection.

#### 6. SplitButton Body Click

**Test:** Click the LEFT (body) area of the SplitButton.
**Expected:** No menu appears; ItemPressed fires with tag "view.nav_pane".
**Why human:** Hit-test at click-time x-coordinate requires runtime.

#### 7. SplitButton Arrow Click

**Test:** Click the RIGHT (arrow zone) of the SplitButton.
**Expected:** JS dropdown menu with 3 items appears; selecting one fires DropdownMenuAction with correct itemTag and menuItemTag.
**Why human:** Menu appearance and event routing require browser runtime.

#### 8. Group Caption Font Size

**Test:** Compare group captions vs item labels across all tabs.
**Expected:** Group captions appear visibly smaller than item labels (10pt vs 11pt).
**Why human:** Font size visual difference requires human judgement.

---

### Gaps Summary

No structural gaps found. All 10 must-haves are verified at all four levels (exists, substantive, wired, data flowing).

**Administrative gap (not a code gap):** REQUIREMENTS.md has REQ-702 through REQ-705 marked as unchecked `[ ]` even though all implementations are present and verified. The requirement tracking document was not updated at phase completion. No code changes needed — only a REQUIREMENTS.md edit to mark these complete.

**Status rationale:** Status is `human_needed` (not `passed`) because 8 runtime visual and behavioral checks were identified in Step 8 that cannot be confirmed by grep/file inspection alone. The automated verification is complete and fully passing.

---

_Verified: 2026-04-20T10:45:00Z_
_Verifier: Claude (gsd-verifier)_
