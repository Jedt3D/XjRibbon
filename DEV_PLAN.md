# XjRibbon — Master Development Plan

> **Goal**: A production-quality MS Office–style ribbon toolbar for Xojo Desktop and Web,
> complete with a visual designer tool — covering every control type visible in the
> Windows File Explorer reference (`image ref/explorer_ribbon_toolbar.json`).

---

## Current State Snapshot (2026-04-20)

### desktop/ — Library

| Phase | Feature | Status |
|-------|---------|--------|
| MVP   | Tabs, groups, large buttons, events | ✅ done |
| 2     | Small buttons, dropdown, dark mode, icons, HiDPI, tooltips | ✅ done |
| 3     | Ribbon collapse, contextual tabs | ✅ done |
| 4     | Toggle buttons, keyboard navigation (KeyTips) | ✅ done |
| **5** | **CheckBox items, SplitButton, separator item** | ❌ next |

**Current `ItemType` constants (XjRibbonItem):**
```
0 = Large Button    32px icon + label below, full group height
1 = Small Button    16px icon + label right, stacks 3-per-column
2 = Dropdown Button large format + chevron arrow; all clicks open popup menu
```
**Current `IsToggle` flag:** Adds pressed/depressed state to type 0 or 1 (no glyph).

---

### web/ — Library

| Phase | Feature | Status |
|-------|---------|--------|
| MVP–3 | Parity with desktop Phase 1-3 | ✅ done |
| 2.5   | Hover via JS mousemove injection | ✅ done |
| **4** | **Keyboard navigation** | ⏭ not planned — web is mouse-driven; approach documented, will not implement |
| **5** | **CheckBox, SplitButton, separator (parity with desktop Phase 5)** | ❌ next |

**Web-specific constraints (already documented):**
- No native MouseMove — hover via `window.location.hash` + `Session.HashTagChanged`
- No `g.TextWidth` — use `Picture.Graphics` workaround
- No `g.Transparency` — use Color alpha
- `FillRoundRectangle` takes single corner param
- 120% scaling applied throughout

---

### designer/ — Design Tool (v1.0.0)

| Phase | Feature | Status |
|-------|---------|--------|
| 1-6   | Tab/Group/Large/Small/Dropdown hierarchy, Save/Load, Code gen, Polish | ✅ v1.0.0 done |
| **v2.0** | **Toggle/CheckBox/SplitButton in inspector + code gen** | ❌ next |
| **v3.0** | **Live ribbon preview pane** | ❌ future |

**Designer data model** (current `.ribbon` JSON schema only knows):
```json
"itemType": "large" | "small" | "dropdown"
```

---

## Gap Analysis vs Reference Images

Source: `image ref/explorer_ribbon_toolbar.json` (Home, Share, View tabs of Windows File Explorer)

### 1. SplitButton — **two independent hit areas**

The reference shows `Navigation pane ▼`, `Properties ▼`, `Open ▼`, `Move to ▼`, `Copy to ▼`, `Delete ▼` — all SplitButtons.

| Aspect | Current XjRibbon DropDownButton (ItemType=2) | Needed SplitButton |
|--------|----------------------------------------------|--------------------|
| Primary area click | opens dropdown menu | fires `ItemPressed(tag)` directly |
| Arrow area click | opens dropdown menu | opens dropdown menu |
| Visual | large icon + label + chevron below | large icon + label \| thin separator line \| chevron area |

**Minimal change**: Add `IsSplitButton As Boolean` to `XjRibbonItem`.
When `ItemType = 2` and `IsSplitButton = True`:
- Hit-test separates body (≥80% width) vs arrow area (≤20% width)
- Body click → `RaiseEvent ItemPressed(tag)` — same as a plain Large Button
- Arrow click → popup menu → `RaiseEvent DropdownMenuAction(itemTag, menuItemTag)`

No new ItemType required. Backward compatible: `IsSplitButton = False` (default) = current behavior.

---

### 2. CheckBox Item — **distinct glyph, not a toggle button**

The reference shows `Item check boxes`, `File name extensions`, `Hidden items` in the Show/hide group — all CheckBox style with ☐/☑ glyph.

**Difference from existing `IsToggle = True`:**

