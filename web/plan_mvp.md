# XjRibbon Web MVP Plan — WebCanvas-Based Ribbon Toolbar for Xojo Web

## Context

Port of the desktop XjRibbon MVP to Xojo Web. The ribbon toolbar is drawn entirely on a `WebCanvas` subclass. The web project skeleton already has `XjRibbon` inheriting from `WebCanvas` and placed on `MainWebPage` at 600x121px.

## Key API Differences from Desktop

| Desktop | Web | Notes |
|---------|-----|-------|
| `DesktopCanvas` | `WebCanvas` | Base class |
| `Paint(g As Graphics, areas() As Rect)` | `Paint(g As WebGraphics)` | No areas param, WebGraphics type |
| `MouseDown(x,y) As Boolean` | `MouseDown(x,y)` | No return value (Sub not Function) |
| `MouseExit()` | *(not available)* | Track via MouseMove bounds check |
| `g.FillRoundRectangle(x,y,w,h,cw,ch)` | `g.FillRoundRectangle(x,y,w,h,cw)` | Single corner param |
| `g.Transparency = 60` | Color alpha: `Color.RGB(r,g,b, 153)` | No Transparency property |
| `DesktopMenuItem` | `WebMenuItem` | For popup menus (Phase 2) |
| `MessageBox("text")` | `MessageBox("text")` | Works in web too |

## Architecture

Same three-tier model as desktop — data model classes are **identical** (no platform-specific code):
```
XjRibbon (WebCanvas) → mTabs() → XjRibbonTab → mGroups() → XjRibbonGroup → mItems() → XjRibbonItem
```

## Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `XjRibbonItem.xojo_code` | **Copy from desktop** | Identical data model |
| `XjRibbonGroup.xojo_code` | **Copy from desktop** | Identical data model (except DesktopMenuItem → remove mMenuItems for MVP) |
| `XjRibbonTab.xojo_code` | **Copy from desktop** | Identical data model |
| `XjRibbon.xojo_code` | **Rewrite** | WebCanvas rendering + web mouse events |
| `XjRibbon.xojo_project` | **Modify** | Register 3 new classes |
| `MainWebPage.xojo_code` | **Modify** | Demo data in Shown event + ItemPressed handler |

## Key Implementation Differences

1. **Paint**: `Sub Paint(g As WebGraphics)` — no `areas()` param, no `#Pragma Unused`
2. **MouseDown**: `Sub MouseDown(x As Integer, y As Integer)` — void, no `Return True`
3. **No MouseExit**: Check bounds in MouseMove: `If x < 0 Or y < 0 Or x > Me.Width Or y > Me.Height Then ClearHoverStates`
4. **FillRoundRectangle**: Single corner param: `g.FillRoundRectangle(x, y, w, h, 4)`
5. **Demo wiring**: Use `Shown` event (not `Opening`) on MainWebPage per Xojo Web best practice
6. **MainWebPage format**: Uses `#tag WebPageCode` for page-level code

## Implementation Steps

1. Copy XjRibbonItem, XjRibbonGroup, XjRibbonTab from desktop
2. Register classes in web .xojo_project
3. Implement XjRibbon.xojo_code for WebCanvas
4. Wire MainWebPage with demo data
5. Test in browser (port 8080)

## Verification

1. Run project — opens browser at localhost:8080
2. 3 tabs (Home, Insert, View) with groups and buttons
3. Tab switching works
4. Hover highlights on mouse move
5. Button click fires ItemPressed with correct tag
