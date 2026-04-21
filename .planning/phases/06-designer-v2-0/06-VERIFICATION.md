---
phase: 06-designer-v2-0
verified: 2026-04-20T19:00:00Z
status: human_needed
score: 13/13 must-haves verified
overrides_applied: 0
human_verification:
  - test: "Open designer in Xojo IDE — verify AddItemPopup shows 8 entries including 'Ribbon SplitButton', 'Ribbon Toggle Button', 'Ribbon CheckBox'"
    expected: "Popup menu shows all 8 options; selecting each inserts a row with the correct col-1 label (Split Button / Toggle Button / CheckBox)"
    why_human: "Xojo IDE required to run the designer; AddItemPopup is a DesktopPopupMenu that is only exercisable at runtime"
  - test: "Select a SplitButton row in the designer — verify inspector panel state"
    expected: "Tag, Item Type ('Split Button'), Is Enabled, Tooltip, and Menu Items list are all enabled; 'Default Active?' checkbox is disabled"
    why_human: "Inspector control enable/disable state is only observable at runtime in the Xojo IDE"
  - test: "Select a Toggle Button row — verify inspector panel state"
    expected: "Tag, Item Type ('Toggle Button'), Is Enabled, Tooltip, and 'Default Active?' checkbox are enabled; Menu Items list is disabled"
    why_human: "Runtime UI verification required"
  - test: "Select a CheckBox row — verify inspector panel state"
    expected: "Tag, Item Type ('CheckBox'), and 'Default Active?' checkbox are enabled; Is Enabled, Tooltip, and Menu Items list are all disabled"
    why_human: "Runtime UI verification required — CheckBox has deliberately restricted inspector per spec"
  - test: "Add Toggle Button with 'Default Active?' checked, save .ribbon file, reload it"
    expected: "After reload: col-1 shows 'Toggle Button', 'Default Active?' checkbox is checked, isToggleActive:true appears in the .ribbon JSON"
    why_human: "JSON round-trip correctness requires file I/O through the designer at runtime"
  - test: "Add SplitButton with 2 menu items, click 'Copy Toolbar Code'"
    expected: "Generated code contains grpVar.AddSplitButton(...) followed by two .AddMenuItem(...) calls"
    why_human: "Code generator output verification requires clipboard inspection at runtime"
  - test: "Add Toggle Button with 'Default Active?' checked, click 'Copy Toolbar Code'"
    expected: "Generated code has .IsToggle = True and .IsToggleActive = True lines"
    why_human: "Runtime clipboard verification required"
  - test: "StatusBar at bottom of designer shows 'XjToolbar Designer version 2.0.0'"
    expected: "Version reads 2.0.0, not 1.0.0"
    why_human: "StatusBar visibility requires launching the designer in Xojo IDE"
  - test: "Help -> About box shows 'version 2.0.0'"
    expected: "About dialog shows XjRibbon Designer version 2.0.0"
    why_human: "About dialog requires runtime invocation"
---

# Phase 6: Designer v2.0 — New Control Types Verification Report

**Phase Goal:** Add SplitButton, Toggle Button, and CheckBox item types to the XjRibbon visual designer — including inspector panels, JSON schema, and code generator support.
**Verified:** 2026-04-20T19:00:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | AddItemPopup lists SplitButton, Toggle Button, CheckBox as selectable options | VERIFIED | Line 148: InitialValue has 8 entries ending `\nRibbon SplitButton\nRibbon Toggle Button\nRibbon CheckBox`; Case blocks at lines 1954, 1986, 2019 |
| 2 | Selecting a new type inserts a row with correct col-1 label and type string | VERIFIED | CellTextAt(addedRow,1) = "Split Button"/"Toggle Button"/"CheckBox" at lines 1973, 2005, 2038; d.Value("type") = "splitbutton"/"toggle"/"checkbox" at lines 1976, 2008, 2041 |
| 3 | CascadeTagUpdate applies auto-tag generation to all 5 item types | VERIFIED | All three branches extended at lines 998, 1037, 1059 to include splitbutton, toggle, checkbox |
| 4 | UpdateDropdownColumn shows menu item count for splitbutton rows | VERIFIED | Line 1747: guard is `<> "large" And d.Value("type") <> "splitbutton"` |
| 5 | IsToggleActive "Default Active?" control exists in inspector GroupBox1 | VERIFIED | Lines 464-484: `Begin DesktopCheckBox IsToggleActive`, Caption "Default Active?", InitialParent "GroupBox1" |
| 6 | SetInspectorState enables/disables controls correctly for all 5 item types | VERIFIED | Lines 1671-1695: hasToggleState, hasIsEnabled, isLarge (includes splitbutton) declared; IsToggleActive.Enabled = hasToggleState at line 1695; MenuItems.Enabled = isLarge at line 1702 |
| 7 | PopulateInspector fills all fields for all 5 item types including isToggleActive | VERIFIED | Lines 1511-1525: Select Case rowType with all 5 cases; IsToggleActive.Value = d.Lookup("isToggleActive", False) at line 1525; MenuItems loaded for large + splitbutton at lines 1527-1535 |
| 8 | IsToggleActive.ValueChanged persists to row Dictionary | VERIFIED | Line 2095: `#tag Events IsToggleActive`; line 2106: `d.Value("isToggleActive") = Me.Value` with mUpdatingInspector guard |
| 9 | BuildJSON emits isToggleActive field for toggle and checkbox rows | VERIFIED | Lines 950-951: `If id.Value("type") = "toggle" Or id.Value("type") = "checkbox" Then` / `itemObj.Value("isToggleActive") = id.Lookup("isToggleActive", False)` |
| 10 | LoadFromJSON uses Select Case for col-1 labels covering all 5 types | VERIFIED | Line 1352: `Select Case iType`; Cases at lines 1353-1364 for large/small/splitbutton/toggle/checkbox plus Else fallback; old binary If/Else gone |
| 11 | LoadFromJSON parses isToggleActive field | VERIFIED | Line 1374: `id.Value("isToggleActive") = itemObj.Lookup("isToggleActive", False)` |
| 12 | GenerateCode produces correct Xojo API calls for all 3 new types | VERIFIED | Line 1186: `Case "large", "small"`; line 1225: `Case "splitbutton"` with AddSplitButton at 1232; line 1245: `Case "toggle"` with .IsToggle=True at 1253; line 1264: `Case "checkbox"` with both Var and Call forms at 1270/1272; old If block gone |
| 13 | Version bumped to 2.0.0 in StatusBar, AboutBox, GenerateCode header, BuildJSON schema | VERIFIED | Line 222: StatusBar "version 2.0.0"; AboutBox line 79: "version 2.0.0"; line 1145: GenerateCode "v2.0.0"; line 906: root.Value("version")="2.0"; zero occurrences of 1.0.0 or "1.0" remain |