| Aspect | ToggleButton (IsToggle) | CheckBox (new) |
|--------|------------------------|----------------|
| Glyph | none — pressed state shown by background highlight | ☐ (unchecked) / ☑ (checked) glyph rendered |
| Layout | same as Small button | text-only row with leading glyph, no icon column |
| Click | toggles `IsToggleActive` | toggles `IsToggleActive` (same) |
| Typical use | Preview pane, Details pane (hide/show panels) | Item check boxes, File name extensions |

**New constant**: `kItemTypeCheckBox = 3`

**New method on XjRibbonGroup**:
```xojo
Function AddCheckBox(caption As String, tag As String) As XjRibbonItem
  // ItemType = 3, IsToggle = True automatically
```

**New draw method in XjRibbon**: `DrawCheckBoxItem(g, item)`:
- Render `☐`/`☑` glyph (or custom drawn box) on left
- Text label to right
- No icon slot, no background hover rect (just glyph + text highlight)

---

### 3. Separator Item

Reference shows logical gaps between control types (e.g. the Show/hide group has checkboxes + a regular button + a large dropdown, separated visually).

The current implementation has **group separators** (vertical lines between groups) but no **item-level separator**.

**Minimal approach**: Add `kItemTypeSeparator = 4` — a zero-width or narrow invisible item that the layout engine treats as a new sub-column boundary within a group. No interaction.

---

## Roadmap

---

### Phase 5 — Desktop Library: Complete Control Set

**Target:** Add CheckBox item, SplitButton mode, Separator item.

**Files touched:** `desktop/XjRibbonItem.xojo_code`, `desktop/XjRibbonGroup.xojo_code`, `desktop/XjRibbon.xojo_code`, `desktop/MainWindow.xojo_window`

#### Step 1: SplitButton mode (`IsSplitButton` property)

**`XjRibbonItem.xojo_code`** — add:
```xojo
Property IsSplitButton As Boolean = False
```

**`XjRibbon.xojo_code`**:

In `DrawDropdownButton(g, item)` — when `item.IsSplitButton = True`:
- Draw a thin vertical separator line at 80% of button width
- Arrow chevron drawn in the remaining 20% area only

In `HitTestItems(x, y)` — when `item.IsSplitButton = True`:
- Return a special "arrow hit" vs "body hit" by checking x vs separator line
- Use a secondary internal flag `mPressedOnArrow As Boolean`

In `MouseUp`:
- If pressed item is SplitButton AND pressed on body → `RaiseEvent ItemPressed(tag)` (skip menu)
- If pressed item is SplitButton AND pressed on arrow → existing popup menu path

New convenience method on `XjRibbonGroup`:
```xojo
Function AddSplitButton(caption As String, tag As String) As XjRibbonItem
  // ItemType = 2, IsSplitButton = True
```

#### Step 2: CheckBox item type

**`XjRibbonItem.xojo_code`** — no new properties (reuse `IsToggleActive` for checked state).

**`XjRibbon.xojo_code`** — add constant `kItemTypeCheckBox = 3`.

Add `DrawCheckBoxItem(g, item)`:
```
Layout: [glyph 13x13] [4px gap] [text]
Glyph:  draw a 13x13 rounded rect border (cBorder)
        if IsToggleActive: fill interior blue (cTabAccent) + draw checkmark ✓ in white
Hover:  glyph border brightens slightly
Text:   cItemText, 9pt (same as small button)
Height: kSmallButtonHeight (22px)
No icon column, no icon background
```

In `LayoutGroupItems` — treat `kItemTypeCheckBox` like Small (stacks in columns of 3).

In `MouseUp` — treat `kItemTypeCheckBox` like `IsToggle = True`: flip `IsToggleActive`, `RaiseEvent ItemPressed`.

New method on `XjRibbonGroup`:
```xojo
Function AddCheckBox(caption As String, tag As String, initialState As Boolean = False) As XjRibbonItem
  // ItemType = 3, IsToggle = True, IsToggleActive = initialState
```

#### Step 3: Separator item

**`XjRibbon.xojo_code`** — add constant `kItemTypeSeparator = 4`.

In `LayoutGroupItems` — when item is separator: start a new column (bump `groupX`) without drawing.

New method on `XjRibbonGroup`:
```xojo
Sub AddSeparator()
  // ItemType = 4, Caption = "", Tag = ""
```

#### Step 4: Demo update

