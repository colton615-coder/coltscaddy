# Roadmap

## SINGLE NEXT ACTION

Outcome tap — Log result captures one outcome value (good / left / right /
short / long / poor contact) into ShotHistory.

---

## Phase 1 — Foundation ✅ DONE
App entry, ThreadView shell, dark chat thread, input row.

## Phase 2 — SwiftData domain models ✅ DONE (built, not wired)
ShotContext, ShotHistory, PlayerProfile, ClubDistance, Tendency, CoachingCue.

## Phase 3 — Design system ✅ DONE (structure only)
Theme, MessageBubble, ChatInputBar, CaddyCallCard, ShotInputTray.
NOTE: Phase 3 established structure only; Phase 5.1 later locked the Range
Finder color and typography direction.

## Phase 4 — Core recommendation flow ✅ DONE
1. Wire ModelContainer at app entry; attach full schema. ✅ DONE
2. Seed PlayerProfile with Colt's bag distances (typed once, editable). ✅ DONE
   NOTE: seeded carries are placeholders — Colt corrects them in the bag
   editor (golfer button, top right of the thread).
3. Build CaddyEngine v1: deterministic rules per CADDY_LOGIC.md, pure Swift,
   no UI imports, unit-testable. ✅ DONE
4. Wire ShotInputTray output into CaddyEngine instead of the placeholder
   string. ✅ DONE
5. Render the decision as a CaddyCallCard in the thread and move
   CaddyCallCard from DesignSystem/ to Components/. ✅ DONE
6. Log result flow: "Log result" on the card writes a ShotHistory record. ✅ DONE
7. Provider-neutral voice layer: engine decision in, caddie-voiced copy out,
   with offline flat-wording fallback. ✅ DONE (backend implementation pending;
   retained for future conversational surfaces, while the live shot response is
   currently card-only)

## v1 scope gap — ChatInputBar nuance path ✅ DONE

Model (a) is shipped: nuance is typed before opening the tray, attached to the
next submitted shot, shown in the user's bubble, and cleared after submission.
Whitespace-only input becomes `nil`. The engine does not use nuance to change
the decision.

## v1 finishing loops 👉 YOU ARE HERE

1. **Remind me how — one static execution tip per shot type.** ✅ DONE
   - Tips are engine-owned, deterministic, offline, and expand inline on the
     Caddy Call card.
2. **Outcome tap — capture one outcome value in ShotHistory.** 👉 NEXT

## Phase 5 — Visual lock + polish ⏸ DEFERRED
The locked visual work remains intact. The final screen-by-screen spacing and
motion audit resumes after the outcome-tap loop.

1. **5.1 — Lock Range Finder tokens in Theme.swift.** ✅ DONE
2. **5.2 — Polish the Caddy Call card layout hierarchy.** ✅ DONE
   - July 18 refinement keeps the original Target / Safe miss / Why stack,
     increases heading weight and size, brightens the values, and shortens the
     engine-owned display copy without changing recommendation rules.
   - The approved reference, verified runtime, and side-by-side comparison are
     in `Proof/caddy-call-approved-*.png`.
3. **5.3 — Stop the caddie bubble from repeating the Caddy Call card.** ✅ DONE
   - Shot submission now renders the user's summary followed directly by the
     Caddy Call card. The initial greeting remains; the post-shot lead bubble
     and confidence badge are not rendered.
   - Alternate play is an amber disclosure. Remind me how expands inline to a
     compact COMMIT TO THIS cue above the full-width Log result action.
4. **Keep the golfer/bag button clear of thread content.** ✅ DONE
   - `ThreadView` now uses a top-trailing safe-area inset that reserves real
     layout space while keeping the existing button appearance and route.
5. Final spacing and motion polish remains. ⏸ DEFERRED

## Phase 6 — v2 and beyond (do NOT start any of this)
- Activate tendency learning behavior (lifecycle already modeled)
- Coach/practice layer between rounds
- Colt's own shot logging as a data source
- Trackman import for real carry distances
- Aim View, then Green Map
- **Conversational shot debrief** — Colt types what happened after a shot
  (ball flight, swing feel, cues) and the caddie retains it for later shots.
  Requires shot logging as a data source (v3), the coaching layer (v2+), and
  active tendency learning (v2). Explicitly out of v1.
- Maybe: course data via free APIs, hole visuals

## Rules of the road

- One feature per Codex loop. Never more.
- ROADMAP.md is the only document that says what is next. Update the YOU ARE
  HERE marker and SINGLE NEXT ACTION in the same change that completes a step.
- Anything not in Phase 4 is scope creep until Phase 4 is done.
