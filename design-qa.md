# Scorecard Daylight Theme Design QA

- Source visual truth:
  `/Users/colton/Desktop/COLTSCADDY-Daylight-QA-2026-07-18-1449/Screenshots/00-scorecard-daylight-source.png`
- Primary implementation screenshot:
  `/Users/colton/Desktop/COLTSCADDY-Daylight-QA-2026-07-18-1449/Screenshots/04-caddy-call-collapsed.png`
- Normalized comparison:
  `/Users/colton/Desktop/COLTSCADDY-Daylight-QA-2026-07-18-1449/Screenshots/09-source-runtime-comparison.png`
- Runtime viewport: iPhone 17 Pro simulator, 402 x 874 points, fixed light theme
- Primary state: 165-yard fairway full shot; Alternate and reminder collapsed;
  Log result enabled

## Full-view comparison evidence

The normalized side-by-side shows the complete selected direction and the live
runtime at matching full-screen scale. The implementation carries the selected
warm paper background, soft neutral surfaces, warm charcoal ink, forest-green
user bubble and primary actions, and flag-red Caddy Call eyebrow into the
existing production layout.

The source mock's layout, green Alternate row, and decorative grid are not
literal implementation targets in this loop. The task explicitly locks the
existing layout, overrides Alternate to amber, and makes the grid optional.

## Required fidelity surfaces

- Typography: SF Rounded and all existing type sizes and hierarchy are retained.
- Spacing and layout: the production ThreadView, compact Caddy Call, disclosure
  states, sheets, tray, bag editor, and composer geometry are unchanged.
- Color: every production color continues to flow through `DS.Color`; no view
  introduces a hardcoded color.
- Imagery and icons: existing native SF Symbols are unchanged. The source's
  generated device frame and decorative treatment are reference presentation,
  not app assets.
- Copy: production retains engine-owned and app-owned copy rather than replacing
  it with illustrative mock text.

## Focused-state evidence

Separate full-resolution captures were reviewed because color behavior depends
on state and several important details are too small in the combined comparison:

- `01-thread-view.png`
- `02-chat-input-bar.png`
- `03-shot-input-tray.png`
- `04-caddy-call-collapsed.png`
- `05-caddy-call-alternate-expanded.png`
- `06-caddy-call-reminder-expanded.png`
- `07-outcome-picker-sheet.png`
- `08-bag-editor-view.png`

All are in
`/Users/colton/Desktop/COLTSCADDY-Daylight-QA-2026-07-18-1449/Screenshots/`.

## Contrast evidence

- Primary ink `#202720` on background `#F7F3E8`: 13.80:1
- Primary ink `#202720` on surface `#ECE6D9`: 12.30:1
- Cream accent ink `#FFF9EE` on forest green `#285C3D`: 7.45:1
- Flag red `#A33A32` on surface `#ECE6D9`: 5.26:1
- Amber text `#6B4A08` on amber fill `#F3E1A9`: 6.19:1

All required pairings pass WCAG AA. The tightest additional text pairing is
tertiary text `#5D675F` on surface `#ECE6D9` at 4.73:1.

## Findings

- No actionable P0, P1, or P2 visual differences remain within the locked
  token-and-fill scope.
- P3: the flat paper background is intentionally cleaner than the source's
  subtle grid. The optional grid was skipped because the theme reads as paper
  without adding a decorative layer to every screen.
- P3: the amber disclosure is intentionally different from the green row in the
  mock because amber remains the Alternate semantic color.

## Patches applied during QA

1. Replaced the Range Finder tokens with the WCAG-checked Scorecard Daylight
   palette and removed the unused confidence color tokens.
2. Assigned light accent ink to forest-green user bubbles and primary controls.
3. Assigned flag red only to the Caddy Call eyebrow.
4. Added the warm amber Alternate fill without changing disclosure geometry.
5. Fixed the app to the single Daylight color scheme.

## Interaction verification

- The complete `COLTSCADDYTests` target passed 22 tests.
- The focused structured-card/outcome flow and compact Caddy Call UI tests
  passed; the bag-button route test also passed for screenshot coverage.
- Simulator observation covers the collapsed card, both expanded disclosures,
  outcome sheet, shot tray, bag editor, ThreadView, and ChatInputBar.
- No physical-device observation has occurred.

final result: passed
