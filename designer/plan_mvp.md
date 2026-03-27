# XjRibbon Designer — MVP Plan

## Goal
A standalone Xojo Desktop app that lets users visually design an XjRibbon toolbar
hierarchy, then copy the generated Xojo source code to paste into their XjRibbon's
`Opening()` (desktop) or `Shown()` (web) event.

## Branch
`feature/designer-mvp` — isolated from `desktop/` and `web/` work.

---

## Current Window Layout (designed in Xojo IDE)

### Top Bar (left to right)
- `ProjectName` (Label) — shows `"filename" Structure` (or `"Untitled" Structure`)
- `Label2` "Add" + `NewItem` (PopupMenu) — `-- select item -- | Ribbon Tab | Ribbon Group | Ribbon Large Button | Ribbon Small Button`
- `ProjectType` (RadioGroup) — Desktop / Web (determines generated event name)
- `CopyToolbarCode` (Button) — generates and copies code to clipboard

### Main Area
- **Left**: `RibbonStructure` (DesktopListBox) — expandable hierarchical tree
  - Column 0: Caption
  - Column 1: Type (`Tab`, `Group`, `Large Button`, `Small Button`)
  - AllowExpandableRows, AllowRowDragging, AllowRowReordering = True
- **Right**: `GroupBox1` "Inspector" — flat panel, enable/disable fields by row type

### Inspector Controls (inside GroupBox1)
| Control            | Label               | Maps to           | Enabled for           |
|--------------------|---------------------|--------------------|-----------------------|
| CaptionField       | Label4 "Caption"    | Caption            | Tab, Group, Item      |
| TagField           | Label5 "Tag"        | Tag                | Item only             |
| ItemTypeField      | Label6 "Item Type"  | Type (readonly)    | Item only             |
| IsEnabled          | "Is Enabled?"       | IsEnabled          | Item only             |
| TooltipTextField   | Label8 "Tooltip"    | TooltipText        | Item only             |
| Label10 + ResourceNameField | "Resource Name" | *(deferred — icon)* | *(always disabled)* |
| Label11 + AddMenuItem + MenuItems | "Menu Item" | Dropdown menu items | Large Button only |

### Bottom
- `StatusBar` (Label) — `"XjToolbar Designer version X.Y.Z"` — bumped each phase

### AboutBox Window (already designed in IDE)
- `AppIcon` (ImageViewer) — app icon
- `CopyrightLabel` (Label) — shows app name, version, copyright
- Closes via: close button, Esc key, click anywhere on the window
- Triggered from Help > About menu
- Version number in CopyrightLabel must be updated alongside StatusBar each phase

---

## Hierarchy Rules

```
Tab "Home"              ← depth 0 (root row)
  ├─ Group "Clipboard"  ← depth 1 (child of Tab)
  │  ├─ Large Button    ← depth 2 (child of Group)
  │  └─ Small Button    ← depth 2 (child of Group)
  └─ Group "Font"       ← depth 1
Tab "Insert"            ← depth 0
```

### Add Validation (NewItem popup change)
| Adding              | Requires selection at  | Hint if wrong                              |
|---------------------|------------------------|--------------------------------------------|
| Ribbon Tab          | (none — always root)   | —                                          |
| Ribbon Group        | depth 0 (Tab)          | "Select a Tab to add a Group inside it"    |
| Ribbon Large Button | depth 1 (Group)        | "Select a Group to add a Button inside it" |
| Ribbon Small Button | depth 1 (Group)        | "Select a Group to add a Button inside it" |

---

## Row Interactions

### Both RibbonStructure and MenuItems listboxes:
- **Add**: NewItem popup (skip index 0), or AddMenuItem button
- **Rename**: Double-click cell to edit inline (CellAction)
- **Reorder**: Drag and drop (AllowRowDragging + AllowRowReordering already set)
- **Delete**: Forward-DEL (Mac) / Backspace or Delete (Windows)

### Edit Menu integration (applies to focused listbox):
- **Cut** (Cmd+X): Copy row data internally, then delete row + children
- **Copy** (Cmd+C): Copy row data to internal clipboard (Dictionary/JSONItem)
- **Paste** (Cmd+V): Insert copied row after selection (same depth level)
- **Delete**: Remove selected row + children
- **Select All** (Cmd+A): Select text in focused TextField, or no-op on ListBox

### Undo (Cmd+Z):
Snapshot-based approach — simple and reliable for a designer tool:
- Before each edit, push a full JSON snapshot of the ribbon state onto an undo stack
- Undo = pop previous snapshot, rebuild ListBox from it
- Ribbon structures are small, so snapshot overhead is negligible
- Complexity: moderate — mainly wiring up snapshot capture points
- Scope: Phase 6 (Polish) — implement if time permits, otherwise defer to post-v1.0

