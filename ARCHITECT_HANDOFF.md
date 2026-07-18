# NEW CHAT HANDOFF — COLT'S CADDY / COLTSCADDY

**Current as of:** 2026-07-18

**Repo:** `/Users/colton/Desktop/COLTSCADDY`

**Remote:** `github.com/colton615-coder/coltscaddy`

**Branch:** `main`

**Current production baseline:** `6777494` (`origin/main` before this
handoff-only refresh)

**Working tree before this handoff edit:** clean

Paste this entire file into a new chat. Current source, `Docs/ROADMAP.md`, and
the latest entries in `Docs/DECISIONS.md` outrank this summary if the repo has
advanced since 2026-07-18.

---

## 1. STARTING INSTRUCTION FOR THE NEW CHAT

You are continuing the COLTSCADDY iOS app as the only active editing agent.
Act as a senior SwiftUI / SwiftData engineer and product-design partner.

Before proposing or changing code:

1. Run `git status --short --branch`, `git branch --show-current`, and
   `git log origin/main -5 --oneline --decorate`.
2. Read the ground-truth files in Section 2 in order.
3. Quote the exact `SINGLE NEXT ACTION` from `Docs/ROADMAP.md`.
4. Inspect the current implementation seams and proof artifacts named below.
5. Stop if a pasted prompt conflicts with current source or repo docs.

Use one editing agent only. Other agents may review or advise, but they must not
edit this checkout concurrently. Report build, tests, simulator observation,
physical-device observation, commit, push, and remote visibility as separate
proof claims.

The immediate continuation point is the **Phase 5 compact outcome-picker
spacing and motion audit**. Outcome capture is already implemented. Do not
rebuild it, reopen its presentation choice, or start another feature.

The Range Finder visual system remains locked. General feedback such as
"brighter," "bolder," or "more wow" is not authorization to replace
`Theme.swift` or select a new visual direction. Reopening that lock requires an
explicit product decision from Colt based on reviewed visual options.

---

## 2. GROUND TRUTH — READ IN THIS ORDER

1. `Docs/PROJECT.md` — product vision, v1 scope, and prohibited features
2. `Docs/ROADMAP.md` — the only authority for what happens next
3. `Docs/ARCHITECTURE.md` — modules, persistence, and AI boundary
4. `Docs/DECISIONS.md` — latest dated decision wins
5. `Docs/CADDY_LOGIC.md` — deterministic recommendation rules
6. `design-qa.md` — current Caddy Call fidelity record
7. Current source and tests named in Sections 6 and 7
8. This handoff — orientation only; lower authority than current artifacts

If any statement below conflicts with the current repo, report the conflict and
follow the higher-authority artifact. Never silently reconcile stale work
orders by changing code.

---

## 3. EXACT CURRENT STATUS

`Docs/ROADMAP.md` currently says:

> Continue the Phase 5 screen-by-screen visual audit with the compact outcome
> picker's spacing and motion.

Completed and present on the production baseline:

- App shell, SwiftData container, models, profile seeding, and editable bag
- Deterministic `CaddyEngine` with unit coverage
- Tap-first shot tray wired to the engine
- Optional typed nuance attached to the next submitted shot
- Structured, card-only Caddy Call response in the thread
- Static `Remind me how` execution cues for all four shot types
- Bag-button top safe-area inset and its long-thread regression test
- Compact Quick Grid outcome picker and required-outcome persistence seam
- Compact Command Strip Caddy Call with accessibility fallbacks
- Provider-neutral voice service retained for future conversational surfaces

Phase 5 final spacing and motion polish is in progress:

- Caddy Call command-first audit: done
- Compact outcome-picker audit: next
- Bag button, tray, and composer audit: pending

Everything in Phase 6 remains out of scope. The separate Full + Tee routing
defect mentioned in the latest decision log is not part of the current visual
loop and must not be fixed silently.

---

## 4. LATEST LOCKED PRODUCT AND VISUAL DECISIONS

### 2026-07-17 — Static execution tips

- `Remind me how` uses one deterministic, engine-owned tip per `ShotType`.
- The tip expands inside the card and works offline.
- `Tendency` and `CoachingCue` remain dormant.

### 2026-07-18 — Card-only post-shot response

- The initial caddie greeting remains.
- A submitted shot summary is followed directly by the Caddy Call card.
- There is no separate post-shot lead bubble and no visible confidence badge.
- `CaddyDecision.lead` and `CaddyVoiceService` remain in the codebase for future
  conversational surfaces; they are not rendered in this live flow.
- Alternate and reminder content are collapsed by default.

### 2026-07-18 — Compact Quick Grid outcome picker

- Tapping `Log result` opens a compact bottom sheet over the current card.
- The sheet presents exactly six outcomes in a 2-by-3 grid: Good, Left, Right,
  Short, Long, and Poor contact.
