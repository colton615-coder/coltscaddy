# COLTSCADDY

Display name: "Colt's Caddy"

Vision: A conversational AI caddie with a real personality that talks Colt
through his round, learns his actual game, and delivers one clear, decisive,
personal call per shot. Not "what does this shot play like" — "what does this
shot play like FOR COLT."

## Three Pillars

1. On-course assist — situation in, one clear call out.
2. Knows YOUR game — evidence-based tendencies, not generic golf advice.
3. Coach brain — deferred to v2+; the models exist, the coaching layer does not.

## Companion App Boundary

18Birdies is the designated companion for GPS, wind, plays-like distance, and
scoring. Colt's Caddy sits ABOVE it as the synthesis layer. Colt's Caddy will
never contain GPS, maps, wind modeling, plays-like math, or scorecards. Any
reference to wind or plays-like distance anywhere in this codebase — including
placeholder copy — is a bug.

## v1 SCOPE (locked, expanded 2026-07)

- Conversational thread UI: caddie speaks in message bubbles; the Caddy Call
  lands as a card in the thread. (Interaction pattern LOCKED.)
- Tap-first shot input tray: Shot type (Full/Chip/Putt/Tee), Lie
  (Tee/Fairway/Rough/Sand), Trouble (Water/OB/Trees/Bunker/None,
  multi-select), Distance (typed). Optional typed nuance.
- Output: Caddy Call card — Play / Target / Safe miss / Why (one line) /
  Confidence, with the alternate play shown immediately alongside the primary.
- Deterministic recommendation engine (CaddyEngine) per CADDY_LOGIC.md.
  The engine decides; the LLM only voices the decision.
- SwiftData persistence: shot history, player profile, tendencies, coaching
  cues. IN SCOPE for v1. This supersedes all earlier "no persistence" language.
- Player profile: bag distances and confirmed tendencies.
- Personality: three gears — dry and decisive by default; blunt with light
  trash talk when Colt is about to do something dumb; calm and reset-focused
  when he is tilted.

## NOT IN v1

- Aim View (deferred module — build after core recommendation flow is solid)
- Green Map (deferred module — sibling to Aim View, logged, not started)
- Voice input/output
- Accounts or sign-in
- Course data of any kind
- Coach/practice layer (v2)

## NEVER (any version)

- GPS, maps, or location
- Wind or plays-like modeling
- Shot tracking via sensors
- Scorecards

## Copy Discipline (non-negotiable)

All caddie-visible text uses full grammatical sentences with normal
punctuation. No clipped fragments. Zero wind or plays-like references,
including in placeholder strings.
