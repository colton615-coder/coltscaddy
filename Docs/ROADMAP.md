# Roadmap

## SINGLE NEXT ACTION

Wire persistence: create the ModelContainer at app entry and attach the
SwiftData schema. (Phase 4, item 1 below.)

---

## Phase 1 — Foundation ✅ DONE
App entry, ThreadView shell, dark chat thread, input row.

## Phase 2 — SwiftData domain models ✅ DONE (built, not wired)
ShotContext, ShotHistory, PlayerProfile, ClubDistance, Tendency, CoachingCue.

## Phase 3 — Design system ✅ DONE (structure only)
Theme, MessageBubble, ChatInputBar, CaddyCallCard, ShotInputTray.
NOTE: color/aesthetic direction NOT locked — current look is placeholder.

## Phase 4 — Core recommendation flow 👉 YOU ARE HERE
1. Wire ModelContainer at app entry; attach full schema.  ← NEXT ACTION
2. Seed PlayerProfile with Colt's bag distances (typed once, editable).
3. Build CaddyEngine v1: deterministic rules per CADDY_LOGIC.md, pure Swift,
   no UI imports, unit-testable.
4. Wire ShotInputTray output into CaddyEngine instead of the placeholder
   string; render the result as a CaddyCallCard in the thread.
5. Move CaddyCallCard from DesignSystem/ to Components/.
6. Log result flow: "Log result" on the card writes a ShotHistory record.
7. LLM voice layer: engine decision in, caddie-voiced copy out, with offline
   flat-wording fallback.

## Phase 5 — Visual lock + polish
Lock the color system and aesthetic direction (Colt decides from mockups),
apply it through Theme.swift, then polish spacing/motion.

## Phase 6 — v2 and beyond (do NOT start any of this)
- Activate tendency learning behavior (lifecycle already modeled)
- Coach/practice layer between rounds
- Colt's own shot logging as a data source
- Trackman import for real carry distances
- Aim View, then Green Map
- Maybe: course data via free APIs, hole visuals

## Rules of the road

- One feature per Codex loop. Never more.
- ROADMAP.md is the only document that says what is next. Update the YOU ARE
  HERE marker and SINGLE NEXT ACTION in the same change that completes a step.
- Anything not in Phase 4 is scope creep until Phase 4 is done.
