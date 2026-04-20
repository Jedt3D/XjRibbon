---
phase: 05-desktop-complete-control-set
plan: "04"
subsystem: desktop-demo
tags: [xojo, desktop, ribbon, checkbox, splitbutton, separator, demo, visual-polish]

# Dependency graph
requires:
  - phase: 05-03
    provides: AddCheckBox, AddSeparator, AddSplitButton factory methods; DrawCheckBoxItem; SplitButton hit-split logic
provides:
  - Show/hide group with 3 checkboxes + separator + small button in demo View tab
  - Panes group with SplitButton "Navigation pane" + 3 menu items in demo View tab
  - End-to-end demo proof that Phase 5 Plans 01-03 compose correctly
  - Visual polish: kArrowZoneWidth constant, auto-width, 2-line caption, vertical text centering, correct caption font
affects: [06-designer-v2, 07-web-phase5]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Call for unused XjRibbonItem returns in Opening event"
    - "#Pragma Unused hiddenCb for initially-checked checkbox with no post-init config"
    - "Groups appended to viewTab local var before contextual tab section"
    - "kArrowZoneWidth=20 fixed-pixel constant for SplitButton hit-test (replaces 80/20 ratio)"
    - "Chr(10) line break in SplitButton label for 2-line caption rendering"
    - "Large button text vertically centered in below-icon area (belowY + (belowH+th)/2)"

key-files:
  created: []
  modified:
    - desktop/MainWindow.xojo_window
    - desktop/XjRibbon.xojo_code

key-decisions:
  - "Use Call for first two AddCheckBox calls (returns not needed, follows existing project convention)"
  - "Use Var hiddenCb + #Pragma Unused to exercise optional initialState parameter without compiler warning"
  - "kArrowZoneWidth=20 fixed constant chosen over 80/20 ratio — consistent hit-test across all button widths"
  - "SplitButton label right-aligned with 4px from separator — balances visual weight against arrow zone"
  - "Group caption font settled at 10pt after iterating 11pt (too large), 9pt (too small)"
  - "Two-line label gap set to 1px (tighter than default 3px) for compact large button rendering"

patterns-established:
  - "Demo insertion pattern: append to viewTab local var still in scope, before contextual tab section"
  - "Visual polish iteration during human checkpoint: fix inline, commit incrementally, re-verify"

requirements-completed: [REQ-516]

# Metrics
duration: "~2 hours (including 5 visual polish iterations at checkpoint)"
completed: "2026-04-20"
---

# Phase 5 Plan 04: Demo Update — Show/hide Group and Panes SplitButton Summary

**Show/hide group (3 checkboxes + separator + small button) and Panes group (SplitButton with 3 menu items) added to View tab demo, human-verified with 5 visual polish fixes applied to achieve correct SplitButton rendering, vertical centering, and group caption sizing.**

## Performance

- **Duration:** ~2 hours (including visual polish iterations at checkpoint)
- **Started:** 2026-04-20T13:05:00Z
- **Completed:** 2026-04-20T17:05:00Z (UTC)
- **Tasks:** 2/2 (Task 1 auto, Task 2 checkpoint approved)
- **Files modified:** 2

## Accomplishments

- Inserted 17 lines of Xojo code into MainWindow.Opening event: Show/hide group and Panes group
- Show/hide group: 3 checkboxes (2 unchecked, 1 starts checked via True parameter), separator, small button
- Panes group: SplitButton "Navigation pane" with 3 dropdown menu items attached via AddMenuItem
- Human checkpoint approved: checkboxes toggle correctly, SplitButton body/arrow fire distinct events, existing controls unchanged
- Applied 5 visual polish fixes post-verification: fixed-width arrow zone, auto-width buttons, 2-line labels, vertical centering, correct caption font size

## Task Commits

1. **Task 1: Add Show/hide group and Panes SplitButton group to Opening event** - `5f52d36` (feat)
2. **Task 2: Visual and interactive verification of Phase 5 controls** - Checkpoint approved

**Visual polish fixes applied during/after checkpoint verification:**

- `ed6a62b` — fix(05): SplitButton separator position, auto-width from caption, 2-line label support
- `26748a2` — fix(05): vertical centering and SplitButton text right-alignment
- `105deaa` — fix(05): tighten two-line label gap from 3px to 1px
- `b649023` — fix(05): reduce group caption font size from 11pt to 9pt
- `1febd1d` — fix(05): set group caption font size to 10pt (final)

**Plan metadata:** `99cd47f` (docs: complete demo update plan)

## Files Created/Modified

- `desktop/MainWindow.xojo_window` — Opening event extended with Show/hide group (12 lines) and Panes group (5 lines); Navigation pane label updated to use Chr(10) 2-line split
- `desktop/XjRibbon.xojo_code` — kArrowZoneWidth constant, LayoutGroupItems auto-width, DrawLargeButton 2-line support + vertical centering, DrawDropdownButton separator position, MouseDown hit-test update, group caption font size

## Decisions Made

