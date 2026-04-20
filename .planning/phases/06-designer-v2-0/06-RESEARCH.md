# Phase 6: Designer v2.0 - Research

**Researched:** 2026-04-20
**Domain:** Xojo Designer — MainWindow.xojo_window code patterns
**Confidence:** HIGH (all findings verified by direct source-file inspection)

---

## Summary

Phase 6 adds three new ribbon item types (SplitButton, Toggle Button, CheckBox) to the
visual designer tool. All logic lives in a single file: `designer/MainWindow.xojo_window`.
The existing code is well-structured with clear extension points in five areas: the AddItemPopup
menu, the AddItemPopup.SelectionChanged Case block, PopulateInspector/SetInspectorState,
GenerateCode, and BuildJSON/LoadFromJSON. Each area requires targeted additions; no existing
logic needs to be deleted or restructured.

**Primary recommendation:** Implement in order: (1) popup menu + dictionary schema, (2) AddItemPopup
Case block, (3) SetInspectorState + PopulateInspector, (4) GenerateCode, (5) BuildJSON/LoadFromJSON,
(6) version strings. Each step is independently testable.

---

## User Constraints (from DEV_PLAN.md Locked Decisions)

### Locked Decisions
1. AddItemPopup gains exactly 3 new entries: `"Ribbon SplitButton"`, `"Ribbon Toggle Button"`, `"Ribbon CheckBox"`
2. JSON `itemType` gains `"splitbutton"` | `"toggle"` | `"checkbox"`; toggle/checkbox get `"isToggleActive"` boolean field
3. BuildJSON and LoadFromJSON handle new types
4. Inspector for SplitButton: identical to Dropdown (has MenuItem list)
5. Inspector for Toggle Button: same as Large Button + "Default Active?" checkbox
6. Inspector for CheckBox: Caption, Tag, Default Checked (isToggleActive), Tooltip — no MenuItems
7. Code generator: new Case blocks for `"splitbutton"`, `"toggle"`, `"checkbox"`
8. Version bumped to `2.0.0` in StatusBar + AboutBox

### Deferred Ideas (OUT OF SCOPE)
- Designer v3.0 Live Preview pane
- Separator item in designer (Phase 5 desktop only)

---

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| REQ-601 | AddItemPopup lists SplitButton, Toggle Button, CheckBox | See AddItemPopup InitialValue and SelectionChanged patterns |
| REQ-602 | JSON schema supports new itemType strings | See BuildJSON/LoadFromJSON patterns |
| REQ-603 | BuildJSON and LoadFromJSON handle new types | See exact serialization patterns below |
| REQ-604 | Inspector for SplitButton identical to Dropdown | See SetInspectorState isLarge pattern |
| REQ-605 | Inspector for Toggle Button = Large + "Default Active?" checkbox | Requires new DesktopCheckBox control |
| REQ-606 | Inspector for CheckBox: Caption, Tag, Default Checked, Tooltip, no MenuItems | Requires reuse of IsEnabled control or new control |
| REQ-607 | Code generator handles new type cases | See GenerateCode current Case structure |
| REQ-608 | Version bumped to 2.0.0 | See exact property locations below |

---

## Area 1: AddItemPopup — Current State

### Current InitialValue (line 148)
```
"-- select item --\nRibbon Tab\nRibbon Group\nRibbon Large Button\nRibbon Small Button"
```

**VERIFIED: direct file read, line 148**

This is a `DesktopPopupMenu` control. Items are set via the `InitialValue` property using `\n` as separators in the Xojo IDE property string. There is NO "Ribbon Dropdown Button" entry in the popup — dropdown behavior is handled automatically by the code generator when a Large Button has menu items.

### Current SelectionChanged Case block (lines 1740-1835)
```
Select Case selectedText
Case "Ribbon Tab"      → type="tab", depth=0, CellText col1="Tab"
Case "Ribbon Group"    → type="group", depth=1, CellText col1="Group"
Case "Ribbon Large Button", "Ribbon Small Button"
                       → type="large"/"small", depth=2, CellText col1="Large Button"/"Small Button"
End Select
```

