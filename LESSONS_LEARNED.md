# XjRibbon Project — Lessons Learned

## Project Summary

Built a Microsoft Office-style ribbon toolbar component for Xojo, targeting both Desktop (DesktopCanvas) and Web (WebCanvas). Phases 1-3 complete on both platforms.

**Timeline:** MVP through Phase 3 in one session
**Architecture:** Three-tier data model (Tab → Group → Item) with centralized canvas rendering
**Platforms:** `desktop/` (DesktopCanvas) and `web/` (WebCanvas) in a monorepo

---

## Critical Errors and Their Fixes

### 1. Xojo: `Me.Invalidate` does not exist
**Error:** `Type "XjRibbon" has no member named "Invalidate"`
**Fix:** Use `Me.Refresh` — Xojo's DesktopCanvas has no `Invalidate` method.

### 2. Xojo: Must use return values
**Error:** `You must use the value returned by this function`
**Fix:** Prefix with `Call` when discarding return values: `Call group.AddLargeButton("Paste", "tag")`

### 3. WebCanvas: MouseDown/MouseUp/MouseMove DO NOT EXIST
**Error:** `You cannot implement a nonexistent event`
**Root cause:** WebCanvas only has `Pressed(x As Integer, y As Integer)` — a single click event. The Xojo docs/skill files incorrectly listed MouseDown/Up/Move as available events.
**Fix:** Use `Pressed` for click handling. For mouse tracking, inject JS `mousemove`/`mouseleave` listeners via `ExecuteJavaScript` and callback via `window.location.hash` → `Session.HashtagChanged`.

### 4. WebGraphics: No TextWidth or TextHeight
**Error:** `Type "WebGraphics" has no member named "TextWidth"`
**Fix:** Create a helper that uses `Picture.Graphics` (which IS the full Graphics class):
```xojo
If mMeasurePic = Nil Then mMeasurePic = New Picture(1, 1)
Var mg As Graphics = mMeasurePic.Graphics
mg.FontSize = fontSize
Return mg.TextWidth(text)
```

### 5. WebGraphics: DrawPicture max 5 parameters
**Error:** `Too many arguments: got 9, expected no more than 5`
**Fix:** Use `g.DrawPicture(pic, x, y, w, h)` — no source rect overload on WebGraphics.

### 6. WebGraphics: FillRoundRectangle single corner param
**Desktop:** `g.FillRoundRectangle(x, y, w, h, cornerW, cornerH)`
**Web:** `g.FillRoundRectangle(x, y, w, h, cornerW)` — single param

### 7. Session.HashtagChanged wrong signature
**Error:** `name is an unused event parameter`
**Root cause:** The event signature is `Sub HashtagChanged(name As String, data As String)`, NOT `Sub HashTagChanged(hashTag As String)`. Note: lowercase 't' in 'tag'.
**Fix:** Parse the `name` parameter for hash data.

### 8. WebCanvas.Tooltip is WebToolTip, not String
**Error:** `Undefined operator. Type WebToolTip does not define "<>" with type String`
**Fix:** Use JavaScript to set the native browser `title` attribute:
```xojo
Me.ExecuteJavaScript("document.getElementById('" + Me.ControlID + "').title='text';")
```

### 9. WebCanvas: CollapseStateChanged event cannot be implemented by consumer
**Error:** `XjRibbon1 on MainWebPage implements the event "CollapseStateChanged," but its superclass XjRibbon has already implemented the event`
**Root cause:** Xojo Web apparently treats `#tag Hook` event definitions differently — the consumer page cannot implement them if the class defines them.
**Workaround:** Handle sibling repositioning internally via JS `AdjustSiblingPositions()` instead of relying on consumer event handler.

### 10. Peek behavior interferes with double-click detection
**Symptom:** First click of double-click activates peek (temporary expand), second click treated as new single click instead of completing double-click.
**Fix:** Remove peek entirely. When collapsed, single-click just switches active tab. Double-click toggles collapse. Simpler and more reliable.

### 11. Desktop collapse: Controls don't auto-reposition
**Symptom:** When ribbon canvas resizes, sibling controls stay at original positions.
**Root cause:** Xojo's layout engine only repositions controls when the WINDOW resizes, not when a sibling control resizes.
**Fix (desktop):** XjRibbon resizes itself AND the parent window. Consumer repositions controls via `CollapseStateChanged` event + `BottomEdge()` helper.
**Fix (web):** XjRibbon repositions sibling DOM elements via JavaScript injection.

### 12. File copies from desktop to web reverted by linter
**Symptom:** Copied XjRibbonTab.xojo_code from desktop to web, but contextual properties were missing on next analysis.
**Root cause:** Xojo IDE or linter may have reverted the file.
**Fix:** Add properties directly via Edit instead of file copy.

---

## Web vs Desktop: Key Architectural Differences

| Aspect | Desktop | Web |
|--------|---------|-----|
| Mouse tracking | Native MouseMove/MouseDown/MouseUp/MouseExit | JS injection + hash callback |
| Text measurement | `g.TextWidth()` on Graphics | `Picture.Graphics.TextWidth()` workaround |
| Tooltips | `Me.Tooltip = "text"` (String) | JS `title` attribute via ExecuteJavaScript |
| Popup menus | `DesktopMenuItem.PopUp` | JS-injected HTML dropdown overlay |
| Rounded rects | `FillRoundRectangle(x,y,w,h,cw,ch)` | `FillRoundRectangle(x,y,w,h,cw)` |
| Icon drawing | `DrawPicture(9 params)` | `DrawPicture(5 params)` |
| Disabled icons | `g.Transparency = 60` | Not available (skip for web) |
| Collapse layout | Window resizes + CollapseStateChanged event | JS sibling repositioning |
| Hash callback | N/A | `Session.HashtagChanged(name, data)` |

## Code Similarity Achieved

Despite the limitations, the web XjRibbon.xojo_code is **~85% identical** to desktop:
- Same data model classes (XjRibbonTab, XjRibbonGroup, XjRibbonItem)
- Same layout algorithm (LayoutTabs)
- Same draw methods (DrawLargeButton, DrawSmallButton, DrawDropdownButton, DrawTabStrip)
- Same hit-test methods (HitTestTabs, HitTestItems)
- Same color system (ResolveColors with dark mode)
- Same public API (AddTab, AddContextualTab, SetCollapsed, etc.)

The ~15% difference is: MeasureTextWidth/Height helpers, JS injection methods, Pressed instead of MouseDown/Up/Move, and single-param FillRoundRectangle.

---

## Skill File Updates Made

Updated `/Users/worajedt/.claude/skills/xojo-web/knowledge/xojo-web.md`:
- Removed incorrect `MouseDown`, `MouseUp`, `MouseMove` from WebCanvas events
- Added detailed WebGraphics limitations (no TextWidth, no Transparency, 5-param DrawPicture)
- Added text measurement workaround pattern
- Added JS mouse tracking injection pattern
- Added `Session.HashtagChanged` correct signature documentation
- Added dynamic tooltip workaround via JS title attribute