---

## Data Model (JSON, .ribbon extension)

```json
{
  "version": "1.0",
  "projectType": "desktop",
  "tabs": [
    {
      "caption": "Home",
      "groups": [
        {
          "caption": "Clipboard",
          "items": [
            {
              "caption": "Paste",
              "tag": "clipboard.paste",
              "itemType": "large",
              "isEnabled": true,
              "tooltipText": "Paste from clipboard",
              "menuItems": [
                { "caption": "Paste Special", "tag": "clipboard.pastespecial" }
              ]
            },
            {
              "caption": "Cut",
              "tag": "clipboard.cut",
              "itemType": "small",
              "isEnabled": true,
              "tooltipText": "",
              "menuItems": []
            }
          ]
        }
      ]
    }
  ]
}
```

### Code Generation Logic
- `itemType = "large"` with no menuItems → `AddLargeButton(caption, tag)`
- `itemType = "large"` with menuItems → `AddDropdownButton(caption, tag)` + `AddMenuItem()` calls
- `itemType = "small"` → `AddSmallButton(caption, tag)`
- If tooltipText not empty → `item.TooltipText = "..."`
- If isEnabled = false → `item.IsEnabled = False`
- Event wrapper: `Opening()` when ProjectType = Desktop, `Shown()` when ProjectType = Web

### Generated Code Example
```xojo
// Generated by XjRibbon Designer v1.0.0
// Paste into your XjRibbon's Opening() event

// === Home ===
Var homeTab As XjRibbonTab = Me.AddTab("Home")

Var clipboardGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
Var pasteItem As XjRibbonItem = clipboardGroup.AddDropdownButton("Paste", "clipboard.paste")
pasteItem.TooltipText = "Paste from clipboard"
pasteItem.AddMenuItem("Paste Special", "clipboard.pastespecial")
Call clipboardGroup.AddSmallButton("Cut", "clipboard.cut")
Call clipboardGroup.AddSmallButton("Copy", "clipboard.copy")
```

---

## Menu Bar (already designed in IDE)

### File Menu
| Menu Item     | Name         | Shortcut      | Phase |
|---------------|-------------|---------------|-------|
| New           | `NewItem`*  | Cmd+N         | 4     |
| Open          | `OpenItem`  | Cmd+O         | 4     |
| Save          | `SaveItem`  | Cmd+S         | 4     |
| Save As...    | `SaveAsItem`| Cmd+Shift+S   | 4     |
| Quit          | `FileQuit`  | Cmd+Q         | done  |

*NOTE: `NewItem` menu conflicts with `NewItem` PopupMenu control — rename menu to `FileNew` before wiring.

### Edit Menu
| Menu Item     | Name           | Shortcut | Phase |
|---------------|---------------|----------|-------|
| Undo          | `EditUndo`    | Cmd+Z    | 6     |
| Cut           | `EditCut`     | Cmd+X    | 6     |
| Copy          | `EditCopy`    | Cmd+C    | 6     |
| Paste         | `EditPaste`   | Cmd+V    | 6     |
| Delete        | `EditClear`   | Del      | 6     |
| Select All    | `EditSelectAll`| Cmd+A   | 6     |

Wire Edit menu to operate on focused listbox (row-level) or textfield (text-level).

### Help Menu
| Menu Item     | Name         | Shortcut       | Phase |
|---------------|-------------|----------------|-------|
| About         | `HelpAbout` | Cmd+Shift+/    | done  |

---

## Implementation Phases

### Phase 1 — Tab Level (v0.2.0) ✅
- [x] NewItem popup: add Tab at root via `AddExpandableRow`
- [x] RowTag stores Dictionary: `{"type": "tab", "caption": "New Tab"}`
- [x] SelectionChanged → enable only CaptionField; disable all other inspector fields
- [x] CaptionField TextChanged → update RowTag + listbox cell
- [x] Double-click cell → inline edit (CellTypeAt = TextField + CellAction), sync to RowTag + CaptionField
- [x] Delete key (KeyDown: Chr(127) / Chr(8)) → remove selected Tab row + all children
- [x] ProjectName label → `"Untitled" Structure`
- [x] AboutBox: KeyDown Esc + MouseDown click anywhere to close
- [x] Help > About menu handler wired → shows AboutBox modal
- [x] StatusBar → v0.2.0, AboutBox → v0.2.0
- [x] Git: commit da49d7f + tag v0.2.0-designer

