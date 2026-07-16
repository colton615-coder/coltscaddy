# Roadmap

## SINGLE NEXT ACTION

Phase 5.3: Stop the caddie bubble from repeating the Caddy Call card.

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
   with offline flat-wording fallback. ✅ DONE (backend implementation pending)

## Phase 5 — Visual lock + polish 👉 YOU ARE HERE
1. **5.1 — Lock Range Finder tokens in Theme.swift.** ✅ DONE
2. **5.2 — Polish the Caddy Call card layout hierarchy.** ✅ DONE
3. **5.3 — Stop the caddie bubble from repeating the Caddy Call card.** 👉 SINGLE NEXT ACTION
4. Polish spacing and motion.

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
- **Input bar nuance typing** — `ChatInputBar` is currently a non-functional
  placeholder; `CaddyShotInput.nuance` exists and is unreachable from the UI.
  In-scope for v1 per PROJECT.md, but it is its own loop after Phase 5.
- Maybe: course data via free APIs, hole visuals

## Rules of the road

- One feature per Codex loop. Never more.
- ROADMAP.md is the only document that says what is next. Update the YOU ARE
  HERE marker and SINGLE NEXT ACTION in the same change that completes a step.
- Anything not in Phase 4 is scope creep until Phase 4 is done.
