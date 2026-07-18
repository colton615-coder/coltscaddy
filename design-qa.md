# Caddy Call Design QA

- Source visual truth: `Proof/caddy-call-approved-reference.png`
- Implementation screenshot: `Proof/caddy-call-approved-runtime.png`
- Full-view comparison: `Proof/caddy-call-approved-comparison.png`
- Viewport: iPhone 17 Pro simulator, 402 x 874 points, dark mode
- State: 165-yard clean full shot; Alternate play collapsed; reminder expanded;
  Log result enabled

## Full-view comparison evidence

The normalized side-by-side confirms the selected structure and hierarchy:
user summary, card-only recommendation, CADDY CALL label, club and distance,
stacked Target / Safe miss / Why blocks, amber Alternate play disclosure, cyan
divider, COMMIT TO THIS cue, full-width Log result, reminder control, and bottom
composer. The live chat scroll prioritizes the newest card, so the old greeting
may be outside the viewport; this is an intentional native-scroll difference,
not pinned content from the source mock.

## Required fidelity surfaces

- Fonts and typography: SF Rounded is preserved. Field headings are 21-point
  bold; values are 17-point regular; hierarchy and wrapping remain clear.
- Spacing and layout rhythm: the card uses 16-point inset padding, 12-point
  outer rhythm, full-width controls, 44-point minimum targets, and continuous
  16/14-point radii. The complete latest card and composer remain reachable.
- Colors and visual tokens: near-black background, cool dark surface, primary
  white, bright cool-gray details, cyan semantic accent, and amber alternate
  match the approved direction. The removed green confidence badge does not
  reappear.
- Image quality and asset fidelity: there are no custom raster assets in this
  surface. The golf figure and chevrons use native SF Symbols, matching the
  Apple-native source language.
- Copy and content: the stock-club lead bubble and `Medium-high` badge are gone.
  The clean-full-shot fields read `Center green.`, `Short is fine.`, and
  `Stock number. No need to force it.` The execution cue reads
  `SET THE FACE  •  SET YOUR FEET  •  COMMIT`.

## Focused region comparison

A separate crop was not needed: the normalized full-view comparison retains
the entire 402-point-wide card at readable resolution, including every type,
spacing, token, copy, and control surface under review.

## Findings

- No actionable P0, P1, or P2 differences remain.
- P3: Image generation rendered slightly softer radii and texture than native
  SwiftUI. The implementation intentionally uses flat semantic colors and
  continuous native shapes instead of reproducing generated texture.

## Comparison history

1. First runtime capture: `Hide reminder` was crowded below the visible card
   edge after expansion. Fix: delay the latest-card scroll until the disclosure
   animation finishes.
2. Second runtime capture: all controls were visible, but scrolled conversation
   content could draw in the status-bar region. Fix: clip the conversation feed
   to its bounds and tighten only the card's outer rhythm from 16 to 12 points.
3. Final runtime capture: latest card and composer are visible; card structure,
   typography, tokens, copy, and interaction controls match the approved target
   with no actionable P0/P1/P2 findings.

## Interaction verification

- Submitted the 165-yard shot from the shot tray.
- Confirmed no post-shot lead bubble and no confidence badge.
- Expanded and collapsed Alternate play.
- Expanded and collapsed Remind me how.
- Confirmed Log result remained visible, hittable, and persisted the shot once.

final result: passed