### Insertion point for new types
Add to `InitialValue` (3 new `\n`-separated items after "Ribbon Small Button"):
```
\nRibbon SplitButton\nRibbon Toggle Button\nRibbon CheckBox
```

Add 3 new `Case` blocks inside `SelectionChanged`, before `End Select` at line 1835.

---

## Area 2: RibbonStructure Listbox — Row Data Model

**VERIFIED: direct file read, multiple locations**

The listbox has 3 columns:
- Col 0: Caption (editable TextField)
- Col 1: Type label string (e.g. "Tab", "Group", "Large Button", "Small Button")
- Col 2: "Dropdown" count (menu item count, integer string, only for rows with menuItems)

Each row carries a `Dictionary` as its `RowTagAt` value. The Dictionary has these keys:

| Key | Types that use it | Value type |
|-----|-------------------|------------|
| `"type"` | ALL rows | String: `"tab"`, `"group"`, `"large"`, `"small"` |
| `"caption"` | ALL rows | String |
| `"tag"` | item rows only | String |
| `"isEnabled"` | item rows only | Boolean (default True) |
| `"tooltipText"` | item rows only | String |
| `"menuItems"` | item rows only | `Dictionary()` array (each: `"caption"`, `"tag"`) |

**Existing `"type"` string values in use:** `"tab"`, `"group"`, `"large"`, `"small"` — VERIFIED.

**Note:** There is no `"dropdown"` type string. Dropdown behavior is inferred at code-gen time from `it = "large" And hasMI`. This is a critical design detail: the v1.0 designer has NO explicit dropdown type. DEV_PLAN.md extends this with explicit new type strings: `"splitbutton"`, `"toggle"`, `"checkbox"`.

### New row data for each type

For **SplitButton** (type=`"splitbutton"`, depth=2, Col1=`"Split Button"`):
```
d.Value("type") = "splitbutton"
d.Value("caption") = "New SplitButton"
d.Value("tag") = autoTag
d.Value("isEnabled") = True
d.Value("tooltipText") = ""
d.Value("menuItems") = emptyMenuItems  // array, same as large
```

For **Toggle Button** (type=`"toggle"`, depth=2, Col1=`"Toggle Button"`):
```
d.Value("type") = "toggle"
d.Value("caption") = "New Toggle Button"
d.Value("tag") = autoTag
d.Value("isEnabled") = True
d.Value("tooltipText") = ""
d.Value("isToggleActive") = False   // NEW field
Var emptyMenuItems() As Dictionary
d.Value("menuItems") = emptyMenuItems  // still carried (no MenuItems shown in inspector, but kept for schema consistency)
```

For **CheckBox** (type=`"checkbox"`, depth=2, Col1=`"CheckBox"`):
```
d.Value("type") = "checkbox"
d.Value("caption") = "New CheckBox"
d.Value("tag") = autoTag
d.Value("isToggleActive") = False   // NEW field
// Note: no isEnabled, no tooltipText, no menuItems per DEV_PLAN spec
```

---

## Area 3: SetInspectorState and PopulateInspector

### SetInspectorState current logic (lines 1552-1598)

```xojo
Sub SetInspectorState(rowType As String)
  Var isTab As Boolean = (rowType = "tab")
  Var isGroup As Boolean = (rowType = "group")
  Var isItem As Boolean = (rowType = "large" Or rowType = "small")
  Var isLarge As Boolean = (rowType = "large")
  Var anythingSelected As Boolean = (rowType <> "none")
  
  CaptionField.Enabled = anythingSelected         // all types
  Label4.Enabled = anythingSelected
  
  TagField.Enabled = isItem                       // item types only
  Label5.Enabled = isItem
  ItemTypeField.Enabled = isItem
  Label6.Enabled = isItem
  IsEnabled.Enabled = isItem
  TooltipTextField.Enabled = isItem
  Label8.Enabled = isItem
  
  ResourceNameField.Enabled = False               // always disabled
  Label10.Enabled = False
  
  MenuItems.Enabled = isLarge                     // large only
  AddMenuItem.Enabled = isLarge
  Label11.Enabled = isLarge
  
  // Clear fields when nothing selected
  If Not anythingSelected Then ...
End Sub
```

