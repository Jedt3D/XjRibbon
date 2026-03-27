# XjRibbon Web Phase 3 — Collapse, Contextual Tabs, 120% Scale

## Context

Port of desktop Phase 3 to WebCanvas, plus web-specific enhancements.

## Features Implemented

### Ribbon Collapse
- Double-click tab or chevron button to toggle (same as desktop)
- Canvas resizes to tab strip height (31px at 120%) when collapsed
- No window resize (web platform) — instead, JS moves sibling DOM elements
- `AdjustSiblingPositions()` via `ExecuteJavaScript` repositions elements below canvas
- No peek behavior (same decision as desktop — interferes with double-click)
- `SetCollapsed()`, `IsCollapsed()`, `BottomEdge()` API same as desktop
- `CollapseStateChanged` event defined but consumer cannot implement it (Xojo Web limitation — "superclass already implemented" error). Use JS sibling adjustment instead.

### Contextual Tabs
- Same API as desktop: `AddContextualTab()`, `ShowContextualTabs()`, `HideContextualTabs()`
- Colored accent bar (3px) on contextual tab headers
- Hidden by default, shown via `ShowContextualTabs("group name")`

### 120% Scale (web-only)
All dimensions scaled to 120% for better proportions alongside Xojo web controls:

| Constant | Desktop | Web (120%) |
|----------|---------|------------|
| kTabStripHeight | 24 | 29 |
| kContentTop | 26 | 31 |
| kLargeButtonWidth | 56 | 67 |
| kLargeButtonIconSize | 32 | 38 |
| kSmallButtonHeight | 22 | 26 |
| kSmallButtonIconSize | 16 | 19 |
| Tab font | 11pt | 13pt |
| Item/label font | 9pt | 11pt |
| Icon letter font | 16pt | 19pt |
| Canvas height | 122px | 146px |

## Web-Specific Issues Encountered

1. **CollapseStateChanged hook**: Consumer page cannot implement this event — Xojo says "superclass already implemented." Workaround: XjRibbon handles sibling repositioning internally via JS.
2. **XjRibbonTab copy**: File copy from desktop didn't persist (linter reverted). Had to add contextual properties directly.
3. **No window resize**: Web pages don't support programmatic height changes like desktop windows.
