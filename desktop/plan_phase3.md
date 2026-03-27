# XjRibbon Desktop Phase 3 — Ribbon Collapse + Contextual Tabs

## Context

Phases 1-2 complete: tabs, groups, large/small/dropdown buttons, dark mode, icons, tooltips. Phase 3 adds the two most impactful remaining features: ribbon collapse/minimize and contextual tabs. Keyboard navigation and Quick Access Toolbar deferred to Phase 4.

## Scope

| Feature | Phase |
|---------|-------|
| Ribbon collapse/minimize + chevron button | **Phase 3** (this plan) |
| Contextual tabs (show/hide by context) | **Phase 3** (this plan) |
| Keyboard navigation | Phase 4 (deferred) |
| Quick Access Toolbar | Phase 4 (deferred) |

---

## Feature 1: Ribbon Collapse/Minimize

### Visual Behavior
- **Expanded** (default): Full ribbon as today (122px)
- **Collapsed**: Only tab strip (24px) drawn; content area shows blank background
- **Peek**: When collapsed, single-clicking a tab temporarily shows content. Clicking an item fires the action and dismisses peek. MouseExit also dismisses.
- **Toggle**: Double-click a tab header, OR click a chevron button at far-right of tab strip

### Implementation (Steps 1-2)

**Step 1: Core collapse**

New properties on `XjRibbon`:
```
mIsCollapsed As Boolean = False
mIsPeeking As Boolean = False
mLastTabClickTime As Double = 0       // Microseconds timestamp
mLastTabClickIndex As Integer = -1
```

New constant: `kDoubleClickMs = 400000` (microseconds)

New public API:
```
Sub SetCollapsed(value As Boolean)
Function IsCollapsed() As Boolean
Event CollapseStateChanged(isCollapsed As Boolean)
```

Changes to existing methods:
- **Paint**: Guard content drawing: `If Not mIsCollapsed Or mIsPeeking Then DrawContentArea/DrawGroups`
- **LayoutTabs**: Skip item layout when collapsed and not peeking
- **HitTestItems**: Return Nil when collapsed and not peeking
- **MouseDown**: Detect double-click on tab (compare `Microseconds` timestamps). Single-click on tab when collapsed → activate peek
- **MouseUp**: After item action during peek → dismiss peek
- **MouseExit**: If peeking → dismiss peek

**Step 2: Chevron button**

New constant: `kCollapseChevronSize = 12`
New color: `cCollapseChevronColor` in ResolveColors

New methods:
- `DrawCollapseChevron(g)` — Draws "^" or "v" at far-right of tab strip
- `HitTestCollapseChevron(x, y) As Boolean`

Wire into Paint (after DrawTabStrip) and MouseDown (before tab hit-test).

---

## Feature 2: Contextual Tabs

### Visual Behavior
- Contextual tabs appear after regular tabs with a **colored accent bar** (3px, configurable color)
- Subtle colored background tint on the tab header
- Hidden by default — consumer app calls `ShowContextualTabs("Table Tools")` to reveal
- When hidden, they take no space in the tab strip

### Implementation (Steps 3-4)

**Step 3: Data model + API**

New properties on `XjRibbonTab`:
```
IsContextual As Boolean = False
ContextGroup As String = ""
ContextAccentColor As Color
IsContextVisible As Boolean = False
```

New public methods on `XjRibbon`:
```
Function AddContextualTab(caption As String, contextGroup As String, accentColor As Color) As XjRibbonTab
Sub ShowContextualTabs(contextGroup As String)
Sub HideContextualTabs(contextGroup As String)
Sub HideAllContextualTabs()
Function IsContextualTabVisible(contextGroup As String) As Boolean
```

New private helper: `EnsureValidActiveTab()` — if active tab is a hidden contextual tab, switch to first regular tab.

**Step 4: Rendering + hit-testing**

Modify these methods to skip invisible contextual tabs:
- `LayoutTabs` — `If tab.IsContextual And Not tab.IsContextVisible Then Continue`
- `DrawTabStrip` — Skip hidden; draw accent bar + tint for visible contextual tabs
- `HitTestTabs` — Skip hidden contextual tabs
- `SelectTab` — Reject selection of hidden contextual tab

---

## Step 5: Demo + Test

Update `MainWindow.Opening`:
- Add contextual tabs: "Design" (Table Tools, green), "Format" (Picture Tools, orange)
- Add two `DesktopButton` controls in MainWindow to toggle contextual tab visibility
- Test: double-click collapse, chevron toggle, peek behavior, contextual show/hide

---

## Files Modified

| File | Steps | Changes |
|------|-------|---------|
| `desktop/XjRibbon.xojo_code` | 1-4 | Collapse properties/methods/guards, chevron drawing, contextual tab API + rendering |
| `desktop/XjRibbonTab.xojo_code` | 3 | IsContextual, ContextGroup, ContextAccentColor, IsContextVisible properties |
| `desktop/MainWindow.xojo_window` | 5 | Demo contextual tabs + toggle buttons |

## New Public API Summary

```xojo
// Collapse
XjRibbon.SetCollapsed(value As Boolean)
XjRibbon.IsCollapsed() As Boolean
Event CollapseStateChanged(isCollapsed As Boolean)

// Contextual Tabs
XjRibbon.AddContextualTab(caption, contextGroup, accentColor) As XjRibbonTab
XjRibbon.ShowContextualTabs(contextGroup)
XjRibbon.HideContextualTabs(contextGroup)
XjRibbon.HideAllContextualTabs()
XjRibbon.IsContextualTabVisible(contextGroup) As Boolean

// XjRibbonTab properties
IsContextual As Boolean
ContextGroup As String
ContextAccentColor As Color
IsContextVisible As Boolean
```

## Backward Compatibility

- `mIsCollapsed = False` by default → no visual change for existing users
- `IsContextual = False` by default → all existing tabs are regular
- All existing API (AddTab, SelectTab, ItemPressed, etc.) works unchanged
- Canvas height stays 122px; collapse is purely a rendering decision

## Verification

1. Run project — ribbon looks identical to Phase 2 (no regression)
2. Double-click a tab — ribbon collapses to tabs-only
3. Double-click again — ribbon expands
4. Click chevron button — toggles collapse
5. When collapsed, click a tab — content peeks temporarily
6. Click a button while peeking — action fires, peek dismisses
7. Move mouse off canvas while peeking — peek dismisses
8. Toggle "Table Tools" button — contextual tab appears with green accent
9. Click contextual tab — shows its groups/buttons
10. Hide contextual tabs while one is active — switches to first regular tab