**VERIFIED: direct file read, lines 1552-1598**

### Inspector controls that exist in the UI (VERIFIED)

| Control name | Type | Top position | Purpose |
|---|---|---|---|
| `CaptionField` | DesktopTextField | top=88 | Caption |
| `Label4` | DesktopLabel | top=88 | "Caption" label |
| `TagField` | DesktopTextField | top=122 | Tag |
| `Label5` | DesktopLabel | top=120 | "Tag" label |
| `ItemTypeField` | DesktopTextField (ReadOnly) | top=152 | Read-only display of type |
| `Label6` | DesktopLabel | top=152 | "Item Type" label |
| `IsEnabled` | DesktopCheckBox | top=184 | "Is Enabled?" |
| `TooltipTextField` | DesktopTextField | top=216 | Tooltip text |
| `Label8` | DesktopLabel | top=216 | "Tooltip Text" label |
| `ResourceNameField` | DesktopTextField | top=248 | (disabled, deferred) |
| `Label10` | DesktopLabel | top=250 | "Resource Name" label |
| `Label11` | DesktopLabel | top=280 | "Menu Item" label |
| `MenuItems` | DesktopListBox | top=312, h=170 | Menu item list |
| `AddMenuItem` | DesktopButton | top=280 | "Add Menu Item" button |

**Key finding:** There is NO existing "Default Active?" or "isToggleActive" checkbox control in the UI. Adding Toggle Button and CheckBox inspectors requires either repurposing the `IsEnabled` checkbox or adding a new `DesktopCheckBox` control to the window layout.

**Recommended approach (from DEV_PLAN.md spec):** Add a new `DesktopCheckBox` named `IsToggleActive` to the Inspector GroupBox. The `IsEnabled` checkbox stays for types that use it (large, small, splitbutton, toggle — but CheckBox type per spec does not need IsEnabled).

### Changes needed to SetInspectorState

Extend the boolean variables:
```xojo
Var isItem As Boolean = (rowType = "large" Or rowType = "small" Or rowType = "splitbutton" Or rowType = "toggle" Or rowType = "checkbox")
Var isLarge As Boolean = (rowType = "large" Or rowType = "splitbutton")   // SplitButton gets MenuItem list
Var hasToggleState As Boolean = (rowType = "toggle" Or rowType = "checkbox")
Var hasIsEnabled As Boolean = (rowType = "large" Or rowType = "small" Or rowType = "splitbutton" Or rowType = "toggle")
// Note: CheckBox has no IsEnabled per spec
```

Then enable/disable new `IsToggleActive` checkbox:
```xojo
IsToggleActive.Enabled = hasToggleState
```

And narrow `IsEnabled` to `hasIsEnabled` instead of `isItem`.

### Changes needed to PopulateInspector

Current block (lines 1412-1443) only handles `"large"` and `"small"`. Must be extended:

```xojo
If rowType = "large" Or rowType = "small" Or rowType = "splitbutton" Or rowType = "toggle" Or rowType = "checkbox" Then
  TagField.Text = d.Lookup("tag", "")
  // ItemTypeField display text:
  Select Case rowType
  Case "large":       ItemTypeField.Text = "Large Button"
  Case "small":       ItemTypeField.Text = "Small Button"
  Case "splitbutton": ItemTypeField.Text = "Split Button"
  Case "toggle":      ItemTypeField.Text = "Toggle Button"
  Case "checkbox":    ItemTypeField.Text = "CheckBox"
  End Select
  IsEnabled.Value = d.Lookup("isEnabled", True)
  TooltipTextField.Text = d.Lookup("tooltipText", "")
  IsToggleActive.Value = d.Lookup("isToggleActive", False)  // new
  
  MenuItems.RemoveAllRows
  If rowType = "large" Or rowType = "splitbutton" Then   // MenuItem list
    Var items() As Dictionary = d.Lookup("menuItems", Nil)
    If items <> Nil Then
      For Each mi As Dictionary In items
        MenuItems.AddRow(mi.Lookup("caption", ""), mi.Lookup("tag", ""))
        MenuItems.CellTypeAt(MenuItems.LastAddedRowIndex, 0) = DesktopListBox.CellTypes.TextField
        MenuItems.CellTypeAt(MenuItems.LastAddedRowIndex, 1) = DesktopListBox.CellTypes.TextField
      Next
    End If
  End If
End If
```