**Score:** 13/13 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `designer/MainWindow.xojo_window` | All Phase 6 changes: AddItemPopup, inspector, JSON, code gen, version | VERIFIED | All changes confirmed by grep at expected lines; all 10 commits from plans 01-05 present |
| `designer/AboutBox.xojo_window` | CopyrightLabel "version 2.0.0" | VERIFIED | Line 79 confirmed; no 1.0.0 remains |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| AddItemPopup.SelectionChanged | RibbonStructure.RowTagAt | d.Value("type") = "splitbutton"/"toggle"/"checkbox" | WIRED | Lines 1976, 2008, 2041 |
| CascadeTagUpdate (3 branches) | item rows by type | rowType/ct includes all 5 types | WIRED | Lines 998, 1037, 1059 |
| SetInspectorState | IsToggleActive.Enabled | hasToggleState variable | WIRED | Lines 1673, 1695 |
| PopulateInspector | RibbonStructure.RowTagAt Dictionary | d.Lookup("isToggleActive", False) | WIRED | Line 1525 |
| IsToggleActive.ValueChanged | RibbonStructure.RowTagAt Dictionary | d.Value("isToggleActive") = Me.Value | WIRED | Line 2106 |
| BuildJSON | .ribbon JSON file | itemObj.Value("isToggleActive") guarded by toggle/checkbox | WIRED | Lines 950-951 |
| LoadFromJSON | RibbonStructure col-1 + Dictionary | Select Case iType + id.Value("isToggleActive") | WIRED | Lines 1352-1374 |
| GenerateCode | Clipboard output | Select Case it with splitbutton/toggle/checkbox cases | WIRED | Lines 1225, 1245, 1264 |
| StatusBar.Text | User-visible version | "version 2.0.0" property | WIRED | Line 222 |
| BuildJSON root | .ribbon JSON schema | root.Value("version") = "2.0" | WIRED | Line 906 |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|----------|---------------|--------|--------------------|--------|
| MainWindow inspector (IsToggleActive) | isToggleActive | RowTagAt Dictionary via d.Lookup | Yes — written by ValueChanged event, loaded by PopulateInspector | FLOWING |
| BuildJSON | itemObj | RibbonStructure row Dictionaries (in-app data) | Yes — reads real id.Value("type") and id.Lookup("isToggleActive") | FLOWING |
| LoadFromJSON | id Dictionary | itemObj from parsed JSONItem | Yes — reads real itemObj.Value("itemType") and itemObj.Lookup("isToggleActive") | FLOWING |
| GenerateCode | code string | RibbonStructure row Dictionaries | Yes — reads id.Value("type"), id.Value("caption"), id.Lookup("tag"), id.Lookup("isToggleActive") | FLOWING |

### Behavioral Spot-Checks

