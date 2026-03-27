# Decision Record: Web Hover & Tooltip Approach

**Date:** 2026-03-28
**Status:** Decided — Option 2 implemented in Phase 2.5

---

## Problem

WebCanvas in Xojo 2025 has no `MouseMove` event. Only `Pressed(x, y)` fires — on click only. This means:

- **No hover highlights** on buttons or tabs (the draw code checks `mIsHovered` but nothing ever sets it)
- **No per-item tooltips** (can't detect which item the cursor is over without mouse tracking)
- The desktop version has full hover support via native `MouseMove`, `MouseUp`, `MouseExit` events

Both hover and tooltips share the same root cause: **no way to know where the mouse is until the user clicks.**

---

## Options Evaluated

### Option 1: WebSDK Custom Control

Replace `WebCanvas` with a fully custom web control built via Xojo's Web Control SDK. Client-side JavaScript handles all rendering (HTML5 Canvas or DOM), mouse events, hover, and tooltips natively in the browser.

| Aspect | Detail |
|--------|--------|
| Code shared with desktop | ~20% (data model classes only) |
| Rendering engine | JavaScript (separate from Xojo) |
| Hover latency | Zero (native browser events) |
| Tooltip approach | Native browser `title` or custom JS |
| Effort | High — essentially a full rewrite in JS |
| Maintenance | Two renderers to keep in sync |

### Option 2: JavaScript MouseMove Injection

Keep `WebCanvas` and all Xojo drawing code. Inject a `mousemove`/`mouseleave` event listener on the canvas DOM element via `ExecuteJavaScript`. The JS reports mouse position back to the server using `window.location.hash`, detected by `Session.HashtagChanged`.

| Aspect | Detail |
|--------|--------|
| Code shared with desktop | ~95% (nearly identical XjRibbon.xojo_code) |
| Rendering engine | Same Xojo `WebGraphics` as MVP |
| Hover latency | 50-200ms (server round-trip per hover change) |
| Tooltip approach | JS `title` attribute on canvas element |
| Effort | Low — ~30 lines JS + ~60 lines Xojo handlers |
| Maintenance | One renderer, minimal JS glue |

### Option 3: CSS/HTML Overlay (Hybrid)

Keep `WebCanvas` for background rendering. Overlay invisible HTML `<div>` elements positioned over each button. CSS `:hover` handles highlights, `title` attributes handle tooltips, `onclick` handles clicks.

| Aspect | Detail |
|--------|--------|
| Code shared with desktop | ~70% (drawing shared, overlay management added) |
| Rendering engine | Xojo `WebGraphics` + HTML overlay layer |
| Hover latency | Zero (pure CSS, no server round-trip) |
| Tooltip approach | Native browser `title` on overlay divs |
| Effort | Medium — overlay lifecycle management |
| Maintenance | Two rendering layers to keep in sync |

---

## Comparison Matrix

| Criteria | Option 1: WebSDK | Option 2: JS MouseMove | Option 3: HTML Overlay |
|----------|:-----------------:|:----------------------:|:----------------------:|
| Code similarity to desktop | Low | **Highest** | Medium |
| Hover appearance match | Different (JS render) | **Pixel-identical** | Close (CSS-based) |
| Same mIsHovered code path | No | **Yes** | No |
| Same draw methods | No | **Yes** | Partially |
| Hover latency | None | 50-200ms | None |
| Implementation effort | High | **Low** | Medium |
| Lines of new code | ~500 JS + glue | **~90 Xojo + 20 JS** | ~100 JS + overlay mgmt |
| Maintenance burden | Two renderers | **Minimal** | Two layers |
| Data model classes shared | Yes | **Yes** | Yes |

---

## Decision: Option 2

We chose **Option 2 (JavaScript MouseMove Injection)** because:

1. **Maximum code similarity** — The web `XjRibbon.xojo_code` is ~95% identical to desktop. Same `LayoutTabs()`, same `DrawLargeButton()`, same `DrawSmallButton()`, same `mIsHovered`/`mIsPressed` flags, same `ResolveColors()` dark mode system, same `HitTestTabs()`/`HitTestItems()`.

2. **Pixel-identical hover rendering** — The same Xojo draw code runs for both desktop and web. Hover highlights look exactly the same because they go through the same `cItemHoverBackground` / `cTabHoverBackground` color properties.

3. **Minimal code change** — Only ~90 lines of Xojo (4 new methods + 1 property) and ~20 lines of injected JavaScript. No new files, no new classes, no architectural changes.

4. **Proven pattern** — The `window.location.hash` ��� `Session.HashtagChanged` callback was already working for dropdown menus. Adding mouse tracking reuses the same infrastructure.

5. **Acceptable latency** — The 60ms JS throttle + server round-trip produces visible but tolerable delay. Most moves within the same button bounds produce zero repaints (the `needsRefresh` guard skips redundant refreshes).

---

## Outcome

**Implemented in Phase 2.5** with 4 commits:

1. Fixed `DrawSmallButton` missing hover/pressed background
2. Added `InjectMouseTracking()` — JS `mousemove` (60ms throttle) + `mouseleave` listeners
3. Added `HandleMouseMove()`, `HandleMouseLeave()`, `UpdateTooltip()` server handlers + Session routing
4. Added `TooltipText` on demo items (Paste, Cut, Copy, Shapes)

**What works:**
- Tab hover highlights
- Large button hover highlights
- Small button hover highlights
- Mouse-leave clears all highlights
- Per-item native browser tooltips via JS `title` attribute
- Dropdown menus still work alongside hover tracking

**Known limitations:**
- Hover has slight latency (server round-trip) — acceptable
- Tooltip updates have same latency — acceptable
- No `mIsPressed` visual feedback (would need MouseDown/MouseUp, not just Pressed)