### New event handler needed: IsToggleActive.ValueChanged

Same pattern as IsEnabled.ValueChanged (lines 1866-1880):
```xojo
Sub ValueChanged()
  If mUpdatingInspector Then Return
  Var row As Integer = RibbonStructure.SelectedRowIndex
  If row < 0 Then Return
  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
  If d = Nil Then Return
  d.Value("isToggleActive") = Me.Value
  MarkDirty
End Sub
```

---

## Area 4: GenerateCode — Current Structure

**VERIFIED: direct file read, lines 1103-1201**

### Current traversal pattern

```xojo
Function GenerateCode() As String
  // Header comment uses: "// Generated by XjRibbon Designer v1.0.0"
  
  // Outer loop: tabs
  While i < RibbonStructure.RowCount
    // tabVar = UniqueVarName(SanitizeVarName(tabCaption) + "Tab", usedNames)
    // code += "Var " + tabVar + " As XjRibbonTab = Me.AddTab(...)"
    
    // Inner loop: groups
    While j < RibbonStructure.RowCount
      // grpVar = UniqueVarName(SanitizeVarName(grpCaption) + "Group", usedNames)
      // code += "Var " + grpVar + " As XjRibbonGroup = " + tabVar + ".AddNewGroup(...)"
      
      // Innermost loop: items
      While k < RibbonStructure.RowCount
        Var it As String = id.Value("type")
        If it = "tab" Or it = "group" Then Exit   // boundary check
        
        If it = "large" Or it = "small" Then
          // Variables used:
          //   cap       = id.Value("caption")
          //   tag       = id.Lookup("tag", "")
          //   tip       = id.Lookup("tooltipText", "")
          //   enabled   = id.Lookup("isEnabled", True)
          //   miList()  = id.Lookup("menuItems", Nil)
          //   hasMI     = (miList <> Nil And miList.Count > 0)
          //   isDropdown = (it = "large" And hasMI)   ← CRITICAL: current dropdown detection
          //   hasExtras  = (tip <> "" Or Not enabled Or isDropdown)
          //   itemVar   = UniqueVarName(SanitizeVarName(cap) + "Item", usedNames)
          
          If isDropdown Then
            code += "Var " + itemVar + " As XjRibbonItem = " + grpVar + ".AddDropdownButton(...)"
          ElseIf hasExtras Then
            code += "Var " + itemVar + " As XjRibbonItem = " + grpVar + ".AddLargeButton/AddSmallButton(...)"
          Else
            code += "Call " + grpVar + ".AddLargeButton/AddSmallButton(...)"
          End If
          
          If tip <> "" Then  code += itemVar + ".TooltipText = ..."
          If Not enabled Then code += itemVar + ".IsEnabled = False"
          If isDropdown Then
            For Each mi ...
              code += itemVar + ".AddMenuItem(...)"
            Next
          End If
        End If
        k = k + 1
      Wend
    Wend
  Wend
End Function
```

### Insertion point for new types

The boundary check `If it = "tab" Or it = "group" Then Exit` must remain unchanged.

The current `If it = "large" Or it = "small" Then` block becomes a multi-branch structure.
Add new branches after the existing `If it = "large" Or it = "small" Then` block, before `End If` closing that block — OR restructure as a `Select Case it`:

**Recommended: restructure as Select Case (cleaner for 5 types):**

