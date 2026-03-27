# XjRibbon MVP Plan — Canvas-Based Ribbon Toolbar for Xojo

## Context

The goal is to build a Microsoft Office-style ribbon toolbar component entirely on Xojo's `DesktopCanvas`. The project has a clean skeleton: an empty `XjRibbon` class (DesktopCanvas subclass) already placed in `MainWindow` at 600x122px. This plan covers the first MVP — a visually working ribbon with tabs, groups, and large buttons.

## Architecture

Three-tier composite data model, all rendering owned by the canvas:

```
XjRibbon (DesktopCanvas — controller + renderer + event dispatcher)
  └── mTabs() As XjRibbonTab
        └── mGroups() As XjRibbonGroup
              └── mItems() As XjRibbonItem
```

## Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `XjRibbonItem.xojo_code` | **Create** | Data model: one button (Caption, Tag, bounds, hover/pressed state) |
| `XjRibbonGroup.xojo_code` | **Create** | Data model: group of items + label. Methods: `AddLargeButton()` |
| `XjRibbonTab.xojo_code` | **Create** | Data model: tab with groups. Methods: `AddNewGroup()` |
| `XjRibbon.xojo_code` | **Modify** | All rendering, layout, hit-testing, mouse events |
| `XjRibbon.xojo_project` | **Modify** | Register the 3 new classes |
| `MainWindow.xojo_window` | **Modify** | Demo data in Opening + ItemPressed handler |

## Layout Map (600x122px)

```
Y=0   ┌──────────────────────────────────────────────┐
      │  [Home]  [Insert]  [View]   ← Tab strip      │ 24px
Y=24  ├──────────────────────────────────────────────┤
Y=26  │  ┌───────────────┐│┌───────────┐             │
      │  │ [■] [■] [■]   ││ [■] [■]   │             │ Content
      │  │ Paste Cut Copy ││ Bold Ital │             │ (white)
      │  │  ─Clipboard─  ││  ──Font──  │             │ 16px label
Y=122 └──────────────────────────────────────────────┘
```

## Developer API (how users of the component will use it)

```xojo
// In MainWindow.Opening:
Var home As XjRibbonTab = XjRibbon1.AddTab("Home")

Var clip As XjRibbonGroup = home.AddNewGroup("Clipboard")
clip.AddLargeButton("Paste", "clipboard.paste")
clip.AddLargeButton("Cut", "clipboard.cut")
clip.AddLargeButton("Copy", "clipboard.copy")

// Handle clicks:
Sub ItemPressed(tag As String) Handles XjRibbon1.ItemPressed
  Select Case tag
  Case "clipboard.paste"
    MessageBox("Paste!")
  End Select
End Sub
```

## Implementation Steps (in order)

1. **Create `XjRibbonItem`** — Pure data class: Caption, Tag, IsEnabled, mBounds (X/Y/W/H), mIsHovered, mIsPressed
2. **Create `XjRibbonGroup`** — Data class with mItems() array, AddItem(), AddLargeButton() convenience method
3. **Create `XjRibbonTab`** — Data class with mGroups() array, AddGroup(), AddNewGroup() convenience method
4. **Register classes** in `XjRibbon.xojo_project`
5. **Implement `XjRibbon` core** — Properties (mTabs, mActiveTabIndex, mHoveredItem, mPressedItem), constants (geometry), EventDef `ItemPressed(tag)`, public API: AddTab(), SelectTab(), Clear()
6. **Layout algorithm** — `LayoutTabs(g)` computes all mBounds in a single pass during Paint
7. **Rendering** — DrawBackground, DrawTabStrip, DrawContentArea, DrawGroups, DrawLargeButton (placeholder colored rectangles for icons)
8. **Interaction** — HitTestTabs(), HitTestItems(), MouseMove/MouseDown/MouseUp/MouseExit handlers
9. **Wire MainWindow** — Opening event populates demo data, ItemPressed shows MessageBox
10. **Test** — Open in Xojo IDE, run, verify tab switching + hover states + button clicks

## Key Design Decisions

- **Layout computed every Paint call** — because `g.TextWidth()` is only available during Paint. This is intentional and efficient for the data sizes involved.
- **All coordinates as Double** — future-proofs for HiDPI (Phase 2) at no cost.
- **Placeholder icons** — colored 32x32 rectangles. Real Picture icons deferred to Phase 2.
- **Event Definition pattern** — `XjRibbon` declares `Event ItemPressed(tag As String)`, raises it on click. Standard Xojo subclass event pattern.

## What MVP Does NOT Include (deferred)

- Real icons (Picture objects) → Phase 2
- Small buttons (icon + text side-by-side) → Phase 2
- Dropdown buttons / popup menus → Phase 2
- Dark mode color adaptation → Phase 2
- HiDPI scaling → Phase 2
- Tooltips → Phase 2
- Ribbon collapse/minimize → Phase 3
- Keyboard navigation → Phase 3
- Contextual tabs → Phase 3
- Quick Access Toolbar → Phase 3

## Verification

1. Open `XjRibbon.xojo_project` in Xojo IDE — should load without errors
2. Run the project — window shows ribbon with 3 tabs (Home, Insert, View)
3. Click tabs — content switches between different group/button sets
4. Hover over buttons — subtle blue highlight appears
5. Click a button — MessageBox confirms the correct tag was fired