**`desktop/MainWindow.xojo_window`** — add a "Show/hide" group demo:
```xojo
Var showHide As XjRibbonGroup = viewTab.AddNewGroup("Show/hide")
Var cb1 As XjRibbonItem = showHide.AddCheckBox("Item check boxes", "view.checkboxes")
Var cb2 As XjRibbonItem = showHide.AddCheckBox("File name extensions", "view.extensions")
Var cb3 As XjRibbonItem = showHide.AddCheckBox("Hidden items", "view.hidden", True)
showHide.AddSeparator()
Call showHide.AddSmallButton("Hide selected", "view.hide_selected")

Var navGroup As XjRibbonGroup = viewTab.AddNewGroup("Panes")
Var navPane As XjRibbonItem = navGroup.AddSplitButton("Navigation pane", "view.nav_pane")
navPane.AddMenuItem("Navigation pane", "view.nav_pane.toggle")
navPane.AddMenuItem("Expand to open folder", "view.nav_pane.expand")
navPane.AddMenuItem("Show all folders", "view.nav_pane.allfolders")
```

**New Public API after Phase 5:**
```xojo
// SplitButton
XjRibbonItem.IsSplitButton As Boolean
XjRibbonGroup.AddSplitButton(caption, tag) As XjRibbonItem

// CheckBox
XjRibbonGroup.AddCheckBox(caption, tag, initialState) As XjRibbonItem
// Note: reuses ItemType=3, IsToggle/IsToggleActive, existing GetToggleState/SetToggleState

// Separator
XjRibbonGroup.AddSeparator()
```

---

### Phase 4 — Web Library: Keyboard Navigation (Not Planned)

> **Decision:** Web ribbon targets mouse/touch interaction. Implementing full KeyTip keyboard
> navigation in a browser adds significant complexity (JS `keydown` injection, hash routing,
> state machine) for minimal real-world use — web users don't expect Alt-key ribbon shortcuts.
> The approach is documented here for reference if this decision is ever revisited.

**How it would work (reference only):**
- Inject `keydown` listener on `document` via JS → `window.location.hash = "xjkey:" + keyCode`
- `Session.HashTagChanged` parses `xjkey:` prefix → calls `XjRibbon1.HandleKeyDown(keyCode)`
- KeyTip badge drawing and state machine identical to desktop Phase 4
- Activation: Ctrl+Option (macOS), Alt (Windows), F6

**Why deferred:** Web apps are mouse-driven. The JS injection pattern (already used for hover)
works, but the KeyTip state machine adds ~200 lines for a feature web users will not discover.

---

### Phase 5 — Web Library: Control Set Parity

**Target:** Port desktop Phase 5 (CheckBox, SplitButton, Separator) to WebCanvas.

Identical logic to desktop Phase 5 with these web adaptations:
- `DrawCheckBoxItem`: `g.FillRoundRectangle(x, y, w, h, 3)` (single corner param)
- `DrawDropdownButton` with SplitButton: same separator line, different hit areas
- Hover state already handled by existing JS mousemove injection

**Files touched:** Same pattern as all previous web phases — `XjRibbon.xojo_code` (rendering + hit-test), `XjRibbonGroup.xojo_code` (new methods), `XjRibbonItem.xojo_code` (IsSplitButton property).

---

### Designer v2.0 — New Control Types

**Target:** Support Toggle, CheckBox, SplitButton in the designer tree and code generator.

#### Step 1: Extend item type menu and data model

**`designer/MainWindow.xojo_window`** — update `AddItemPopup`:
```
-- select item --
Ribbon Tab
Ribbon Group
Ribbon Large Button
Ribbon Small Button
Ribbon Dropdown Button
Ribbon SplitButton          ← new
Ribbon Toggle Button        ← new
Ribbon CheckBox             ← new
```

Update `.ribbon` JSON schema:
```json
"itemType": "large" | "small" | "dropdown" | "splitbutton" | "toggle" | "checkbox"
```

Update `BuildJSON` and `LoadFromJSON` to handle new types.

#### Step 2: Inspector changes

For **SplitButton** items: same as Dropdown (has MenuItem list). Inspector identical to Dropdown.

For **Toggle Button**: same as Large Button but Inspector shows an additional field:
```
[IsToggleActive] "Default Active?" (CheckBox)
```