```xojo
Select Case it
Case "large", "small"
  // ... existing large/small logic (unchanged) ...

Case "splitbutton"
  Var cap As String = id.Value("caption")
  Var tag As String = id.Lookup("tag", "")
  Var tip As String = id.Lookup("tooltipText", "")
  Var enabled As Boolean = id.Lookup("isEnabled", True)
  Var miList() As Dictionary = id.Lookup("menuItems", Nil)
  Var itemVar As String = UniqueVarName(SanitizeVarName(cap) + "Item", usedNames)
  code = code + "Var " + itemVar + " As XjRibbonItem = " + grpVar + ".AddSplitButton(""" + cap + """, """ + tag + """)" + eol
  If tip <> "" Then code = code + itemVar + ".TooltipText = """ + tip + """" + eol
  If Not enabled Then code = code + itemVar + ".IsEnabled = False" + eol
  If miList <> Nil Then
    For Each mi As Dictionary In miList
      code = code + itemVar + ".AddMenuItem(""" + mi.Value("caption").StringValue + """, """ + mi.Value("tag").StringValue + """)" + eol
    Next
  End If

Case "toggle"
  Var cap As String = id.Value("caption")
  Var tag As String = id.Lookup("tag", "")
  Var tip As String = id.Lookup("tooltipText", "")
  Var enabled As Boolean = id.Lookup("isEnabled", True)
  Var isActive As Boolean = id.Lookup("isToggleActive", False)
  Var itemVar As String = UniqueVarName(SanitizeVarName(cap) + "Item", usedNames)
  code = code + "Var " + itemVar + " As XjRibbonItem = " + grpVar + ".AddLargeButton(""" + cap + """, """ + tag + """)" + eol
  code = code + itemVar + ".IsToggle = True" + eol
  If isActive Then code = code + itemVar + ".IsToggleActive = True" + eol
  If tip <> "" Then code = code + itemVar + ".TooltipText = """ + tip + """" + eol
  If Not enabled Then code = code + itemVar + ".IsEnabled = False" + eol

Case "checkbox"
  Var cap As String = id.Value("caption")
  Var tag As String = id.Lookup("tag", "")
  Var isActive As Boolean = id.Lookup("isToggleActive", False)
  If isActive Then
    code = code + "Var " + UniqueVarName(SanitizeVarName(cap) + "Item", usedNames) + " As XjRibbonItem = " + grpVar + ".AddCheckBox(""" + cap + """, """ + tag + """, True)" + eol
  Else
    code = code + "Call " + grpVar + ".AddCheckBox(""" + cap + """, """ + tag + """)" + eol
  End If

End Select
```

**Note:** The `"// Generated by XjRibbon Designer v1.0.0"` header string (line 1110) must be updated to `v2.0.0`.

---

## Area 5: BuildJSON — Current Serialization Pattern

**VERIFIED: direct file read, lines 872-951**

```xojo
Function BuildJSON() As String
  Var root As New JSONItem
  root.Value("version") = "1.0"           // ← bump to "2.0"
  root.Value("projectType") = "desktop"|"web"
  
  // Per-item serialization (lines 910-930):
  Var itemObj As New JSONItem
  itemObj.Value("caption") = id.Value("caption")
  itemObj.Value("tag") = id.Lookup("tag", "")
  itemObj.Value("itemType") = id.Value("type")     // ← writes type string as itemType
  itemObj.Value("isEnabled") = id.Lookup("isEnabled", True)
  itemObj.Value("tooltipText") = id.Lookup("tooltipText", "")
  
  // menuItems array always written (empty array for small buttons)
  Var menuItemsArr As New JSONItem("[]")
  Var miList() As Dictionary = id.Lookup("menuItems", Nil)
  If miList <> Nil Then
    For Each mi As Dictionary In miList
      Var miObj As New JSONItem
      miObj.Value("caption") = mi.Lookup("caption", "")
      miObj.Value("tag") = mi.Lookup("tag", "")
      menuItemsArr.Add(miObj)
    Next
  End If
  itemObj.Value("menuItems") = menuItemsArr
  items.Add(itemObj)
```

### What BuildJSON needs for new types

