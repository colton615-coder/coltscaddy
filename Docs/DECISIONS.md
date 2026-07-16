# Decisions

## 2026-07-15 — Range Finder visual lock

- Colt chose the Range Finder direction from reviewed mockups.
- The visual system is locked to near-black with cool grays, one cyan accent,
  and SF Rounded throughout. Serif is retired.
- Color carries meaning and is not decorative: cyan is the accent, green is
  confidence, and amber is the alternate play.

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
- The phase was committed locally, but it was not pushed because this checkout
  has no configured Git remote or push destination.

### Recovery path

- Configure the intended repository remote, then push the `main` branch. Do not
  call the phase shipped until that push succeeds.

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
- This phase cannot be pushed because the checkout has no configured Git
  remote. It is not shipped until a future push succeeds.

### Runner warning and recovery path

- During the otherwise successful complete UI run, Xcode logged failed launches
  for two auxiliary simulator clones. Those errors did not become test failures:
  the primary clone completed every recorded test and the xcresult contains zero
  failures.
- If a future complete UI run reports an actual failed test, reset or recreate
  the affected simulator clones and rerun the focused card flow first, then the
  complete UI target.
