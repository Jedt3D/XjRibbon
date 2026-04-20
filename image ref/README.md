# Windows File Explorer Ribbon — Reference Analysis

This folder contains reference screenshots of the **Windows File Explorer ribbon** (Windows 8.1/10),
used as a design and functional reference for the **XjRibbon** component.

The full structured specification is in [`explorer_ribbon_toolbar.json`](./explorer_ribbon_toolbar.json).

---

## Image Files

| File | Tab Shown | Notes |
|------|-----------|-------|
| `home_tab.png` | **Home** | Correct. Shows the full Home tab. |
| `share_tab.png` | **Share** | Correct. Shows the full Share tab. |
| `view_atb.png` | **View** | Correct. Shows the full View tab with "Details" layout selected. |

---

## Ribbon Structure Overview

```
[File ▼]  [Home]  [Share]  [View ●]
     ↑ Application Menu (Backstage)     ↑ Active tab (blue underline)
```

---

## Home Tab

**Active in:** `home_tab.png`

### Group: Clipboard

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Pin to Quick access | Button | **Large** | Pins/unpins selected folder from the Quick access nav pane section |
| Copy | Button | Small | Copies selected item(s) to clipboard |
| Paste | Button | **Large** | Pastes clipboard item(s) into current folder |
| Cut | Button | Small | Cuts item(s) to clipboard (moved on Paste) |
| Copy path | Button | Small | Copies full file system path as text to clipboard |
| Paste shortcut | Button | Small | Creates a .lnk shortcut to the clipboard item here |

### Group: Organize

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Move to ▼ | **SplitButton** | Medium | Primary = open folder picker; Dropdown = recent locations + "Choose location..." |
| Copy to ▼ | **SplitButton** | Medium | Primary = open folder picker; Dropdown = recent locations + "Choose location..." |
| Delete ▼ | **SplitButton** | Medium | Primary = move to Recycle Bin; Dropdown = Recycle / Permanently delete |
| Rename | Button | Medium | Puts filename into inline edit mode |

**Move to / Copy to dropdown items:** Documents · Pictures · Music · Desktop · *separator* · Choose location...

**Delete dropdown items:** Recycle · Permanently delete

### Group: New

| Control | Type | Size | Description |
|---------|------|------|-------------|
| New folder | Button | **Large** | Creates a new empty folder with editable name |
| New item ▼ | DropDownButton | Small | Creates a new file; dropdown = type selector |

**New item dropdown:** Folder · Shortcut · *separator* · Bitmap image · Contact · Journal Document · Rich Text Document · Text Document · Compressed (zipped) Folder

### Group: Open

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Properties ▼ | **SplitButton** | **Large** | Primary = Properties dialog; Dropdown = Properties / Remove properties |
| Open ▼ | **SplitButton** | Medium | Primary = open with default app; Dropdown = Open / Open with |
| Edit | Button | Small | Opens file in its default editing application |
| History | Button | Small | Opens File History to browse/restore previous versions |

### Group: Select

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Select all | Button | Small | Selects all items in current view |
| Select none | Button | Small | Deselects all items |
| Invert selection | Button | Small | Swaps selected/unselected items |

---

## Share Tab

**Active in:** `share_tab.png`

### Group: Send

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Share | Button | **Large** (32px icon) | Opens Windows sharing picker |
| Email | Button | Small (16px icon) | Opens email client with file attached |
| Zip | Button | Small (16px icon) | Creates a compressed (.zip) folder |

### Group: Share with

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Burn to disc | Button | Small | Burns to CD/DVD via Windows |
| Print | Button | Small | Opens print dialog |
| Fax | Button | Small | Opens Windows Fax and Scan |
| *(scrollable sharing targets)* | InRibbonGallery | Medium | Vertical scrollable list of sharing destinations (see below) |

**Scrollable sharing targets** (InRibbonGallery):
- **Create or join a homegroup** — static item; opens homegroup setup
- **Barticus** — *dynamic* item representing a discovered network user (label = user/computer name)
- **Specific people...** — static item; opens File Sharing dialog
- *(inferred, below scroll)* Nobody, Homegroup (view), Homegroup (view and edit)

### Group: *(unlabeled, after divider)*

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Stop sharing | Button | **Large** | Removes all sharing permissions |
| Advanced security | DropDownButton | **Large** | Opens security permissions (dropdown: Properties, Edit permissions, Effective access) |

---

## View Tab

**Active in:** `view_atb.png` and `home_tab.png` (both show same content)

### Group: Panes

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Navigation pane ▼ | **SplitButton** | **Large** | Primary click = toggle nav pane; Arrow = menu (see below) |
| Preview pane | ToggleButton | Small | Show/hide preview pane on right |
| Details pane | ToggleButton | Small | Show/hide details pane at bottom |

**Navigation pane dropdown menu:**
- Navigation pane *(CheckBox — toggle the pane)*
- Expand to open folder *(CheckBox)*
- Show all folders *(CheckBox)*
- Show libraries *(CheckBox)*

### Group: Layout

| Control | Type | Description |
|---------|------|-------------|
| View layout selector | **InRibbonGallery** | Radio-style 2-column scrollable grid. Selecting one item deselects all others. |

**Gallery items** (in screenshot order, left→right, top→bottom):