The current `itemObj.Value("itemType") = id.Value("type")` line ALREADY handles the new types correctly — it just copies the type string from the Dictionary. No change needed to that line.

**What IS needed:**
- Add `"isToggleActive"` field for toggle and checkbox types:
  ```xojo
  If id.Value("type") = "toggle" Or id.Value("type") = "checkbox" Then
    itemObj.Value("isToggleActive") = id.Lookup("isToggleActive", False)
  End If
  ```
- Bump version string: `root.Value("version") = "2.0"` (line 875)
- CheckBox has no menuItems in the inspector, but BuildJSON always writes the menuItems array — this is fine (empty array).

---

## Area 6: LoadFromJSON — Current Parsing Pattern

**VERIFIED: direct file read, lines 1213-1297**

```xojo
Sub LoadFromJSON(jsonString As String)
  // Per-item parsing (lines 1264-1293):
  Var iType As String = itemObj.Value("itemType")
  If iType = "large" Then
    RibbonStructure.CellTextAt(itemRow, 1) = "Large Button"
  Else
    RibbonStructure.CellTextAt(itemRow, 1) = "Small Button"   // ← all non-"large" become "Small Button"!
  End If
  
  Var id As New Dictionary
  id.Value("type") = iType
  id.Value("caption") = itemObj.Value("caption")
  id.Value("tag") = itemObj.Lookup("tag", "")
  id.Value("isEnabled") = itemObj.Lookup("isEnabled", True)
  id.Value("tooltipText") = itemObj.Lookup("tooltipText", "")
  
  // menuItems parsed always
  Var miArr() As Dictionary
  Var menuItemsJSON As JSONItem = itemObj.Lookup("menuItems", Nil)
  If menuItemsJSON <> Nil Then
    For miIdx ... miArr.Add(mi)
    Next
  End If
  id.Value("menuItems") = miArr
  
  RibbonStructure.RowTagAt(itemRow) = id
  UpdateDropdownColumn(itemRow)
```

**Critical finding:** The current `If iType = "large" Then ... Else "Small Button"` logic is a bug for new types — every non-"large" type would show "Small Button" in col 1. This MUST be extended.

### Changes needed to LoadFromJSON

Replace the binary `If/Else` with a `Select Case`:
```xojo
Select Case iType
Case "large":       RibbonStructure.CellTextAt(itemRow, 1) = "Large Button"
Case "small":       RibbonStructure.CellTextAt(itemRow, 1) = "Small Button"
Case "splitbutton": RibbonStructure.CellTextAt(itemRow, 1) = "Split Button"
Case "toggle":      RibbonStructure.CellTextAt(itemRow, 1) = "Toggle Button"
Case "checkbox":    RibbonStructure.CellTextAt(itemRow, 1) = "CheckBox"
Else                RibbonStructure.CellTextAt(itemRow, 1) = iType  // fallback
End Select
```

Also add `isToggleActive` field parsing:
```xojo
id.Value("isToggleActive") = itemObj.Lookup("isToggleActive", False)
```

---

## Area 7: UpdateDropdownColumn — Impact Analysis

**VERIFIED: direct file read, lines 1623-1638**

```xojo
Sub UpdateDropdownColumn(row As Integer)
  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
  If d = Nil Then Return
  If d.Value("type") <> "large" Then     // ← only shows count for "large"
    RibbonStructure.CellTextAt(row, 2) = ""
    Return
  End If
  Var items() As Dictionary = d.Lookup("menuItems", Nil)
  If items <> Nil And items.Count > 0 Then
    RibbonStructure.CellTextAt(row, 2) = Str(items.Count)
  Else
    RibbonStructure.CellTextAt(row, 2) = ""
  End If
End Sub
```

This must be extended to show menu item count for `"splitbutton"` as well:
```xojo
If d.Value("type") <> "large" And d.Value("type") <> "splitbutton" Then
```

---

## Area 8: CascadeTagUpdate — Impact Analysis

**VERIFIED: direct file read, lines 954-1037**