For **CheckBox**: only Caption + Tag + Tooltip. No MenuItems. No IsEnabled override needed (always enabled). Inspector shows:
```
[Caption]          text field
[Tag]              text field
[Default Checked]  checkbox (maps to IsToggleActive)
[Tooltip]          text field
```

Update `PopulateInspector(rowType)` to handle these new types.

#### Step 3: Code generation

Extend `GenerateCode()` in `CopyToolbarCode` handler:

```xojo
Case "splitbutton"
  code = code + VarPrefix + varName + " As XjRibbonItem = " + groupVar + ".AddSplitButton(""" + caption + """, """ + tag + """)" + kEOL
  // then add menu items same as dropdown

Case "toggle"
  Var extra As String = ""
  If itemData.Value("isToggleActive") Then extra = kEOL + varName + ".IsToggleActive = True"
  code = code + VarPrefix + varName + " As XjRibbonItem = " + groupVar + ".AddLargeButton(""" + caption + """, """ + tag + """)" + kEOL
  code = code + varName + ".IsToggle = True" + extra + kEOL

Case "checkbox"
  Var defaultChecked As String = ""
  If itemData.Value("isToggleActive") Then defaultChecked = ", True"
  code = code + "Call " + groupVar + ".AddCheckBox(""" + caption + """, """ + tag + """" + defaultChecked + ")" + kEOL
```

#### Step 4: Version bump and status bar

- Version `2.0.0` in StatusBar + AboutBox
- Update help text in StatusBar hints for new types

---

### Designer v3.0 — Live Preview

**Target:** Embed a live XjRibbon canvas in the designer window so users see the rendered result as they build.

**Architecture:**

The designer is itself a Xojo Desktop app — it can embed an `XjRibbon` (DesktopCanvas) inside its main window.

```
MainWindow layout:
  Top bar (existing controls)
  ┌──────────────────────────────────────────────────┐
  │ [Live Preview — XjRibbon canvas]                 │  ← new, resizable
  ├─────────────────────────────────┬────────────────┤
  │ RibbonStructure (listbox)       │ Inspector      │
  └─────────────────────────────────┴────────────────┘
  Status bar
```

**Refresh logic:**
- After any edit (caption change, add/delete/reorder, inspector field change):
  - Call `RebuildPreview()` which calls `XjRibbon1.Clear()` then re-populates it from the current `.ribbon` data model
  - This is exactly what `GenerateCode` traverses — the same traversal, but calling real API methods instead of writing string code
  
**`RebuildPreview()` — same traversal as `GenerateCode` but calling XjRibbon API:**
```xojo
Sub RebuildPreview()
  XjRibbon1.Clear
  For Each tabData As JSONItem In mRibbonData.Value("tabs")
    Var t As XjRibbonTab = XjRibbon1.AddTab(tabData.Value("caption"))
    For Each groupData As JSONItem In tabData.Value("groups")
      Var g As XjRibbonGroup = t.AddNewGroup(groupData.Value("caption"))
      For Each itemData As JSONItem In groupData.Value("items")
        // dispatch on itemType same as code generation
      Next
    Next
  Next
End Sub
```

**Value:** Closes the feedback loop. The designer stops being a text tool and becomes a WYSIWYG designer.

**Complexity:** Medium. The main risk is keeping `mRibbonData` always in sync with the listbox. Currently it's rebuilt on save/export. For live preview we need it rebuilt on every edit. This is the primary engineering effort.

---

## Work Priority Order

```
1. Desktop Phase 5  — SplitButton + CheckBox + Separator   (extends library to full reference coverage)
2. Designer v2.0    — Support new types in designer         (keeps designer current with library)
3. Web Phase 5      — CheckBox + SplitButton parity         (platform parity for new types)
4. Library v1.0     — Package + README for distribution     (ship it)
── post-v1.0 ──────────────────────────────────────────────────────
5. Designer v3.0    — Live preview                          (premium UX for designer)
```

---

## Complete Control Type Coverage After All Phases