- Cancel or interactive dismissal writes nothing.
- Choosing one outcome writes exactly one `ShotHistory` record and disables
  that card's `Log result` action.
- Outcome capture does not activate tendencies, coaching, inference, or a
  second result flow.

### 2026-07-18 — Compact Command Strip Caddy Call

- Colt selected displayed Proposal 2, the compact Command Strip, after
  screenshot-grounded comparison.
- Club and carry share the hero row.
- Target is the strongest command.
- Safe miss and Why share a compact information band.
- Alternate is a restrained amber disclosure.
- Reminder and `Log result` share a compact action rail at normal Dynamic Type
  sizes and stack at accessibility sizes.
- The card uses semantic Dynamic Type, 44-point actions, native SF Symbols,
  and Reduce Motion-aware disclosure transitions.
- The locked Range Finder palette and SF Rounded typography remain in force.

---

## 5. CURRENT VISUAL SOURCE OF TRUTH

Do not redesign the Caddy Call from memory. Open these files:

- `Proof/caddy-call-command-first-reference.png` — Colt-selected visual target
- `Proof/caddy-call-command-first-runtime.png` — verified simulator result
- `Proof/caddy-call-command-first-comparison.png` — normalized side-by-side
- `design-qa.md` — fidelity findings and iteration record

`design-qa.md` ends with `final result: passed` and records no actionable
P0/P1/P2 Caddy Call differences.

The older `Proof/caddy-call-approved-*` files document the superseded tall card
pass. They are historical evidence, not the current Caddy Call target. Do not
overwrite `Proof/phase-5-2-caddy-call-card.png`; it contains a separate user
modification.

The DEBUG-only `-UITestCompactCaddyCall` fixture renders a deterministic
450-yard tee shot with OB through the real engine. Its verified collapsed state
shows `3 Hybrid`, `200 yds`, `Aim at the widest fairway`, Safe miss, Why,
Alternate, reminder, and `Log result`.

---

## 6. CURRENT OUTCOME-PICKER CONTRACT AND SEAMS

Inspect these before the visual audit:

- `COLTSCADDY/Components/OutcomePickerSheet.swift`
  - Owns the current 2-by-3 Quick Grid presentation.
  - Uses a 52-point minimum outcome target and a full-width Cancel action.
- `COLTSCADDY/Screens/ThreadView.swift`
  - Presents the picker with `.sheet(item:)`, a 360-point detent, visible drag
    indicator, 28-point corner radius, and the existing surface color.
  - Calls `ShotHistoryStore.log` only after an outcome is selected.
- `COLTSCADDY/Models/CoreTypes.swift`
  - `Outcome` has exactly six cases and owns their display names.
- `COLTSCADDY/Models/ShotHistoryStore.swift`
  - `log(shot:decision:outcome:in:)` requires a non-optional `Outcome`.
- `COLTSCADDYTests/ShotHistoryStoreTests.swift`
  - Proves the stored outcome and all six display names.
- `COLTSCADDYUITests/COLTSCADDYUITests.swift`
  - `testSubmittingShotRendersStructuredCaddyCallCard` proves the six choices,
    Cancel-without-disable behavior, selection, and final disabled state.

Behavior that must survive the visual audit:

1. `Log result` opens the compact local sheet.
2. All six existing outcomes remain available one-to-one.
3. Cancel and dismissal do not write.
4. One selection writes one record with the selected outcome.
5. The originating card becomes logged and cannot create a duplicate.
6. Existing Alternate and reminder disclosures keep working.
7. No recommendation, voice, nuance, bag, model, or tendency behavior changes.

The audit may adjust the picker's spacing and motion only after inspecting the
current Simulator rendering and obtaining Colt's visual approval. Do not
freelance a new sheet, add fields, or change global design tokens.

---

## 7. CURRENT CADDY CALL IMPLEMENTATION SEAMS

- `COLTSCADDY/Components/CaddyCallCard.swift`
  - Owns the compact command-first layout and disclosure state.
  - Uses `ViewThatFits` and accessibility-size stacking fallbacks.
  - Adds a natural definite article to appropriate directional target display
    copy without changing the stored engine decision.
- `COLTSCADDY/Screens/ThreadView.swift`
  - Renders the user's shot summary followed directly by `CaddyCallCard`.
  - Requests delayed scroll-to-latest after disclosure expansion.
  - Uses a top-trailing `safeAreaInset` for the golfer/bag button.
- `COLTSCADDYUITests/COLTSCADDYUITests.swift`
  - `testCompactCaddyCallMatchesApprovedCommandFirstState` is the focused
    command-first visual regression seam.
  - `testBagButtonNeverObscuresTopMessageInLongThread` is the bag-button
    geometry and route regression seam.