```xojo
If rowType = "large" Or rowType = "small" Then
  // updates own tag, cascades to menu items

ElseIf rowType = "group" Then
  For i ...
    If ct = "large" Or ct = "small" Then
      // updates child item tags
    End If
  Next

ElseIf rowType = "tab" Then
  For i ...
    If (ct = "large" Or ct = "small") And currentGroupCaption <> "" Then
      // updates descendant item tags
    End If
  Next
End If
```

**All three branches** check for `"large" Or "small"` to identify item rows. These must be extended to include `"splitbutton"`, `"toggle"`, `"checkbox"` so tag auto-generation works for new types:

Replace every occurrence of `ct = "large" Or ct = "small"` with:
```xojo
ct = "large" Or ct = "small" Or ct = "splitbutton" Or ct = "toggle" Or ct = "checkbox"
```

Also the first branch `If rowType = "large" Or rowType = "small" Then` must include new types.

---

## Area 9: Version String Locations

**VERIFIED: direct file read**

| Location | File | Line | Current Value | New Value |
|----------|------|------|---------------|-----------|
| StatusBar control `Text` property | `MainWindow.xojo_window` | 222 | `"XjToolbar Designer version 1.0.0"` | `"XjToolbar Designer version 2.0.0"` |
| AboutBox `CopyrightLabel` control `Text` property | `AboutBox.xojo_window` | 79 | `"XjRibbon Designer\nversion 1.0.0\n\n..."` | `"XjRibbon Designer\nversion 2.0.0\n\n..."` |
| GenerateCode header comment | `MainWindow.xojo_window` | 1110 | `"// Generated by XjRibbon Designer v1.0.0"` | `"// Generated by XjRibbon Designer v2.0.0"` |
| BuildJSON version field | `MainWindow.xojo_window` | 875 | `root.Value("version") = "1.0"` | `root.Value("version") = "2.0"` |

---

## New Control Required: IsToggleActive Checkbox

The inspector GroupBox (`GroupBox1`) currently has no control for `isToggleActive`. A new `DesktopCheckBox` must be added to the window layout.

**Suggested placement:** Below `IsEnabled` (which is at top=184). New control at top=216 would conflict with `TooltipTextField`. Options:

Option A: Place `IsToggleActive` at top=248 (overlapping `ResourceNameField` area which is always disabled).
Option B: Rearrange inspector layout to make room.

**Recommended:** Given ResourceNameField is always disabled ("deferred"), place `IsToggleActive` at the same top position as `ResourceNameField` (top=248) and hide/show ResourceNameField and IsToggleActive based on type. Or simpler: place IsToggleActive at top=248, change Label10 to show "Default Active?" when visible. However, the cleanest approach for the planner is:

- Add `IsToggleActive As DesktopCheckBox` at top=248 inside GroupBox1
- Caption: `"Default Active?"`
- Show/hide or enable/disable based on rowType in `SetInspectorState`
- The `IsToggleActive.ValueChanged` event writes `d.Value("isToggleActive")`

---

## Complete Insertion Point Map

| Change | Location | Type |
|--------|----------|------|
| AddItemPopup `InitialValue` | Line 148, `InitialValue` property | Property edit |
| AddItemPopup `SelectionChanged` — 3 new Case blocks | After line 1833, before `End Select` (line 1835) | Code insert |
| `SetInspectorState` — extend boolean variables + IsToggleActive | Lines 1560-1585 | Code edit |
| `PopulateInspector` — extend rowType If block | Lines 1412-1433 | Code edit |
| `IsToggleActive.ValueChanged` event | New event | New event |
| `GenerateCode` — restructure to Select Case + new cases | Lines 1147-1188 | Code restructure |
| `GenerateCode` version header | Line 1110 | String edit |
| `BuildJSON` version | Line 875 | String edit |
| `BuildJSON` isToggleActive field | After line 917 | Code insert |
| `LoadFromJSON` — Select Case for CellTextAt col 1 | Lines 1265-1269 | Code replace |
| `LoadFromJSON` — isToggleActive field | After line 1277 | Code insert |
| `UpdateDropdownColumn` — include splitbutton | Line 1628 | Code edit |
| `CascadeTagUpdate` — all 3 branches | Lines 963, 1002, 1024 | Code edit (×3) |
| StatusBar `Text` property | Line 222 | Property edit |
| AboutBox `CopyrightLabel` `Text` property | `AboutBox.xojo_window` line 79 | Property edit |
| New `IsToggleActive` DesktopCheckBox control | `GroupBox1` in layout | New control |