### Phase 2 — Group Level (v0.3.0) ✅
- [x] NewItem popup: add Group as child of selected Tab via `AddExpandableRowAt(insertAt, text, 1)`
- [x] Validation: if no Tab selected → StatusBar hint
- [x] `FindLastChildRow()` helper to find correct insertion position
- [x] RowTag Dictionary: `{"type": "group", "caption": "New Group"}`
- [x] SelectionChanged → enable only CaptionField for Group rows
- [x] Double-click cell → inline edit, sync to RowTag + CaptionField
- [x] Delete key → remove Group row + all child items
- [x] StatusBar → v0.3.0, AboutBox → v0.3.0
- [x] Git: commit 80d5d51 + tag v0.3.0-designer

### Phase 3 — Item Level + Dropdown Menu (v0.4.0) ← CURRENT
- [x] NewItem popup: add Large/Small Button as child of Group via `AddRowAt(insertAt, text, 2)`
- [x] Validation: if no Group selected → StatusBar hint
- [x] RowTag Dictionary: `{"type": "large/small", "caption", "tag", "isEnabled", "tooltipText", "menuItems": []}`
- [x] SelectionChanged → enable all Item fields; disable MenuItems section for Small Buttons
- [x] CaptionField, TagField, IsEnabled, TooltipTextField → update RowTag on change
- [x] ItemTypeField → readonly, shows "Large Button" or "Small Button"
- [x] PopulateInspector loads MenuItems from RowTag; clears item fields for tab/group
- [x] MenuItems listbox: AddMenuItem adds row, double-click cells to rename, DEL to delete
- [x] `SyncMenuItemsToRowTag()` syncs MenuItems listbox back to RowTag after every change
- [x] Delete key on RibbonStructure → remove Item row
- [ ] StatusBar → v0.4.0, AboutBox → v0.4.0
- [ ] Git: commit + tag v0.4.0-designer
- **Pending: Xojo analysis + user testing**

### Phase 4 — Save / Load (v0.5.0)
- [ ] Rename menu `NewItem` → `FileNew` to avoid conflict with PopupMenu control
- [ ] Wire File menu handlers: FileNew, OpenItem, SaveItem, SaveAsItem
- [ ] Build JSONItem from ListBox hierarchy (walk rows recursively)
- [ ] Rebuild ListBox from JSONItem (recursive add with proper parent/depth)
- [ ] FolderItem dialog with `.ribbon` file type filter
- [ ] Track dirty state (any edit sets dirty flag)
- [ ] Prompt "Save changes?" on close/new/open if dirty
- [ ] ProjectName label → `"filename" Structure` on save/open
- [ ] Window title → `"XjRibbon Designer — filename.ribbon"`
- [ ] StatusBar → v0.5.0, AboutBox → v0.5.0
- [ ] Git: commit + tag v0.5.0-designer

### Phase 5 — Code Generation (v0.6.0)
- [ ] CopyToolbarCode button → build Xojo source string from data model
- [ ] Variable names: sanitized caption (alphanumeric, camelCase) + suffix (Tab/Group/Item)
- [ ] Use `Call` prefix when item has no extra properties to set
- [ ] Comment header: `// Generated by XjRibbon Designer vX.Y.Z`
- [ ] Event comment: `// Paste into your XjRibbon's Opening() event` or `Shown()` based on ProjectType
- [ ] Save before copy: if new/unsaved → prompt Save As first
- [ ] Copy to clipboard via `Clipboard.Text = code`
- [ ] StatusBar feedback: "Code copied to clipboard!"
- [ ] StatusBar → v0.6.0, AboutBox → v0.6.0
- [ ] Git: commit + tag v0.6.0-designer

### Phase 6 — Polish + Edit Operations (v1.0.0)
- [ ] Edit menu wiring: Cut/Copy/Paste for listbox rows (internal clipboard as Dictionary)
- [ ] Cut = copy row data + delete; Copy = store row data; Paste = insert after selection at same depth
- [ ] Undo (snapshot-based): push JSON state before each edit, pop on Cmd+Z, rebuild ListBox
- [ ] Edge cases: empty ribbon, duplicate tag warnings
- [ ] Ensure Delete key works cross-platform (forward-DEL on Mac, Backspace/Delete on Windows)
- [ ] Resource Name controls (Label10, ResourceNameField) → always disabled for now
- [ ] Final testing of full workflow: create → edit → save → load → copy code
- [ ] StatusBar → v1.0.0, AboutBox → v1.0.0
- [ ] Git: commit + tag v1.0.0-designer

---

## Out of Scope (future)
- Live preview of the ribbon in the designer window
- Icon picker / icon resource name assignment
- Redo stack
- Export to web/ variant code differences (currently same API)
- Drag items between groups/tabs (cross-parent moves)
