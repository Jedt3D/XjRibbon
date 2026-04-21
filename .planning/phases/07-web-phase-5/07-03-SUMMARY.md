---
phase: 07-web-phase-5
plan: "03"
subsystem: ui
tags: [xojo, web, ribbon, webcanvas, checkbox, splitbutton, separator, drawing]

# Dependency graph
requires:
  - phase: 07-web-phase-5
    plan: "01"
    provides: IsSplitButton property on web XjRibbonItem
  - phase: 07-web-phase-5
    plan: "02"
    provides: AddSplitButton, AddCheckBox, AddSeparator factory methods on web XjRibbonGroup
  - phase: 05-desktop-complete-control-set
    provides: Reference implementation for all drawing, layout, hit-test patterns
provides:
  - All rendering, layout, hit-test and dispatch for Phase 5 control types in web/XjRibbon.xojo_code
  - DrawCheckBoxItem private method with 16px glyph, blue+checkmark checked state
  - LayoutTabs CheckBox batch stacking (3-per-column) and Separator column bump
  - SplitButton separator line + arrow zone chevron in DrawDropdownButton
  - DrawLargeButton with drawBodyW, belowY vertical centering, Chr(10) multi-line, SplitButton right-align
  - Pressed event inline SplitButton body/arrow hit-test
  - Group caption font fixed to 10pt matching desktop
  - Phase 5 demo in MainWebPage Shown event (View tab: Show/hide group + Panes group)
affects:
  - 07-web-phase-5 plan 04 (verification/testing of completed canvas changes)

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Web FillRoundRectangle/DrawRoundRectangle use 5 args (x,y,w,h,r) — never 6 like desktop"
    - "Text measurement via MeasureTextWidth/MeasureTextHeight helpers (never g.TextWidth on WebGraphics)"
    - "SplitButton hit-test computed inline in Pressed event using x coordinate — no mPressedOnArrow property needed"
    - "CheckBox ItemType=3 uses IsToggle=True — falls into existing Else branch in Pressed, no extra Case needed"
    - "Case 4 in DrawGroups Select Case with comment prevents Separator from triggering DrawLargeButton render artifact"
    - "LayoutTabs Else branch auto-expands button width from MeasureTextWidth — replaces fixed kLargeButtonWidth"

key-files:
  created: []
  modified:
    - web/XjRibbon.xojo_code
    - web/MainWebPage.xojo_code

key-decisions:
  - "Case 4 comment-only in DrawGroups is mandatory — prevents zero-bounds Separator calling DrawLargeButton"
  - "No mPressedOnArrow property on web canvas — x coordinate available inline in Pressed event"
  - "CheckBox glyph size 16 (desktop 13 * 1.2 = 15.6, rounded up) — consistent with 120% web scaling"
  - "kArrowZoneWidth=24 (desktop 20 * 1.2) — fixed pixel threshold in Pressed SplitButton dispatch"
  - "DrawLargeButton text: drawBodyW excludes arrow zone for SplitButton; belowY/belowH vertical centering replaces fixed +12 offset"
  - "Multi-line caption via Chr(10) split in both LayoutTabs Else branch and DrawLargeButton — parity with desktop"
  - "SplitButton body text right-aligned (bx + drawBodyW - textW - 4) while regular button text is centered"

patterns-established:
  - "Web canvas changes use Python string replacement for exact tab-matching rather than Edit tool"
  - "All new web drawing methods verified: count FillRoundRectangle args = 5, grep g.TextWidth = 0 hits"

requirements-completed:
  - REQ-702
  - REQ-703
  - REQ-704

# Metrics
duration: 30min
completed: "2026-04-21"
---

# Phase 7 Plan 03: Web Canvas Drawing, Layout, Hit-Test and Visual Polish Summary

**9 targeted changes to web/XjRibbon.xojo_code: constants, DrawCheckBoxItem, DrawGroups dispatch, DrawDropdownButton SplitButton, DrawLargeButton polish, LayoutTabs auto-expand + CheckBox batch + Separator, Pressed inline hit-test, and group font 10pt**

## Performance

- **Duration:** ~30 min
- **Started:** 2026-04-21T06:50:00Z
- **Completed:** 2026-04-21T07:20:00Z
- **Tasks:** 2 (+ 1 checkpoint awaiting human verification)
- **Files modified:** 2

## Accomplishments

