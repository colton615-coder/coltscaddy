# Caddy Logic — Current Engine and Approved Evolution

This file owns the truth about current deterministic recommendation behavior.
The north star defines future direction; it does not make future behavior live.

## Current v1 engine

`CaddyEngine` is pure Swift, deterministic, rule-ordered, and usable offline.
It receives a structured `CaddyShotInput` plus plain Swift bag carries. It does
not currently read confirmed tendencies, validated cues, preferred shapes,
History, outcome patterns, or a `PlayerKnowledgeSnapshot`.

Current top-level order:

1. Normalize `Trouble.none` out of the trouble set.
2. If distance is zero or negative, return a complete low-confidence safe call.
3. Route by shot type: Tee, Chip, Putt, or Full.
4. Produce club, distance, target, safe miss, why, confidence, alternate, lead,
   and a static shot-type execution cue.

### Tee

- Water, OB, or trees select the first available in-play club from the current
  hard-coded preference order, with driver excluded.
- With no penalty trouble, use Driver when present; otherwise use the longest
  club.

### Chip

- Sand lie or bunker trouble selects Sand Wedge when present, otherwise the
  highest-loft available wedge.
- A clean fairway chip of 12 yards or less selects Putter.
- Other chips select an 8 Iron when present, then 9 Iron, then the shortest
  non-wedge fallback. A lofted wedge remains the alternate.

This low-loft chip behavior is a generic hard-coded safety heuristic. It is not
confirmed personal knowledge about Colt, and the current 8 Iron preference must
not be described as a learned tendency.

### Putt

- Select Putter, start line, and speed-first safe-miss language.

### Full shot

- Rough, sand, or any marked trouble selects the wedge closest to 100 yards as
  a bailout; punch-out is the alternate.
- A clean full shot selects the shortest club that carries at least the entered
  distance. The next shorter club is the safer alternate.

### Confidence and voice

Current confidence is branch-owned static engine output. It is not calculated
from sample size or learned evidence. Confidence never blocks the current call.

The engine also owns one short fallback `lead` and one static execution cue per
shot type. The optional language service may re-voice a completed lead but may
not change any structured field. The live UI currently renders the card without
a post-shot lead bubble.

## Generic guardrails versus personal knowledge

The current tee-safety, low-loft chip, and recovery-bailout rules are generic
starter guardrails. They are not "Colt's three leaks," confirmed tendencies, or
evidence-backed personalization. Bag carries are user-editable facts; today
they are the only player data used by the engine.

Generic guardrails may remain as conservative defaults, but future confirmed
preferences can supersede them only through an explicit, tested knowledge
slice. UI and copy must label the difference honestly.

## Current result evidence

The Quick Grid persists one of six outcomes: Good, Left, Right, Short, Long, or
Poor contact. The current write does not analyze, infer, confirm, or activate a
tendency.

Short and Long are categorical outcomes, not measured distance evidence. They
may never update a carry value or support a carry proposal without separate
user-entered measured or estimated distance and provenance.

## Approved future evolution — not implemented

Future Roadmap slices may add:

- A validator that asks one material follow-up when missing information could
  change the call. The current engine instead returns a safe low-confidence
  call for invalid distance and asks no clarifying question.
- An evidence analyzer that creates observations without changing calls.
- Learning proposals with sample size, recency, relevance, and provenance.
- An immutable `PlayerKnowledgeSnapshot` containing user-entered facts,
  confirmed tendencies, and validated cues.
- Confirmed overrides that affect later recommendations.

Only user-entered facts and explicitly approved proposals may enter the future
snapshot and change recommendations. Unconfirmed observations may eventually
lower confidence or trigger a focused question, but they may not silently
choose another club, mutate the profile, or rewrite history.

Smart follow-up, learned overrides, and snapshot integration each require their
own Roadmap slice and focused proof. No future behavior in this section is live
today.
