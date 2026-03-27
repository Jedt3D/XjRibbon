# XjRibbon Web Phase 2 Plan — Enhanced Ribbon Features

## Context

Web MVP is complete. Phase 2 adds the same features as desktop Phase 2, adapted for WebCanvas/WebGraphics API.

## Implementation Order (same as desktop, 7 steps)

| Step | Feature | Web-Specific Notes |
|------|---------|-------------------|
| 1 | Item Type enum + Icon/Tooltip properties | Use `WebMenuItem` instead of `DesktopMenuItem` for mMenuItems |
| 2 | Real icon drawing | No `g.Transparency` — use Color alpha for disabled state |
| 3 | Dark mode color scheme | `Color.IsDarkMode` works in web; also consider `Session.ColorMode` |
| 4 | Small buttons (layout + drawing) | `FillRoundRectangle` single corner param |
| 5 | Dropdown buttons with popup menus | `WebMenuItem.Popup` not available — use `ContextualMenu` or raise event |
| 6 | HiDPI scaling | `Session.ScaleFactor` for web HiDPI |
| 7 | Per-item tooltips | `Me.Tooltip = New WebToolTip(text)` instead of string |

## Key Web API Adaptations

### Disabled Icon Drawing (no g.Transparency)
```xojo
// Desktop: g.Transparency = 60
// Web: draw with alpha in the color, or draw to a Picture first
// Simplest: just gray out the placeholder, skip transparency for real icons in MVP
```

### Dropdown Menus (Step 5)
WebCanvas doesn't have `DesktopMenuItem.PopUp`. Options:
- **Option A**: Set `Me.ContextualMenu` dynamically and trigger via right-click
- **Option B**: Raise `DropdownMenuAction` event and let the page handle it with a `WebPopupMenu`
- **Recommended**: Fire `ItemPressed(tag)` for dropdown items too, let consumer build their own menu UI. Defer full popup to Phase 3.

### Tooltips (Step 7)
```xojo
// Desktop: Me.Tooltip = "text"
// Web: Me.Tooltip = New WebToolTip(text)
// Or: Me.Tooltip.Text = text (if already initialized)
```

### FillRoundRectangle
```xojo
// Desktop: g.FillRoundRectangle(x, y, w, h, 4, 4)
// Web:     g.FillRoundRectangle(x, y, w, h, 4)
```

## Files Modified per Step

Same as desktop — only XjRibbon.xojo_code differs. Data model classes are identical.

| File | S1 | S2 | S3 | S4 | S5 | S6 | S7 |
|------|----|----|----|----|----|----|-----|
| XjRibbonItem.xojo_code | **Major** | — | — | — | — | — | — |
| XjRibbonGroup.xojo_code | **Mod** | — | — | — | — | — | — |
| XjRibbon.xojo_code | Minor | Mod | **Major** | **Major** | Mod | Minor | Minor |
| MainWebPage.xojo_code | — | Demo | — | Demo | Demo | — | Demo |

## Verification

1. Run in browser — all Phase 2 features visible
2. Toggle browser dark mode (or macOS dark mode) — colors adapt
3. Small buttons stack correctly in columns
4. Dropdown buttons show chevron arrow
5. Hover tooltips appear in browser
