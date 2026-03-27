# XjRibbon Web Phase 2.5 — Hover Effects & Tooltips via JS MouseMove

## Context

WebCanvas has no `MouseMove` event — only `Pressed(x, y)` on click. The desktop version has full hover support (highlights, tooltips) via native MouseMove. The web draw methods already check `mIsHovered`/`mIsPressed` flags but nothing ever sets them. This phase injects a JavaScript `mousemove` listener on the canvas DOM element and uses the proven `window.location.hash` → `Session.HashTagChanged` callback pattern (same as dropdowns).

## Goal

Make hover behavior **identical to desktop** — same highlight colors, same code paths, same mIsHovered flags. Only the event delivery mechanism differs (JS injection vs native event).

## Architecture

```
Browser: mousemove on canvas DOM → JS throttled (60ms) → hash = "xjmm:x:y"
Browser: mouseleave on canvas DOM → hash = "xjml"
    ↓
Session.HashTagChanged → parse prefix → XjRibbon1.HandleMouseMove(x, y) or HandleMouseLeave()
    ↓
Same hit-test + hover logic as desktop → Refresh → Paint with highlights
```

## Implementation Steps (4 commits)

### Step 1: Fix DrawSmallButton missing hover rendering

**File: `web/XjRibbon.xojo_code`**

The web `DrawSmallButton` is missing the hover/pressed background that desktop has. Add at top of method:
```xojo
If item.mIsPressed Then
  g.DrawingColor = cItemPressedBackground
  g.FillRoundRectangle(bx, by, bw, bh, 3)
ElseIf item.mIsHovered Then
  g.DrawingColor = cItemHoverBackground
  g.FillRoundRectangle(bx, by, bw, bh, 3)
End If
```

### Step 2: Add JS mouse tracking injection

**File: `web/XjRibbon.xojo_code`**

Add property:
```
Private mMouseTrackingInjected As Boolean = False
```

Add private method `InjectMouseTracking()`:
- Uses `Me.ControlID` to find the canvas DOM element
- Attaches `mousemove` listener with 60ms throttle (timestamp check)
- Attaches `mouseleave` listener
- `mousemove` → `window.location.hash = "xjmm:" + x + ":" + y`
- `mouseleave` → `window.location.hash = "xjml"`
- Guard flag `_xjmmAttached` on DOM element prevents double-attachment

Call at end of `Paint` event (first paint only):
```xojo
If Not mMouseTrackingInjected Then
  InjectMouseTracking
  mMouseTrackingInjected = True
End If
```

### Step 3: Add server-side handlers + tooltip update

**File: `web/XjRibbon.xojo_code`**

Add public method `HandleMouseMove(x As Integer, y As Integer)`:
- Same logic as desktop MouseMove: hit-test tabs/items, update mIsHovered flags
- Call `UpdateTooltip` helper
- Call `Me.Refresh` only if state changed

Add public method `HandleMouseLeave()`:
- Call `ClearHoverStates` + `Me.Refresh`

Add private method `UpdateTooltip()`:
- If hovered item has TooltipText → set `Me.Tooltip`
- If hovered tab → set `Me.Tooltip` to tab caption
- Otherwise → clear tooltip

**File: `web/Session.xojo_code`**

Extend `HashTagChanged` with two new prefix handlers:
- `xjmm:x:y` → parse and call `MainWebPage.XjRibbon1.HandleMouseMove(x, y)`
- `xjml` → call `MainWebPage.XjRibbon1.HandleMouseLeave`

### Step 4: Update demo with tooltips + test

**File: `web/MainWebPage.xojo_code`**

Capture button references (change `Call` to `Var btn As XjRibbonItem =`) and set `TooltipText` on Paste, Cut, Copy, and Shapes buttons.

## Files Modified

| File | Changes |
|------|---------|
| `web/XjRibbon.xojo_code` | Fix DrawSmallButton hover, add InjectMouseTracking, HandleMouseMove, HandleMouseLeave, UpdateTooltip, mMouseTrackingInjected property, Paint injection call |
| `web/Session.xojo_code` | Add xjmm: and xjml prefix handling in HashTagChanged |
| `web/MainWebPage.xojo_code` | Set TooltipText on demo items |

## Throttling & Performance

- 60ms floor → max ~16 hash changes/sec
- `HandleMouseMove` only calls `Refresh` when hover state changes (needsRefresh guard)
- Moves within same item bounds = no repaint
- Ribbon drawing is simple flat fills, no performance concern
- Hash collision with dropdown: not an issue — dropdown overlay captures mouse events, `Return` in HashTagChanged prevents multi-processing

## Verification

1. Hover over tabs — inactive tabs highlight, active tab unchanged
2. Hover over large buttons — rounded-rect highlight appears
3. Hover over small buttons — highlight appears (was previously missing)
4. Mouse leaves canvas — all highlights clear
5. Items with TooltipText show browser tooltip on hover
6. Tab switch clears hover states
7. Dropdown still works while hover tracking is active
8. No JS errors in browser DevTools console
9. Rapid mouse movement — smooth tracking, no jitter