- Added `kItemTypeCheckBox=3`, `kItemTypeSeparator=4`, `kArrowZoneWidth=24` constants to web/XjRibbon.xojo_code
- `DrawCheckBoxItem` new Private Sub: 16px glyph, blue fill + white checkmark (checked), white+border (unchecked), MeasureTextHeight vertical centering, all FillRoundRectangle/DrawRoundRectangle calls with exactly 5 args
- `DrawGroups` Case 3 dispatches DrawCheckBoxItem; Case 4 no-render prevents Separator fallthrough artifact
- `DrawDropdownButton` SplitButton branch: vertical separator line at `mBoundsW - kArrowZoneWidth`, chevron in arrow zone
- `DrawLargeButton` fully polished: drawBodyW, belowY/belowH vertical centering, Chr(10) multi-line, SplitButton right-align
- `LayoutTabs` CheckBox batch (3-per-col, MeasureTextWidth), Separator (itemX bump), Else auto-expand from caption text
- `Pressed` event: inline SplitButton body/arrow dispatch — no stored state property needed
- Group caption font changed from 11pt to 10pt matching desktop
- Phase 5 demo added to `web/MainWebPage.xojo_code` Shown event: View tab with Show/hide CheckBox group, Separator, SplitButton Panes group

## Task Commits

Each task was committed atomically:

1. **Task 1: Constants, Pressed SplitButton dispatch, DrawGroups Case 3/4, group font 10** - `b2bb945` (feat)
2. **Task 2: LayoutTabs + DrawDropdownButton + DrawLargeButton polish + DrawCheckBoxItem** - `c220d55` (feat)
3. **Demo code: MainWebPage Phase 5 View tab demo** - `0cc0ac6` (feat)

**Plan metadata:** (docs commit follows)

## Files Created/Modified

- `web/XjRibbon.xojo_code` - 9 targeted changes: constants, dispatch, drawing methods, layout, hit-test (file grew from 1278 to ~1444 lines)
- `web/MainWebPage.xojo_code` - Phase 5 demo code added to Shown event (18 lines added)

## Decisions Made

- `Case 4` comment-only in DrawGroups is architecturally mandatory — without it, Separator (mBoundsW=0, mBoundsH=0) falls into DrawLargeButton and renders a filled rectangle at (0,0)
- No `mPressedOnArrow` property added to web canvas — web `Pressed` event fires with x coordinate at click time, so the body/arrow split is computed inline; this is simpler and avoids polluting the canvas state
- `CheckBox` (ItemType=3) uses `IsToggle=True` set by `AddCheckBox` — falls into the existing `Else` branch in Pressed naturally; no separate Case in Pressed needed
- Glyph size 16 (not 13 from desktop) — consistent with 120% web scaling convention throughout the web library
- `drawBodyW = If(item.IsSplitButton, bw - kArrowZoneWidth, bw)` — prevents large button text from rendering under the arrow zone

## Deviations from Plan

None - plan executed exactly as written. All 9 changes (A through I) implemented as specified.

## Issues Encountered

- Edit tool could not match indentation in the Pressed event block due to tab/space mix — resolved by using Python string replacement with explicit `\t` characters for exact tab matching. All subsequent replacements also used Python for reliability.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- `web/XjRibbon.xojo_code` is complete for Phase 7 canvas work
- `web/MainWebPage.xojo_code` has demo code for all new control types
- Human verification (Task 3 checkpoint) is pending: open web project in Xojo IDE, compile, run in browser, verify View tab rendering for CheckBox, Separator, SplitButton, and group caption font
- If verification passes, Phase 7 (07-web-phase-5) is functionally complete

## Known Stubs

None — all new control types are wired to real data from the demo setup. No placeholder rendering paths remain.

## Self-Check: PASSED

- web/XjRibbon.xojo_code: FOUND
- web/MainWebPage.xojo_code: FOUND
- 07-03-SUMMARY.md: FOUND
- Commit b2bb945 (Task 1): FOUND
- Commit c220d55 (Task 2): FOUND
- Commit 0cc0ac6 (Demo): FOUND
- kItemTypeCheckBox, kItemTypeSeparator, kArrowZoneWidth: PRESENT
- DrawCheckBoxItem, Case 3, Case 4: PRESENT
- IsSplitButton And x (Pressed inline): PRESENT
- FontSize = 10 (group caption): PRESENT
- cbBatch (CheckBox layout), IsSplitButton Then btnW: PRESENT
- drawBodyW, belowY (DrawLargeButton polish): PRESENT
- No 6-arg FillRoundRectangle calls: CONFIRMED

---
*Phase: 07-web-phase-5*
*Completed: 2026-04-21*
