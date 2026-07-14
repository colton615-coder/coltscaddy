# Decisions

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
