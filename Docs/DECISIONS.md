# Decisions

## 2026-07-18 — Approved card-only Caddy Call refinement

### Decisions locked

- The approved visual source is
  `Proof/caddy-call-approved-reference.png`. The Caddy Call keeps the original
  stacked information structure; it is not a dashboard, command grid, or set
  of pills.
- After a shot submission, the user's summary is followed directly by the
  Caddy Call card. The separate post-shot caddie lead bubble is removed from
  the live thread. The initial greeting remains. `CaddyDecision.lead` and the
  provider-neutral voice service remain in the codebase for future
  conversational surfaces, but they are not rendered in this card-only flow.
- Confidence remains deterministic engine data, but the confidence badge is
  not user-facing. Labels such as `Medium-high` do not appear on the card.
- `Target`, `Safe miss`, and `Why` are 21-point bold SF Rounded headings. Their
  answers use a brighter 17-point card-detail color and concise, complete copy.
  All existing engine branches were shortened; club selection, trouble order,
  confidence calculation, persistence, and recommendation rules were not
  changed.
- Alternate play is collapsed by default in one full-width amber disclosure.
  Its engine-owned alternate text appears only after a tap.
- Remind me how is collapsed by default. It expands inside the card to a cyan
  `COMMIT TO THIS` label and one compact execution cue. Log result is a
  full-width cyan action in both reminder states.
- Native chat scrolling prioritizes the newest Caddy Call and composer. Older
  greeting content may scroll away when the expanded card needs the viewport;
  it is not pinned or duplicated.
- The roadmap's SINGLE NEXT ACTION remains outcome tap. This visual pass does
  not implement or broaden that feature.

### Implemented and proved

- `CaddyCallCard` now owns independent alternate and reminder disclosure state,
  keeps both controls at a 44-point minimum target, and requests a delayed
  scroll after expansion so the final control is visible after animation.
- `ThreadView` renders the deterministic decision directly as a card and clips
  scrolled conversation content out of the status-bar region.
- The generic iOS Simulator build succeeded. The complete `COLTSCADDYTests`
  target passed with 21 tests. The focused structured-card UI flow passed after
  submitting 165 yards, proving the removed bubble/badge, concise field copy,
  collapsed and expanded Alternate play, collapsed and expanded reminder, and
  Log result behavior.
- Runtime proof is `Proof/caddy-call-approved-runtime.png`; the normalized
  side-by-side is `Proof/caddy-call-approved-comparison.png`; the fidelity log
  is `design-qa.md`.

### Tried, warning, and recovery path

- The first expanded-state capture crowded `Hide reminder` at the bottom edge.
  The recovery waits for the 0.2-second disclosure animation before scrolling,
  reduces only the card's outer spacing from 16 to 12 points, and clips the
  scroll view at its real bounds. The rerun kept the full card and composer
  visible.
