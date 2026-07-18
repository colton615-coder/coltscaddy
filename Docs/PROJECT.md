# Colt's Caddy — Product and Experience Authority

**Display name:** Colt's Caddy

**Canonical role:** This file owns the active product and experience contract.

**Approved north-star design:**
`Docs/superpowers/specs/2026-07-18-coltscaddy-north-star-design.md`

`Docs/ROADMAP.md` remains the only authority for the next implementation
action. Architecture and current engine behavior live in
`Docs/ARCHITECTURE.md` and `Docs/CADDY_LOGIC.md`.

## Product promise

Colt's Caddy is a personalized decision caddie that learns Colt's actual game
and gives one decisive recommendation for the shot in front of him.

> Do not only tell me what the shot plays like. Tell me what the shot plays
> like for me.

The approved closed loop is:

`Play -> Call -> Result -> History -> Confirmed Knowledge -> Better Call`

The opening job is **Get the Call**. There is no dashboard, mode chooser, or
Start Round gate.

## Current implemented product

The app currently ships one SwiftUI thread screen with:

- A tap-first structured shot tray for shot type, lie, trouble, and distance.
- Optional typed nuance attached to the next submitted shot.
- A deterministic, offline-capable `CaddyEngine` using the saved bag carries.
- One structured Caddy Call card with Alternate, Remind me how, and Log result.
- The six-choice compact Quick Grid: Good, Left, Right, Short, Long, and Poor
  contact. Cancel writes nothing; selection writes one SwiftData history record
  and disables duplicate logging for that card.
- A golfer button that opens editable bag carry distances.
- Local SwiftData models for profile, history, tendencies, and cues. Tendencies
  and learning behavior are dormant.
- The Scorecard Daylight visual system in a fixed light appearance.

The current screen still accumulates items in a thread. It does not yet have a
Play + History tab shell, one restorable live turn, History UI, natural-language
parsing, smart follow-up, learning proposals, Aim View, speech, or iCloud sync.

## Approved north-star product

### Primary structure

- Two primary tabs: **Play** and **History**.
- Play contains one live caddie turn, not a lifetime transcript.
- History is first-class and opens with learned insights before review and the
  complete shot chronology.
- Player Profile opens from the golfer button; it is not a tab.
- There is no standalone Coach tab.

### Shot and history model

- There is no round or session model. Every shot is timestamped and History
  groups shots by calendar date.
- A live turn contains the shot description, at most one material follow-up,
  one Caddy Call, optional disclosures, and one quick result.
- Logging completes the turn, moves the shot to History, and resets Play.
- The six-outcome Quick Grid remains the on-course result contract.

### Input and recommendation

- Hybrid input supports type, press to talk, and the tap-first tray.
- Typed and spoken language always resolve to validated structured context.
  They never feed prose directly into recommendation logic.
- Ask one focused follow-up only when missing information could materially
  change the call.
- Initial setup is only the bag and stock full-swing carry distances.
- The structured recommendation path remains complete offline.

### Knowledge and personalization

- Player Knowledge changes recommendations only after explicit confirmation.
  There is no silent learning or automatic profile mutation.
- Generic tee-safety, low-loft short-game, and recovery heuristics are starter
  guardrails, not "Colt's confirmed leaks."
- Short and Long outcomes are not measured distance evidence.
- History distinguishes facts, results, observations, proposals, confirmed
  tendencies, validated cues, and confidence.

### Aim, voice, and data

- Aim View is a future child of Caddy Call. It is manual and abstract, with no
  GPS, course imagery, course database, location, or automatic target detection.
- Green Map is removed from the product.
- Press-to-talk is a later slice using the same structured validation path.
- The app remains local-first. Private iCloud sync is future infrastructure,
  not current behavior, and there is no custom Colt's Caddy account.

### Visual system

Scorecard Daylight is the active visual lock:

- Warm off-white paper background and warm-neutral surfaces.
- Warm charcoal primary ink.
- Forest green for brand and primary actions.
- Flag red in small doses for Caddy Call labeling.
- Amber for Alternate semantics.
- SF Rounded throughout.

Outdoor readability and WCAG AA pairings take priority over decorative effects.
No neon, excessive glass, novelty golf textures, decorative gradients, or
generic AI-dashboard styling.

## Deferred implementation slices

The approved sequence is recorded in `Docs/ROADMAP.md`. Deferred slices include
the Play + History shell, one live turn, Player Profile hub, Shot Detail and
enrichment, Review queue, evidence analyzer, learning proposals, typed natural
language, smart follow-up, manual Aim View, press-to-talk, and private iCloud
sync. A north-star item is not implemented until its own Roadmap slice is
completed and proved.

## Permanent non-goals

- Scorecards, holes, rounds, or session management.
- GPS, location, course maps, course databases, or automatic target detection.
- Green Map.
- Wind, elevation, or plays-like calculations.
- Sensor-based automatic shot tracking.
- Always-listening voice or a wake word.
- Custom accounts.
- Social feeds, leaderboards, badges, or gamification.
- A generic drill library or standalone Coach tab.
- Unconfirmed automatic profile mutation.
- Three equal recommendation choices.
- An accumulating lifetime chat transcript.

## Copy discipline

All caddie-visible text uses full grammatical sentences and normal punctuation.
No copy may claim unconfirmed knowledge or mention wind, plays-like, GPS,
score, maps, or AI marketing.
