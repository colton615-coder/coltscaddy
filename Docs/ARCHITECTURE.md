# Architecture

This file describes current technical truth and approved boundaries. Future
architecture is labeled explicitly and does not become current merely because
it appears in the north-star design.

## Current stack and structure

- SwiftUI app in `COLTSCADDY.xcodeproj`, scheme `COLTSCADDY`.
- Swift 5 language setting and iOS 26.5 deployment target.
- SwiftData local persistence with one app-owned `ModelContainer`.
- Pure Swift deterministic `CaddyEngine`.
- Optional provider-neutral HTTP voice service with a complete local fallback.
- Scorecard Daylight design tokens in `DesignSystem/Theme.swift`.

Current folders retain their existing responsibilities:

- `App/` owns app entry and the `ModelContainer`.
- `Screens/` owns `ThreadView`, `ShotInputTray`, and `BagEditorView`.
- `Components/` owns reusable feature UI such as `CaddyCallCard` and
  `OutcomePickerSheet`.
- `Models/` contains SwiftData models, shared enums, stores, the engine, and
  the optional voice boundary.
- `DesignSystem/` owns Scorecard Daylight tokens and shared controls.

## Deterministic recommendation boundary

`CaddyEngine` owns all golf decisions: club, intended distance, target, safe
miss, why, alternate, confidence, fallback lead, and static execution cue. The
current engine receives validated structured values plus bag carries and works
without a network connection.

Language services may extract future typed or spoken input and may re-voice a
completed decision. They may not choose or alter golf strategy. The iOS app
contains no provider SDK or provider key; provider choice and credentials stay
behind the configured backend boundary.

Recommendation logic must not live in:

- SwiftUI views or transient UI state.
- SwiftData model methods or persistence hooks.
- Language, speech, or voice services.
- CloudKit or sync conflict handlers.
- Network response handling.

## Persistence rules

- SwiftData is the current authoritative on-device store.
- One `ModelContainer` is created at app entry and injected with
  `.modelContainer()`.
- Views may read models, but writes use small named store functions. The current
  result path writes through `ShotHistoryStore.log`.
- Current schema types are `ShotContext`, `ShotHistory`, `PlayerProfile`,
  `ClubDistance`, `Tendency`, and `CoachingCue`.
- `Tendency` and `CoachingCue` exist as dormant models. No analyzer, proposal,
  confirmation workflow, or learned recommendation override is implemented.
- The current `ShotHistory.roundID` property is legacy schema baggage. The app
  has no round lifecycle or round UI; removal requires a deliberate migration
  rather than destructive model replacement.
- Schema evolution must be additive or migration-driven. Existing profile,
  bag, and history data may not be discarded for implementation convenience.

## PlayerKnowledgeSnapshot boundary

`PlayerKnowledgeSnapshot` is an approved future pure Swift value boundary; it
is not implemented today. A mapper at the persistence/domain seam will build an
immutable snapshot from user-entered facts and explicitly confirmed knowledge.

The future engine may read that snapshot, but it must never receive live
SwiftData models, a `ModelContext`, language-service objects, CloudKit records,
or UI state. Unconfirmed observations and proposals cannot enter the snapshot
or change a recommendation.

Until that slice is implemented, the current engine uses bag carries only. The
existing `recommend(for:profile:)` overload maps `PlayerProfile.clubDistances`
to plain Swift values and does not read tendencies, cues, or preferences.

## Approved future architecture

Future slices may add a Play/History app shell, active-turn store, shot-history
queries, parser, validator, evidence analyzer, knowledge store, snapshot mapper,
speech input, and private iCloud sync. Each remains future work until its own
Roadmap slice is implemented, migrated, tested, and observed.

The approved dependency direction is:

`SwiftUI feature -> validator/store mapper -> pure domain service`

Persistence and optional services sit behind named boundaries. Domain services
do not import SwiftUI, SwiftData, CloudKit, speech, or provider SDKs.

## Private iCloud sync

Private iCloud sync is explicitly deferred. SwiftData is local-only today.
When sync is eventually implemented, local writes must remain immediate,
offline use must remain complete, records need stable identity and modification
metadata, and conflicts may not silently overwrite confirmed carries or player
knowledge. Existing-user data and intentional deletions must survive migration
and synchronization.

## Design-system rules

- Scorecard Daylight is active: warm paper, warm-neutral surfaces, charcoal
  ink, forest-green brand/actions, flag-red Caddy Call label, amber Alternate.
- SF Rounded is the type voice. SF Symbols are used sparingly and never replace
  app-specific imagery from an approved source.
- Color never carries meaning alone.
- Minimum 44-point targets, semantic Dynamic Type, accessibility-size stacking,
  VoiceOver labels, Increased Contrast readability, and Reduce Motion behavior
  are required.
- The app currently uses a fixed light appearance for daylight readability.