- The focused UI runs emitted Xcode's `DebuggerVersionStore` / `no debugger
  version` warning. Each continued and returned `TEST SUCCEEDED`.
- `Proof/phase-5-2-caddy-call-card.png` already contained an unrelated user
  modification before this pass and was intentionally left untouched.

## 2026-07-17 — Remind me how uses static execution tips

### Decisions locked

- The July 17 nuance/ChatInputBar replacement work order was withdrawn because
  the current source proved its premise wrong: `ThreadView` already wires
  `ChatInputBar`, and `ShotSubmission.attachingNuance(_:)` already trims and
  attaches nuance. Source outranked the work order, so the July 15 nuance
  decision stands and nuance remains in the chat bar.
- `Remind me how` is one static, engine-owned execution tip per `ShotType`.
  The four tips are deterministic, work offline, and are never written,
  re-voiced, or altered by the LLM or voice backend.
- The Caddy Call card owns collapsed/expanded state. The tip opens inline below
  the field blocks and above the action row; a second tap collapses it.
- Free chat with the caddie remains v2. `Tendency` and `CoachingCue` remain
  dormant and are not part of this lookup.
- The voice backend is deferred to v1.1. v1 ships using the complete local
  fallback lead already owned by CaddyEngine.
- The Phase 5 visual audit remains deferred until after the outcome-tap loop.

### Implemented and proved

- Added `CaddyEngine.executionTip(for:)` as an exhaustive `ShotType` lookup and
  passed a tip selected from `call.shot.shotType` into `CaddyCallCard`.
- Added local card expansion state plus a newest-card scroll request so the
  expanded tip and action row remain visible at the bottom of the thread.
- A generic iOS Simulator build returned `BUILD SUCCEEDED`.
- The focused `CaddyEngineTests` suite passed on iOS 26.5 `26.5 sim2`, including
  the test that checks all four shot types for non-empty, prohibited-term-free
  tips.
- The complete COLTSCADDYTests target passed on the same simulator: 21 tests,
  zero failures or skips.
- The focused UI flow submitted a 165-yard full shot, proved the tip was
  collapsed by default, expanded the exact full-shot tip, proved the latest
  card actions remained hittable, collapsed the tip, and logged the result.
  It passed in 14.890 seconds and retained an expanded-state screenshot.

### Tried, warning, and recovery path

- The first exact Swift Testing selector completed without executing a test;
  its result bundle reported zero tests and was not counted as evidence. The
  recovery was selecting the focused `CaddyEngineTests` suite, which executed
  and passed the new test.
- The focused UI run emitted Xcode's `DebuggerVersionStore` / `no debugger
  version` warning. The test continued and returned `TEST SUCCEEDED`.
- No physical-device run was performed. If the disclosure regresses, rerun
  `everyShotTypeHasASafeExecutionTip` first, then
  `testSubmittingShotRendersStructuredCaddyCallCard`. A unit failure isolates
  the static lookup; a UI failure isolates card expansion or latest-item
  scrolling.

## 2026-07-15 — Golfer/bag button reserves thread space

### Decisions locked

- The golfer/bag button uses a top-trailing `safeAreaInset` instead of a root
  overlay. The inset reserves the button's full vertical band, so thread items
  cannot occupy the same top region at any scroll position.
- The button's symbol, design-system styling, 44-point size, top-trailing
  position, and `BagEditorView` route are unchanged.
- A DEBUG-only long-thread launch fixture exists solely for deterministic UI
  geometry proof. It does not change normal launches or release behavior.

### Implemented and proved

- The regression test first failed against the overlay: the top message began
  at -9.33 points while the button extended to 114.5 points.
- After the safe-area inset change, the same test scrolled a long thread to the
  top, proved the first message starts below the button's reserved height,
  proved their frames do not intersect, tapped the button, and opened
  `BagEditorView`.
- The existing structured-card UI flow also passed after proving the newest
  `CaddyCallCard` remained visible and its `Log result` action was hittable.
- A generic iOS Simulator build succeeded. The complete COLTSCADDYTests target
  passed on iOS 26.5 `26.5 sim2`: 20 tests passed with zero failures or skips.
- The two focused UI flows passed with zero failures. The retained simulator
  screenshot is `Proof/bag-button-safe-area-inset.png`.

### Tried, warning, and recovery path

- The first test draft tried to count historical `CADDY CALL` labels, but
  `LazyVStack` exposes only rendered items to UI automation. The recovery was a
  deterministic long-thread fixture and direct top-message geometry checks.
- The structured-card test still selected the first text field, which became
  stale after ChatInputBar gained a real field. It now selects the existing
  `shotDistanceField` identifier.
- Xcode again emitted its `DebuggerVersionStore` / `no debugger version`
  warning. Both final UI tests continued and returned `TEST SUCCEEDED`.
- If this layout regresses, rerun
  `testBagButtonNeverObscuresTopMessageInLongThread` first. A failure of the
  vertical frame assertion means the top inset no longer reserves enough
  space; a failure after the tap means the bag-editor route regressed.

## 2026-07-15 — ChatInputBar nuance path

### Decisions locked

- Model (a) is the v1 interaction: Colt types optional nuance before opening
  the shot tray, and that text attaches to the next submitted shot.
- The arrow opens the shot tray only when the bar contains meaningful text.
  The existing plus button still opens the tray when no nuance is needed.
- Submitted nuance is trimmed; empty or whitespace-only input becomes `nil`.
  The draft clears only after the shot is submitted.
- The user's message bubble includes the same nuance carried by
  `CaddyShotInput`. CaddyEngine remains deterministic and does not use nuance
  to change its decision.
- Model (b), a conversational free-text follow-up turn, remains out of this
  loop because it is a larger feature.

### Implemented and proved

- Replaced the placeholder text with a real caller-owned `TextField` and
  removed the no-op send-action default.
- Added focused tests for trimmed nuance and whitespace-to-`nil` behavior.
- Extended the backend-payload test to prove the submitted nuance is encoded
  in `CaddyVoiceRequest.Shot.nuance`.
- A generic iOS Simulator build succeeded.
- The complete COLTSCADDYTests target passed on iOS 26.5 `26.5 sim2`: 20
  tests passed with zero failures or skips.
- A focused simulator UI test typed nuance, opened the tray from the arrow,
  submitted a 165-yard shot, confirmed the same nuance in the user's bubble,
  and confirmed the bar cleared. It passed in 12.211 seconds.
- Replaced `ARCHITECT_HANDOFF.md` with the supplied current handoff and removed
  the spent `TEMP_DAY_PLAN_2026-07-15.md` and `CODEX_PROMPT_PHASE_A.md` work
  orders.

### Tried, warning, and recovery path

- The focused UI run emitted Xcode's `DebuggerVersionStore` / `no debugger
  version` warning. The test continued and returned `TEST SUCCEEDED`; the
  xcresult reports one passed test and zero failures.
- If the nuance UI flow fails later, rerun the focused UI test first. Check
  `nuanceTextField`, `nuanceSendButton`, and `shotDistanceField` before
  changing production behavior.

## 2026-07-15 — Caddie lead owns the spoken bubble

- Colt decided from screenshots that the caddie bubble must stop repeating the
  Caddy Call card.
- CaddyEngine owns one short, complete `lead` sentence for every decision. The
  bubble shows that lead; the card carries the structured facts.
- The offline renderer returns the engine-owned lead, so a missing backend
  still produces a real sentence instead of duplicating the card.
- The backend may re-voice the lead with personality, but it may not restate
  card fields or alter the engine's decision.

## 2026-07-15 — Range Finder visual lock

- Colt chose the Range Finder direction from reviewed mockups.
- The visual system is locked to near-black with cool grays, one cyan accent,
  and SF Rounded throughout. Serif is retired.
- Color carries meaning and is not decorative: cyan is the accent, green is
  confidence, and amber is the alternate play.

## 2026-07-15 — Caddy Call card hierarchy lock

- Colt chose the taller Caddy Call card hierarchy from reviewed mockups.
- Color carries meaning and is not decorative: cyan is the number, green is
  confidence, and amber is the alternate.
- Post-shot conversational debrief is deferred to v2+/v3 rather than built in
  this v1 card-polish loop.

## 2026-07-11

- Project name kept as COLTSCADDY (all caps, no space); display name Colt's Caddy.
- v1 scope initially locked to single-hole situation-in / advice-out flow.
- Storage initially set to None for v1. (SUPERSEDED — see 2026-07-14.)

## 2026-07-14 — consolidated re-lock (docs were stale; this entry brings the
repo's written record in line with decisions already made)

- v1 scope EXPANDED and re-locked: full recommendation-engine behavior plus
  SwiftData persistence are IN v1. All prior "no persistence" language is void.
- Thread interaction pattern LOCKED: conversational feed, caddie speaks in
  bubbles, Caddy Call lands as a card in the thread.
- Color system / visual aesthetic: NOT locked. Current dark/gold/serif look is
  unintentional default styling, not a chosen direction.
- Wind / plays-like modeling: permanently out of scope. 18Birdies owns GPS,
  wind, plays-like distance, and scoring.
- Aim View: deferred until core recommendation flow is solid.
- Green Map: logged as deferred module, sibling to Aim View. Not started.
- Caddie is unnamed. Colt is the user, not the caddie.
- Engine style for v1: HARD DETERMINISTIC RULES, ordered, first-match-wins.
  Weighted/learned overrides deferred to v2. Rationale: no tuning data exists
  yet; rules are desk-testable; bad rule output is traceable to one line.
- Strict AI-vs-deterministic split: CaddyEngine decides, LLM voices. Engine
  must work offline with flat wording.
- Confidence bands describe certainty only; they never block a call. The
  caddie always commits. No clarifying questions.
- Alternate play is always shown immediately alongside the primary.
- Tendency lifecycle (Fact → Result → Inference → Confirmed) with explicit
  user-confirmation gate and three-instance minimum: models built in v1,
  behavior dormant until v2.
- TASKS.md deleted. ROADMAP.md is the single source for current phase and
  next action.
- Copy discipline: full grammatical sentences, normal punctuation, zero wind
  or plays-like references anywhere, including placeholders.

## 2026-07-14 — persistence and PlayerProfile seed checkpoint

### Decisions locked

- The app owns one SwiftData ModelContainer at app entry and injects it into
  the SwiftUI environment. The container schema includes every v1 model.
- PlayerProfile is created once on first launch. Seeding is idempotent: an
  existing profile and all user-edited carry distances are authoritative and
  must never be replaced by later launches.
- The initial bag carries are placeholders, not Colt's measured distances.
  Colt replaces them in the bag editor opened from the golfer button at the
  top right of the thread.
- Bag rows stay in a fixed golf-club order while values are edited. Carry
  distance changes persist through SwiftData.

### Implemented and proved

- Added the app-level ModelContainer and attached the complete SwiftData
  schema.
- Added ProfileSeeder with a unique, ordered default bag and one-time profile
  creation.
- Added the bag editor and connected it to ThreadView.
- Added focused tests proving first-launch creation, no duplicate profile on a
  second seed, preservation of an edited Driver carry, and valid unique default
  bag data.
- A generic iOS Simulator build succeeded.
- ProfileSeederTests succeeded on a concrete iOS Simulator.
- The complete COLTSCADDYTests unit-test target succeeded on that simulator.
- `git diff --check` succeeded.

### Tried but did not prove

- Tests cannot run against `generic/platform=iOS Simulator`; xcodebuild
  requires a concrete simulator destination for the test action.
- A full test run including COLTSCADDYUITests stalled during UI-test launch /
  debugger finalization and was interrupted. Do not treat UI tests as passing
  until a clean full run completes.

### Recovery path

- If destination resolution fails, list installed simulators and select one
  concrete device identifier; keep the generic destination for builds only.
- If the full suite stalls in UI-test launch, run `COLTSCADDYTests` alone first
  to separate app/unit correctness from UI-runner trouble.
- If seeded values look wrong, first check whether a PlayerProfile already
  exists. The seeder intentionally refuses to overwrite existing data; edit the
  carries in the bag editor or explicitly reset test/app data when appropriate.
- If the new files do not appear in an already-open Xcode window, reopen the
  project before changing target membership. The files compiled successfully
  in the current filesystem-synchronized project structure.

## 2026-07-14 — provider-neutral caddie voice boundary

- The iOS app does not choose or directly integrate an AI provider.
- CaddyEngine remains local and owns the complete shot decision.
- The app sends the structured shot and completed decision to one configurable
  backend endpoint, which may only render the decision in the caddie's voice.
- Provider SDKs and credentials belong behind the backend boundary and never in
  the app bundle.
- A missing endpoint, timeout, non-2xx response, invalid payload, or empty
  assistant response falls back to a complete local rendering of the same
  CaddyDecision.

## 2026-07-15 — Phase 4 Caddy Call card checkpoint

### Decisions locked

- The thread feed stores typed content: either a text bubble or a structured
  CaddyDecision. Card content is never reconstructed by parsing voiced prose.
- The caddie's spoken bubble remains in the feed, followed by the structured
  CaddyCallCard as the latest item.
- The card receives Play, Target, Safe miss, Why, Confidence, and Alternate
  directly from CaddyEngine output.
- `Remind me how` and `Log result` remain visible and inert in this phase.
  ShotHistory persistence is the single next action.

### Implemented and proved

- Moved CaddyCallCard.swift from DesignSystem/ to Components/. The synchronized
  project folder included it in the app target without project-file surgery.
- Added typed thread-item rendering and appended the card after the voiced
  response.
- Added a focused simulator UI test that submits a 165-yard fairway shot,
  verifies the structured card fields and alternate, and confirms `Log result`
  is hittable at the scrolled-to-latest position.
- A generic iOS Simulator build succeeded.
- The focused simulator UI test passed on the iOS 26.5 `26.5 sim2` simulator.
- The complete COLTSCADDYTests unit-test target passed on that simulator: 15
  test cases passed.
- `git diff --check` succeeded.

### Not proved

- No physical-device run was performed.
- Phase 4 item 6 was not started; neither card action writes persistence yet.
- At this checkpoint the phase was reported as local-only because the checkout
  was believed to have no remote. **SUPERSEDED:** `origin/main` is configured,
  and the phase was pushed later.

### Recovery path

- **SUPERSEDED:** no remote recovery is required. Verify shipping against
  `origin/main` and `git ls-remote origin refs/heads/main`.

## 2026-07-15 — Phase 4 ShotHistory logging checkpoint

### Decisions locked

- `ShotHistoryStore.log(shot:decision:in:)` is the single named write path for
  logging a Caddy Call result.
- The store creates the related ShotContext from the original CaddyShotInput and
  persists the engine's primary `decision.play` text as `recommendationGiven`.
- A card becomes locally logged only after the SwiftData save succeeds. Its
  `Log result` action is then disabled so repeat taps cannot create duplicates
  for that card.
- Outcome, miss direction, contact quality, and followed-recommendation fields
  remain nil. No outcome-entry UI was added.
- Tendency learning remains dormant and is not read or written by this flow.

### Implemented and proved

- Added ShotHistoryStore and routed the card action through it; the view does
  not insert SwiftData models directly.
- Added a focused in-memory SwiftData test proving one ShotHistory record is
  saved with the correct shot type, lie, trouble, distance, nuance, and engine
  recommendation. The deferred outcome fields remain nil.
- A generic iOS Simulator build succeeded.
- The focused ShotHistoryStore test passed on the iOS 26.5 `26.5 sim2`
  simulator.
- The complete COLTSCADDYTests unit-test target passed on that simulator: 16
  test cases passed.
- The focused simulator UI test submitted a shot, tapped `Log result`, and
  passed after confirming the action became disabled. The test completed in
  10.337 seconds and kept a screenshot attachment.
- The complete COLTSCADDYUITests target returned `TEST SUCCEEDED`. The xcresult
  summary reported `Passed`, three tests, six executions, and zero failures or
  skips on the iOS 26.5 simulator.
- `git diff --check` succeeded.

### Not proved

- No physical-device run was performed.
- At this checkpoint the phase was reported as unable to push because the
  checkout was believed to have no remote. **SUPERSEDED:** `origin/main` is
  configured, and the phase was pushed later.

### Runner warning and recovery path

- During the otherwise successful complete UI run, Xcode logged failed launches
  for two auxiliary simulator clones. Those errors did not become test failures:
  the primary clone completed every recorded test and the xcresult contains zero
  failures.
- If a future complete UI run reports an actual failed test, reset or recreate
  the affected simulator clones and rerun the focused card flow first, then the
  complete UI target.