---

## Architecture Patterns

The designer is a single-window Xojo Desktop app with one source file containing all logic. The data model flows as:

```
JSON file (.ribbon)
       ↓ LoadFromJSON
RibbonStructure listbox rows (RowTagAt = Dictionary per row)
       ↓ SelectionChanged
PopulateInspector / SetInspectorState (reads Dictionary → fills controls)
       ↑ TextChanged / ValueChanged events (writes controls → Dictionary)
       ↓ BuildJSON
JSON file (.ribbon)
       ↓ GenerateCode
Clipboard (Xojo source code string)
```

All Dictionary mutations happen either in AddItemPopup.SelectionChanged (creation) or inspector field event handlers (editing). `BuildJSON` reads the Dictionary tree and `LoadFromJSON` writes it. These are the only two paths into/out of persistence.

---

## Common Pitfalls

### Pitfall 1: Type string vs label string confusion
**What goes wrong:** Confusing the internal type string (e.g. `"splitbutton"`) stored in the Dictionary `"type"` key with the display label shown in listbox col 1 (e.g. `"Split Button"`).
**Why it happens:** These are two separate values set independently in every code path.
**How to avoid:** Every new Case block must set BOTH: `d.Value("type") = "splitbutton"` AND `RibbonStructure.CellTextAt(addedRow, 1) = "Split Button"`.

### Pitfall 2: LoadFromJSON binary If/Else
**What goes wrong:** Adding new types without fixing the `If iType = "large" Then ... Else "Small Button"` in LoadFromJSON causes all new types to display as "Small Button" after a Save/Load round-trip.
**How to avoid:** Replace with Select Case as shown in Area 6 above.

### Pitfall 3: CascadeTagUpdate misses new types
**What goes wrong:** Auto-tag generation doesn't work for new types because CascadeTagUpdate only checks `"large" Or "small"`.
**How to avoid:** Extend all three branches as shown in Area 8.

### Pitfall 4: UpdateDropdownColumn misses splitbutton
**What goes wrong:** SplitButton menu item count doesn't show in col 2.
**How to avoid:** Add `Or d.Value("type") = "splitbutton"` to the guard in UpdateDropdownColumn.

### Pitfall 5: IsToggleActive control not wired to new event handler
**What goes wrong:** UI shows checkbox but changes don't persist to Dictionary.
**How to avoid:** Ensure `IsToggleActive.ValueChanged` event is implemented.

### Pitfall 6: Xojo Refresh vs Invalidate
**What goes wrong:** Canvas doesn't update after programmatic changes.
**Mitigating fact:** The designer has no canvas, only listbox/inspector controls. Use `.Refresh` if any control needs forced redraw after programmatic change (per project Xojo gotcha notes).

---

## Sources

### Primary (HIGH confidence — verified by direct file read)
- `designer/MainWindow.xojo_window` — all code patterns, exact line numbers cited
- `designer/AboutBox.xojo_window` — version string location
- `DEV_PLAN.md` — locked design decisions, JSON schema spec, code-gen patterns

### Secondary
- `.planning/REQUIREMENTS.md` — REQ-601 through REQ-608 specification
- `.planning/ROADMAP.md` — phase context and dependency info

---

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | No existing `IsToggleActive` control in GroupBox1 | Area 3 | [VERIFIED: all 14 controls listed — no such control found] |
| A2 | SplitButton in designer uses explicit `"splitbutton"` type string (not inferred from menuItems like current dropdown) | Multiple areas | Confirmed by DEV_PLAN.md locked decision #2 |

**All critical claims verified directly from source files.**

---

## RESEARCH COMPLETE