- `kArrowZoneWidth = 20` fixed-pixel constant replaces 80%/20% ratio — consistent arrow zone width across all button widths, matching standard ribbon design
- SplitButton label text right-aligned with 4px from separator — balances visual weight; left-alignment would crowd against glyph on left
- Group caption font size iterated: 11pt (too large) → 9pt (too small) → 10pt (correct match for standard ribbon proportions)
- Two-line label gap set to 1px — compact rendering; default 3px created excessive spacing between label lines
- Large button text vertically centered using `belowY + (belowH + th) / 2` formula — replaces fixed +12 offset that caused text to sit too close to icon

## Deviations from Plan

### Auto-fixed Issues During Checkpoint

**1. [Rule 1 - Bug] SplitButton separator at inconsistent position**
- **Found during:** Task 2 (human verification checkpoint)
- **Issue:** 80%/20% ratio placed separator at different pixel positions across different button widths, making narrow buttons have a nearly unusable arrow zone
- **Fix:** Introduced `kArrowZoneWidth = 20` constant; separator always at `bw - kArrowZoneWidth`; MouseDown hit-test updated to match
- **Files modified:** desktop/XjRibbon.xojo_code, desktop/MainWindow.xojo_window
- **Committed in:** ed6a62b

**2. [Rule 1 - Bug] SplitButton label clipped due to fixed button width**
- **Found during:** Task 2 (human verification checkpoint)
- **Issue:** "Navigation pane" label was clipped because button width was fixed at kLargeButtonWidth without accounting for caption text length
- **Fix:** LayoutGroupItems now measures text width and auto-expands large/split button width from caption measurement
- **Files modified:** desktop/XjRibbon.xojo_code
- **Committed in:** ed6a62b

**3. [Rule 1 - Bug] Large button text vertically misaligned**
- **Found during:** Task 2 (human verification checkpoint)
- **Issue:** Fixed `+12` offset placed label too close to icon regardless of button height; text appeared near icon top rather than centered below it
- **Fix:** `belowH = bh - 38` below-icon area computed; text centered using `belowY + (belowH + th) / 2`
- **Files modified:** desktop/XjRibbon.xojo_code
- **Committed in:** 26748a2

**4. [Rule 1 - Bug] Two-line label gap too wide**
- **Found during:** Task 2 polish iteration
- **Issue:** 3px gap between wrapped label lines looked loose and unbalanced for compact ribbon buttons
- **Fix:** Reduced to 1px
- **Files modified:** desktop/XjRibbon.xojo_code
- **Committed in:** 105deaa

**5. [Rule 1 - Bug] Group caption font size wrong**
- **Found during:** Task 2 polish iteration
- **Issue:** Initial 11pt caption font was too large relative to group content; 9pt was too small; 10pt is the correct fit
- **Fix:** Iterated 11pt → 9pt → 10pt (two commits: b649023 intermediate, 1febd1d final)
- **Files modified:** desktop/XjRibbon.xojo_code
- **Committed in:** b649023, 1febd1d

---

**Total deviations:** 5 auto-fixed (all Rule 1 - rendering bugs discovered during human visual verification)
**Impact on plan:** All fixes improved rendering correctness and visual polish. All changes are within canvas code already touched by Plans 01-03. No scope creep.

## Issues Encountered

- Group caption font size required two commits to settle (11pt → 9pt → 10pt). The intermediate 9pt commit was immediately superseded by 10pt after visual comparison — minor iteration overhead only.

## User Setup Required

None - no external service configuration required.

## Known Stubs

None. All controls are fully wired: checkboxes read/write `IsToggleActive`, SplitButton body fires `ItemPressed`, arrow fires `DropdownMenuAction`, separator has no interaction surface.

## Threat Flags

None. MainWindow.xojo_window is a demonstration-only window with no network surface, no user data storage, and no auth paths. MessageBox tag strings are developer-defined constants.

## Self-Check: PASSED

- FOUND: desktop/MainWindow.xojo_window (modified and committed)
- FOUND: desktop/XjRibbon.xojo_code (modified in visual polish commits)
- FOUND commit: 5f52d36 (feat - Task 1: Show/hide + Panes groups)
- FOUND commit: ed6a62b (fix - SplitButton separator/auto-width/2-line)
- FOUND commit: 26748a2 (fix - vertical centering + right-alignment)
- FOUND commit: 105deaa (fix - line gap 1px)
- FOUND commit: b649023 (fix - caption font 9pt intermediate)
- FOUND commit: 1febd1d (fix - caption font 10pt final)

## Next Phase Readiness

- Phase 5 is complete: REQ-501 through REQ-516 all satisfied
- Desktop canvas now supports: Large (0), Small (1), Dropdown (2), SplitButton (2+IsSplitButton), CheckBox (3), Separator (4)
- Demo View tab demonstrates all Phase 5 control types with correct event wiring and visual polish
- Phase 6 (Designer v2.0) can add "splitbutton", "checkbox" itemTypes to JSON schema, inspector, and code gen
- Phase 7 (Web Phase 5) can use the desktop canvas implementation as a reference specification

---
*Phase: 05-desktop-complete-control-set*
*Completed: 2026-04-20*
