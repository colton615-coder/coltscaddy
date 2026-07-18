# Caddy Call Command-First Design QA

- Source visual truth: `Proof/caddy-call-command-first-reference.png`
- Implementation screenshot: `Proof/caddy-call-command-first-runtime.png`
- Normalized comparison: `Proof/caddy-call-command-first-comparison.png`
- Source size: 852 x 1846 pixels
- Runtime viewport: iPhone 17 Pro simulator, 402 x 874 points, dark mode
- State: 450-yard tee shot with OB marked; primary recommendation collapsed;
  Alternate and reminder collapsed; Log result enabled

## Full-view comparison evidence

The combined side-by-side keeps the complete reference and runtime screen in
one image. The runtime matches the selected command-first structure: compact
user summary, one Caddy Call surface, club and carry lockup, strong target
command, split Safe miss / Why band, restrained amber Alternate disclosure,
and a compact reminder / Log result action rail.

## Required fidelity surfaces

- Typography: SF Rounded and semantic Dynamic Type styles preserve the source's
  command hierarchy without fixed-size accessibility failures.
- Spacing and density: the live card retains the source's tight vertical rhythm,
  thin dividers, aligned two-column information band, and compact action rail.
- Color: near-black background, cool dark card, cyan recommendation accent,
  amber alternate action, and quiet gray detail text match the selected visual.
- Icons: production uses native SF Symbols. `figure.golf` replaces the generated
  custom club mark while keeping the same visual weight and alignment.
- Copy: the dedicated fixture renders `3 Hybrid`, `200 yds`, and
  `Aim at the widest fairway`. Engine-owned Safe miss and Why copy remain live
  rather than being hard-coded to the mock.

## Focused-region evidence

A separate crop is unnecessary. The normalized 1728 x 1846 comparison keeps
the full card readable at original reference height, including every divider,
label, icon, and control under review.

## Findings

- No actionable P0, P1, or P2 visual differences remain.
- P3: the production user summary uses the app's existing sentence format
  instead of the mock's abbreviated dot-separated format.
- P3: actual deterministic engine copy is slightly longer than the illustrative
  mock copy in Safe miss and Why.
- P3: the native golf figure differs from ImageGen's custom club mark by design;
  no new raster or third-party icon asset was introduced.

## Patches applied during QA

1. Replaced the tall stacked card with the selected command-first composition.
2. Added the missing article so the target reads `Aim at the widest fairway`.
3. Shortened the visible disclosure label from `Alternate play` to `Alternate`
   while retaining the descriptive accessibility label.
4. Recaptured the runtime and regenerated the combined comparison after both
   corrections.

## Interaction verification

- Confirmed the dedicated 450-yard tee-shot fixture renders `3 Hybrid`,
  `200 yds`, the target command, Safe miss, Why, and both action controls.
- Confirmed the existing submitted-shot flow still renders the structured card,
  expands its disclosures, and keeps Log result hittable.
- Confirmed the card provides stacked fallbacks at accessibility Dynamic Type
  sizes and suppresses movement when Reduce Motion is enabled.

final result: passed
