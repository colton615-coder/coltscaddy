# Caddy Logic — the brain

CaddyEngine is deterministic and rule-ordered for v1. Rules fire top-down;
the first matching rule in each section wins. Weighted/learned overrides are
v2. The learning MODELS exist now; the learning BEHAVIOR is dormant.

## Colt's three leaks (the spine of the engine)

1. TEE SHOTS: bad tee shots are leak #1. Rule: when trouble (water/OB/trees)
   is marked on a tee shot, recommend the most IN-PLAY club, not driver.
   Driver is only recommended when trouble is "none" or the miss is safe.
2. SHORT CHIPS: chunked short chips are leak #2. Rule: for chip-type shots,
   default to the LOWEST-loft option that works — putt first, bump-and-run
   second, lofted wedge last. The 60-degree is never the default.
3. TROUBLE COMPOUNDING: big numbers come from hero recoveries. Rule: when the
   lie is bad or trouble is marked between ball and target, bias hard toward
   the wedge-distance bailout or punch-out. Advancing to a full-wedge number
   is a WIN, not a lay-up.

## Decision order (v1)

1. Validate input (shot type, lie, trouble set, distance).
2. Apply the leak rules above for the matching shot type.
3. Select club from PlayerProfile bag distances (closest carry that keeps
   trouble out of play; round toward safety, never toward the hero number).
4. Choose target and safe miss from the trouble map (miss AWAY from marked
   trouble; when trouble is long, favor short; when trouble is one side,
   favor the other).
5. Produce the alternate play: the next-safest option, always shown.
6. Assign confidence band.

## Confidence bands

low / medium / medium-high / high. Confidence describes how sure the caddie
is, driven by: completeness of input, whether a confirmed tendency applies,
and sample size behind that tendency. Confidence NEVER blocks a call — the
caddie always commits. No clarifying questions before low-confidence calls.

## Tendency lifecycle (models live now, behavior activates in v2)

Fact → Result → Inference → Confirmed. A tendency warning requires a minimum
of three instances before it may fire. User confirmation is an explicit gate
before anything becomes Confirmed. Recency-weighted evidence blend: today's
evidence shifts confidence but never fully overrides a confirmed tendency.
Scoring-versus-learning intent is inferred from risk context; there is no
explicit toggle.

## Voice contract

The engine outputs a structured decision (play, target, safe miss, why,
confidence, alternate). The LLM renders it in one of three gears:
- Default: dry, decisive, brief.
- Guardrail: blunt with light trash talk when the input pattern matches one
  of the three leaks and Colt is about to do the dumb thing anyway.
- Reset: calm and steadying when recent logged outcomes show a bad stretch.
All rendered copy: full sentences, normal punctuation, no wind, no plays-like.