| Position | Label | Notes |
|----------|-------|-------|
| Row 1, Col 1 | Extra large icons | |
| Row 1, Col 2 | Large icons | |
| Row 2, Col 1 | Medium icons | |
| Row 2, Col 2 | Small icons | |
| Row 3, Col 1 | List | |
| Row 3, Col 2 | **Details** | **Currently selected** (blue highlight in screenshot) |
| *(scrolled)* | Tiles | Inferred — not visible in screenshot |
| *(scrolled)* | Content | Inferred — not visible in screenshot |

### Group: Current view

| Control | Type | Size | Description |
|---------|------|------|-------------|
| Sort by ▼ | DropDownButton | Medium | Dropdown: Name, Date modified, Type, Size, Date created, Authors, Tags, Title, *separator*, Ascending, Descending |
| Group by ▼ | DropDownButton | Medium | Dropdown: Name, Date modified, Type, Size, Tags, *separator*, Ascending, Descending, *separator*, (None) |
| Add columns ▼ | DropDownButton | Medium | Dropdown: Name, Date modified, Type, Size, Tags, Date created, Authors, *separator*, More... |
| Size all columns to fit | Button | Medium | Auto-resizes all columns to fit content (Details view only) |

### Group: Show/hide

| Control | Type | State in Screenshot | Description |
|---------|------|---------------------|-------------|
| Item check boxes | **CheckBox** | ☐ unchecked | Shows selection checkboxes on icons |
| File name extensions | **CheckBox** | ☐ unchecked | Shows/hides .txt, .docx etc. |
| Hidden items | **CheckBox** | ☑ **checked** | Shows/hides files with Hidden attribute |
| Hide selected items | Button | Medium | Marks selected files as hidden |
| Options ▼ | DropDownButton | **Large** | Dropdown: "Change folder and search options" → opens Folder Options dialog |

---

## Microsoft Ribbon Framework Control Types

These are the **official names** from the [Windows Ribbon Framework](https://learn.microsoft.com/windows/win32/windowsribbon/windowsribbon-controls-entry). Use them as the canonical vocabulary for XjRibbon.

| Control Name | MS Element | Key Behaviour |
|---|---|---|
| **Button** | `Button` | Fires one command. No retained state. |
| **ToggleButton** | `ToggleButton` | Retains pressed/unpressed state. No checkbox glyph. |
| **CheckBox** | `CheckBox` | Retains checked/unchecked state. Renders with checkbox glyph. |
| **SplitButton** | `SplitButton` | Two hit areas: primary button + separate dropdown arrow. Primary click = main action; arrow click = submenu. |
| **DropDownButton** | `DropDownButton` | Any click opens a dropdown menu. No standalone primary action. |
| **InRibbonGallery** | `InRibbonGallery` | Scrollable collection embedded in the ribbon band itself. Scroll arrows at edge. Radio-style or command items. |
| **DropDownGallery** | `DropDownGallery` | Button that opens a gallery in a popup panel. |
| **SplitButtonGallery** | `SplitButtonGallery` | Like SplitButton but dropdown shows a gallery. |
| **Group** | `Group` | Container with bottom label. Separated by vertical dividers. |
| **Tab** | `Tab` | Top-level navigation. Active tab highlighted. |

---

## Visual Sizes

| Size | Icon | Layout |
|------|------|--------|
| **Large** | 32×32 px | Icon on top, label below (up to 2 lines). Full group height. |
| **Medium** | 16×16 px | Icon left, label right, single row. 2–3 stack vertically. |
| **Small** | 16×16 px | Icon left, compact label right. Up to 3 stack in a column. |

---

## XjRibbon Implementation Status

Current implementation status for each control type visible in these screenshots:

| Control | Reference Example | Status |
|---------|------------------|--------|
| **Button** (Large + Small) | Share, Email, Zip, Rename, New folder | ✅ done |
| **ToggleButton** | Preview pane, Details pane | ✅ done (`IsToggle` flag) |
| **DropDownButton** | Sort by, Group by, Options, Advanced security | ✅ done |
| **SplitButton** | Navigation pane ▼, Properties ▼, Move to ▼ | ❌ Desktop P5 / Web P5 |
| **CheckBox** | Item check boxes, File name extensions, Hidden items | ❌ Desktop P5 / Web P5 |
| **InRibbonGallery** | Layout view selector (Details/Icons/List…) | ⏭ not planned — low value for business apps |

See `../DEV_PLAN.md` for full roadmap and rationale.

---

## Key Visual Anatomy

```
┌───────────────────────────────────────────────────────────────┐
│ [File▼]  Home  [Share]  [View]◄── active tab (blue underline) │
├──────┬──────────────────────────┬─────────────────────────────┤
│      │  ┌──────┐ ┌──────┐       │                             │
│ Lrg  │  │Med   │ │Med   │   ... │ [☑] CheckBox                │
│ Btn  │  │Btn   │ │Btn   │       │ [☐] CheckBox                │
│      │  └──────┘ └──────┘       │ [☐] CheckBox                │
│  ↕   │  ┌──────┬──────┐         │ [Med Btn]                   │
│ Split│  │ item │ item │  gallery│ [Large DropDown▼]           │
│ Btn  │  │ item │ item │  (not   │                             │
│  ▼   │  │ item │►item◄│  planned│                             │
├──────┴──┴──────┴──────┴─────────┴─────────────────────────────┤
│  Panes  │      Layout           │ Current │ Show/hide         │
│         │ ← group label ───────►│  view   │ group             │
└─────────┴───────────────────────┴─────────┴───────────────────┘
   ►item◄ = selected gallery item (InRibbonGallery — not planned)
```

---

*Reference for XjRibbon Desktop/Web component development.*
*Source: Windows File Explorer ribbon, Windows 8.1/10.*