Do not change these surfaces during the outcome-picker audit unless a directly
observed regression proves the smallest necessary correction. If scope must
expand, stop and ask Colt first.

---

## 8. ARCHITECTURAL AND PRODUCT BOUNDARIES

### Deterministic decision boundary

- `CaddyEngine` owns club, distance, target, safe miss, why, alternate,
  confidence, lead, and execution cue.
- The LLM never chooses or alters a golf decision.
- The iOS app contains no provider SDK or provider API key.
- Do not delete the voice layer because the current UI is card-only.

### Product boundary

18Birdies owns GPS, wind, plays-like distance, course maps, and scoring.
COLTSCADDY must not add or mention those capabilities, including placeholders.

Still out of v1:

- Aim View and Green Map
- Voice input/output
- Accounts and sign-in
- Course data
- Coach/practice layer
- Active tendency learning
- Conversational shot debrief

All caddie-visible text must use complete grammatical sentences and normal
punctuation.

### Scope rule

One feature per loop. The next loop is only the compact outcome-picker visual
audit. Do not combine it with the pending bag-button, tray, or composer audit.

---

## 9. LAST RECORDED VERIFICATION RECEIPT

The latest recorded July 18 verification used an iOS 26.5 iPhone 17 Pro
Simulator named `26.5 sim2`.

Recorded results at production baseline `6777494`:

- Generic Debug Simulator build: succeeded
- Complete `COLTSCADDYTests`: 22 passed
- Focused structured-card / outcome-picker UI test: passed
- Dedicated compact command-first UI test: passed
- Caddy Call design QA: passed with no actionable P0/P1/P2 gaps
- `git diff --check`: passed before the production commits

Recorded limitations:

- No physical-iPhone visual pass was performed.
- The full UI-test target was not recorded as rerun after the final compact
  Command Strip change; the two focused UI paths are the current evidence.
- Xcode emitted `DebuggerVersionStore` / `no debugger version` warnings during
  focused UI runs. The recorded xcresults completed with passed tests and zero
  failures.

These are historical receipts, not proof of a future working tree. Rerun the
relevant commands before making new compile, test, or Simulator claims.

Useful commands:

```bash
xcodebuild -project COLTSCADDY.xcodeproj -scheme COLTSCADDY \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' build
```

Discover a current concrete Simulator before running tests. Then use its UDID:

```bash
xcodebuild -project COLTSCADDY.xcodeproj -scheme COLTSCADDY \
  -destination 'platform=iOS Simulator,id=<SIMULATOR_UDID>' \
  -only-testing:COLTSCADDYTests test
```

```bash
xcodebuild -project COLTSCADDY.xcodeproj -scheme COLTSCADDY \
  -destination 'platform=iOS Simulator,id=<SIMULATOR_UDID>' \
  -only-testing:COLTSCADDYUITests/COLTSCADDYUITests/testSubmittingShotRendersStructuredCaddyCallCard \
  -only-testing:COLTSCADDYUITests/COLTSCADDYUITests/testCompactCaddyCallMatchesApprovedCommandFirstState \
  test
```

---

## 10. DO NOT REDO OR REOPEN

- Do not rebuild Outcome tap; it is complete.
- Do not reopen inline-versus-sheet; Colt selected the compact Quick Grid
  bottom sheet.
- Do not restore the post-shot lead bubble or confidence badge.
- Do not expand Alternate or reminder content by default.
- Do not replace the compact Command Strip with the superseded tall card.
- Do not replace or broadly rewrite the Range Finder visual system without a
  new explicit product decision.
- Do not move typed nuance out of `ChatInputBar`.
- Do not duplicate the bag-button safe-area fix.
- Do not make `Outcome` optional at the logging seam.
- Do not activate tendencies, coaching, or inference from outcomes.
- Do not add notes, score, club-used confirmation, sliders, miss combinations,
  or another result flow.
- Do not change recommendation rules during a visual audit.

---

## 11. HANDOFF / COMPLETION FORMAT FOR THE NEXT CHAT

After the compact outcome-picker audit, report:

### Verdict

KEEP, TEST, FIX, REVERT, or NEEDS DECISION.

### Files changed

Only files actually changed.

### What changed

Plain product language describing the approved spacing or motion adjustment.

### Verification

Exact commands and actual results. Separate build, tests, simulator
observation, physical-device observation, commit, push, and remote visibility.

### What to check next

One manual check Colt can perform in under 30 seconds.

### Risks or follow-up

Unproved behavior, warnings, intentionally deferred scope, and the exact next
roadmap line.

Every verification claim should name its evidence and the check that would
falsify it. Do not call work shipped unless `git log origin/main` shows the
commit after push. Do not commit or push unless Colt asks.