Step 7b: SKIPPED — Xojo project has no runnable entry points outside the Xojo IDE. All behavioral verification routes to human testing below.

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| REQ-601 | 06-01 | AddItemPopup lists SplitButton, Toggle Button, CheckBox | SATISFIED | InitialValue line 148; 3 Case blocks in SelectionChanged |
| REQ-602 | 06-01, 06-03 | .ribbon JSON schema supports "splitbutton"/"toggle"/"checkbox" itemType | SATISFIED | BuildJSON writes itemType via id.Value("type"); LoadFromJSON Select Case iType handles all 3 |
| REQ-603 | 06-03 | BuildJSON and LoadFromJSON handle new item types | SATISFIED | Lines 946, 950-951 (BuildJSON); 1351-1374 (LoadFromJSON) |
| REQ-604 | 06-02 | Inspector for SplitButton: identical to Dropdown (has MenuItem list) | SATISFIED | isLarge includes splitbutton (line 1672); MenuItems loaded for splitbutton (line 1529) |
| REQ-605 | 06-02 | Inspector for Toggle Button: same as Large Button + "Default Active?" checkbox | SATISFIED | hasIsEnabled includes toggle (line 1674); hasToggleState enables IsToggleActive (line 1673) |
| REQ-606 | 06-02 | Inspector for CheckBox: Caption, Tag, Default Checked, Tooltip excluded | SATISFIED | hasIsEnabled excludes checkbox (line 1674); only hasToggleState and isItem apply |
| REQ-607 | 06-04 | Code generator handles splitbutton, toggle, checkbox cases | SATISFIED | Select Case at lines 1225, 1245, 1264 with AddSplitButton/IsToggle/AddCheckBox output |
| REQ-608 | 06-05 | Version bumped to 2.0.0 in StatusBar and AboutBox | SATISFIED | Lines 222 (StatusBar), AboutBox line 79; also GenerateCode header and BuildJSON schema |

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| MainWindow.xojo_window | 1854, 2052 | Comments mention "placeholder" (referring to the "-- select item --" popup placeholder, not code stubs) | Info | Not a code stub — these comments correctly describe the UI placeholder entry in the popup menu |

No blockers. The two "placeholder" hits are comments describing the intentional "-- select item --" entry in AddItemPopup, not implementation stubs.

### Human Verification Required

All automated checks passed. The following items require launching the designer in Xojo IDE:

#### 1. AddItemPopup Runtime Display

**Test:** Open designer → click the AddItemPopup → scroll the list
**Expected:** 8 items visible ending with "Ribbon SplitButton", "Ribbon Toggle Button", "Ribbon CheckBox"
**Why human:** Xojo DesktopPopupMenu is only rendered at runtime in the Xojo IDE

#### 2. Inspector State — SplitButton Row

**Test:** Add a SplitButton row, select it, examine the inspector GroupBox1
**Expected:** Tag, Item Type shows "Split Button", Is Enabled checkbox active, Tooltip field active, Menu Items listbox active; "Default Active?" checkbox disabled
**Why human:** Control enabled/disabled state is runtime UI behavior

#### 3. Inspector State — Toggle Button Row

**Test:** Add a Toggle Button row, select it, examine inspector
**Expected:** Tag, Item Type "Toggle Button", Is Enabled, Tooltip, and "Default Active?" are all active; Menu Items listbox is disabled
**Why human:** Runtime UI verification required

#### 4. Inspector State — CheckBox Row

**Test:** Add a CheckBox row, select it, examine inspector
**Expected:** Tag, Item Type "CheckBox", and "Default Active?" are active; Is Enabled, Tooltip, and Menu Items are disabled
**Why human:** Runtime UI verification required; per spec CheckBox has restricted inspector

#### 5. JSON Round-Trip

**Test:** Add a Toggle Button, check "Default Active?", File > Save, then File > Load
**Expected:** After reload col-1 shows "Toggle Button", "Default Active?" is checked, raw JSON contains `"isToggleActive":true`
**Why human:** File I/O and UI state persistence requires designer runtime

#### 6. Code Generator — SplitButton Output

**Test:** Add SplitButton with 2 menu items ("Save", "Save As"), click "Copy Toolbar Code", paste
**Expected:** Code contains `.AddSplitButton(...)` followed by two `.AddMenuItem(...)` lines
**Why human:** Clipboard content only accessible at runtime

#### 7. Code Generator — Toggle Button Output

**Test:** Add Toggle Button, check "Default Active?", click "Copy Toolbar Code"
**Expected:** Code has `.IsToggle = True` and `.IsToggleActive = True`
**Why human:** Clipboard content only accessible at runtime

#### 8. Version Display

**Test:** Launch designer — check StatusBar and Help > About
**Expected:** StatusBar shows "XjToolbar Designer version 2.0.0"; About dialog shows "version 2.0.0"
**Why human:** StatusBar and About dialog are runtime-only UI surfaces

### Gaps Summary

No gaps found. All 13 observable truths are VERIFIED by direct code inspection. All 8 requirements (REQ-601 through REQ-608) are satisfied by code evidence.

The only open items are 9 human verification tests that require the Xojo IDE to run the designer at runtime. These are standard runtime-only behaviors (popup menus, inspector UI state, file I/O, clipboard) that cannot be verified by static file inspection.

---

_Verified: 2026-04-20T19:00:00Z_
_Verifier: Claude (gsd-verifier)_