| MS Ribbon Control Type | Reference Example | XjRibbon After Phase | API Method |
|------------------------|-------------------|---------------------|-----------|
| Button (Large) | Share, New folder, Stop sharing | ✅ done | `AddLargeButton` |
| Button (Small) | Email, Zip, Print, Rename | ✅ done | `AddSmallButton` |
| ToggleButton | Preview pane, Details pane | ✅ done (IsToggle) | `AddLargeButton` + `.IsToggle` |
| DropDownButton | Sort by, Group by, Options | ✅ done | `AddDropdownButton` |
| SplitButton | Navigation pane, Properties, Move to | Desktop P5 / Web P5 | `AddSplitButton` |
| CheckBox | Item check boxes, File name extensions | Desktop P5 / Web P5 | `AddCheckBox` |
| Separator (item) | Between control clusters | Desktop P5 / Web P5 | `AddSeparator` |
| Contextual Tab | Format, Design tabs | ✅ done | `AddContextualTab` |
| Tab collapse | Chevron minimize | ✅ done | `SetCollapsed` |
| KeyTip badges | Alt-key nav | ✅ desktop / ⏭ web not planned | `AssignKeyTips` |

---

## API Contract (Final State)

```xojo
// ── Tabs ──────────────────────────────────────────────────────
XjRibbonTab = XjRibbon.AddTab(caption)
XjRibbonTab = XjRibbon.AddContextualTab(caption, contextGroup, accentColor)
XjRibbon.ShowContextualTabs(contextGroup)
XjRibbon.HideContextualTabs(contextGroup)
XjRibbon.SelectTab(index)
XjRibbonTab.KeyTip As String                     // optional manual key tip

// ── Groups ────────────────────────────────────────────────────
XjRibbonGroup = XjRibbonTab.AddNewGroup(caption)

// ── Items (all return XjRibbonItem) ───────────────────────────
group.AddLargeButton(caption, tag)               // ItemType=0
group.AddLargeButton(caption, tag, icon)         // ItemType=0, with icon
group.AddSmallButton(caption, tag)               // ItemType=1
group.AddDropdownButton(caption, tag)            // ItemType=2, whole button = menu
group.AddSplitButton(caption, tag)               // ItemType=2, IsSplitButton=True
group.AddCheckBox(caption, tag, initialChecked)  // ItemType=3
group.AddSeparator()                             // ItemType=4

// ── Item properties ───────────────────────────────────────────
item.Icon As Picture
item.TooltipText As String
item.IsEnabled As Boolean
item.IsToggle As Boolean         // turns Large/Small into press-hold toggle
item.IsToggleActive As Boolean
item.IsSplitButton As Boolean    // only meaningful when ItemType=2
item.KeyTip As String            // optional manual key tip
item.AddMenuItem(caption, tag)   // for ItemType=2 (both Dropdown and Split)

// ── Global state ──────────────────────────────────────────────
XjRibbon.SetCollapsed(value)
XjRibbon.IsCollapsed() As Boolean
XjRibbon.GetToggleState(tag) As Boolean
XjRibbon.SetToggleState(tag, value)
XjRibbon.Clear()

// ── Events ────────────────────────────────────────────────────
Event ItemPressed(tag As String)
Event DropdownMenuAction(itemTag As String, menuItemTag As String)
Event CollapseStateChanged(isCollapsed As Boolean)
```

---

## Designer `.ribbon` Schema (Final State)

```json
{
  "version": "2.0",
  "projectType": "desktop",
  "tabs": [
    {
      "caption": "View",
      "isContextual": false,
      "groups": [
        {
          "caption": "Panes",
          "items": [
            { "caption": "Navigation pane", "tag": "view.nav", "itemType": "splitbutton", "isEnabled": true,
              "menuItems": [
                { "caption": "Show navigation pane",  "tag": "view.nav.toggle" },
                { "caption": "Expand to open folder", "tag": "view.nav.expand" }
              ]
            },
            { "caption": "Preview pane",  "tag": "view.preview", "itemType": "toggle", "isToggleActive": false },
            { "caption": "Details pane",  "tag": "view.details", "itemType": "toggle", "isToggleActive": false }
          ]
        },
        {
          "caption": "Show/hide",
          "items": [
            { "caption": "File name extensions", "tag": "view.ext",    "itemType": "checkbox", "isToggleActive": false },
            { "caption": "Hidden items",          "tag": "view.hidden", "itemType": "checkbox", "isToggleActive": true  },
            { "itemType": "separator" },
            { "caption": "Hide selected items",   "tag": "view.hide",  "itemType": "small" }
          ]
        }
      ]
    }
  ]
}
```

---

*This plan supersedes all per-phase plan files for cross-project context.*
*Individual phase plan files (`plan_phase*.md`) remain valid for per-file implementation details.*
