# COLT'S CADDY — DAY PLAN / AGENT WORK ORDER
## Date: 2026-07-15

This document is the authoritative work order for every agent (Codex,
Claude, or any other) touching this project today. If an instruction
anywhere else conflicts with this document, this document wins for today's
scope only. Long-term truth still lives in Docs/ROADMAP.md, Docs/PROJECT.md,
Docs/ARCHITECTURE.md, Docs/DECISIONS.md, and Docs/CADDY_LOGIC.md.

---

## 0. READ FIRST — REQUIRED CONTEXT FOR ANY AGENT

Before writing a single line of code, read these five files in this order:

1. `Docs/PROJECT.md` — vision and locked v1 scope
2. `Docs/ROADMAP.md` — current phase and single next action
3. `Docs/CADDY_LOGIC.md` — the engine's decision rules
4. `Docs/ARCHITECTURE.md` — folder structure, the AI/deterministic split,
   persistence rules
5. `Docs/DECISIONS.md` — dated decision log; the most recent entry wins

Do not infer project state from memory, from prior chat summaries, or from
what "seems reasonable." The files are the ground truth.

---

## 1. WHERE WE ARE (state at start of day)

**Phase 4 — Core recommendation flow. Items 1, 2, 3, 4, and 7 are DONE.**

Working and verified in code:
- SwiftData models exist and match the schema in Docs/ARCHITECTURE.md
- ModelContainer is wired at app entry with the full schema
- ProfileSeeder creates the profile once, idempotently, and never
  overwrites user-edited carry distances
- BagEditorView reads and writes ClubDistance through SwiftData
- CaddyEngine is complete and deterministic; all three leak rules are
  implemented (tee penalty-trouble, chip loft-order, trouble bailout)
- ShotInputTray builds a valid `CaddyShotInput` and hands it to ThreadView
- ThreadView calls `CaddyEngine.recommend()` and gets a real `CaddyDecision`
- CaddyVoiceService renders that decision, with a complete offline local
  fallback

**The one gap:** ThreadView takes the voiced response and appends it as a
plain `MessageBubble`. The `CaddyCallCard` component exists, is built, and
looks correct in its own preview — but nothing in the app ever constructs
one. The structured decision is being flattened into a paragraph.

---

## 2. TODAY'S SCOPE — TWO ITEMS, IN THIS ORDER, NOTHING ELSE

### PHASE A — Render the Caddy Call as a card in the thread
*(Docs/ROADMAP.md Phase 4, item 5)*

**Goal:** when Colt submits a shot, the caddie's answer lands in the thread
as a `CaddyCallCard` showing Play / Target / Safe miss / Why / Confidence,
with the alternate play shown immediately alongside the primary.

**Requirements:**
- Move `CaddyCallCard.swift` from `DesignSystem/` to `Components/` per
  Docs/ARCHITECTURE.md. Confirm target membership after the move.
- The thread's message model must be able to hold either a text bubble or a
  a caddy-call card. Do not fake this by stuffing card text into a string.
- The card is populated from the `CaddyDecision` returned by CaddyEngine —
  never from parsed LLM prose. The LLM's voiced text may appear as the
  caddie's spoken bubble; the card's fields come from the engine.
- The alternate play renders on the card immediately, not behind a tap.
- Confidence renders as a label. It never blocks or gates the call.
- `Log result` and `Remind me how` buttons stay present but remain inert
  this phase. Wiring `Log result` is Phase B, not Phase A.

**Definition of done:**
- Build succeeds on a generic iOS Simulator destination
- Submitting a shot from ShotInputTray produces a visible CaddyCallCard in
  the thread
- Scroll-to-latest still works with a card as the last item
- `git diff --check` passes

### PHASE B — Log result writes a ShotHistory record
*(Docs/ROADMAP.md Phase 4, item 6)*

**Do not start Phase B until Phase A is built, verified in the simulator,
committed, and pushed.**

**Goal:** tapping `Log result` on a CaddyCallCard writes a real
`ShotHistory` record to SwiftData.

**Requirements:**
- The write goes through a small, named store function. No
  `modelContext.insert` calls scattered inside view bodies (Docs/ARCHITECTURE.md,
  Persistence Rules).
- The `ShotHistory` record must persist the `ShotContext` for that shot and
  the `recommendationGiven`.
- Outcome fields (`outcome`, `missDirection`, `contactQuality`,
  `followedRecommendation`) may be left nil this phase. Capturing them is a
  separate step — do not build an outcome-entry UI today.
- Tendency learning behavior stays DORMANT. The models exist; the behavior
  is v2. Do not read from or write to `Tendency` today.

**Definition of done:**
- Build succeeds
- Tapping `Log result` writes exactly one ShotHistory record
- A focused unit test proves the record is written with the correct context
  and recommendation text
- The full `COLTSCADDYTests` target passes on a concrete simulator
- `git diff --check` passes

---

## 3. VERIFICATION RULES — CITE OR IT DIDN'T HAPPEN

These apply to every agent, every claim, every session. They are not
optional and they are not negotiable.

### 3.1 The trust hierarchy

When two sources disagree, the higher one wins. Always. No exceptions.

1. Build result / test result — binary, cannot be talked into anything
2. Observed behavior in the simulator or on device
3. `git log` / `git diff` — what is actually committed
4. The file contents themselves
5. A planning doc's claim (a "✅ DONE" tick is a claim, not proof)
6. Any AI's summary, recollection, or confident assertion — lowest, always

An agent's memory of a past session ranks BELOW the current files. If they
conflict, the files win and the agent must say out loud that its memory was
wrong.

### 3.2 Every claim needs a pointer

No claim ships without the evidence attached. Required format:

> **Claim** — what is true
> **Pointer** — the exact file, function, or command that proves it
> **Falsifier** — the one check that would prove this claim wrong

If an agent cannot produce a pointer, the correct output is "I don't know,
here's how to find out" — not a confident guess. A guess in a confident
voice is the single most expensive thing in this project.

### 3.3 Verify claims against artifacts, never against prose

Do not verify a doc against another doc. Do not verify code against a
summary of the code. Check the thing itself:

- "CaddyEngine is done" → open CaddyEngine.swift, confirm the rules exist
- "The card renders" → search ThreadView.swift for `CaddyCallCard`; zero
  hits means it does not render, regardless of what any doc says
- "It's committed" → `git log --oneline -5`, not memory
- "Tests pass" → the actual test output, on a concrete simulator

### 3.4 Say precisely what was proved

These are four different things and must never be blurred:
- **Compiles** — the build succeeded
- **Tested** — a specific test asserted a specific behavior and passed
- **Observed** — it was seen working in the simulator
- **Shipped** — it is committed and pushed

Report each honestly, including what was tried and NOT proved, and the
recovery path for anything that failed. "It should work" is not a status.

### 3.5 Mobile-friendly spot checks (Colt can run these in seconds)

Colt is often reviewing from a phone and cannot read a diff. Any claim
must come with a check he can run in under 30 seconds:

- A filename-and-keyword search ("does ThreadView mention CaddyCallCard?")
- A one-line command output (`git log --oneline -3`)
- A single simulator action ("submit a shot, does a card appear?")

If a claim cannot be reduced to a check that simple, the agent must say so
and explain what deeper check is required instead.

### 3.6 Cross-checking between AI agents

Two AI agents agreeing is weak evidence, not strong evidence. They fail in
correlated ways: both fluent, both agreeable, both pattern-matching.

- Never use one agent's report as another agent's ground truth. A reviewer
  reading a summary is grading prose, not reality.
- A reviewing agent gets the raw files and the raw build/test output — the
  same artifacts, not the other agent's conclusions.
- A reviewing agent's job is to disagree with citations, not to rate,
  praise, or bless. "Looks good" from an agent with no access to ground
  truth is theater.
- The tiebreaker between two disagreeing agents is never a third agent. It
  is the artifact: the build, the test, the file, the simulator.

### 3.7 Disagreement is mandatory, not rude

If an agent thinks Colt is wrong, is about to build the wrong thing, or is
sliding into scope creep, it says so plainly and immediately. Agreement
that isn't earned is worse than useless here — it is exactly how four
previous project restarts happened.

---

## 4. SCOPE GUARDRAILS — HARD STOPS FOR TODAY

Any agent that finds itself doing one of these must stop and flag it
instead:

- **Do not touch `Theme.swift` colors, fonts, or aesthetic.** The visual
  direction is NOT locked. That is Phase 5 and Colt decides it from
  mockups, not from an agent's taste. Using the existing DS tokens is fine;
  changing their values is out of scope.
- **Do not build the outcome-capture UI.** Log result writes a record
  today. That is all.
- **Do not activate tendency learning.** Models only, behavior dormant.
- **Do not build Aim View or Green Map.** Deferred modules.
- **Do not add GPS, maps, wind, plays-like distance, or scorecards.** Ever,
  any version. 18Birdies owns those. A wind or plays-like reference
  anywhere — including placeholder copy — is a bug, not a feature.
- **Do not let the LLM choose the club, target, safe miss, or confidence.**
  CaddyEngine decides. The LLM voices. This split is non-negotiable.
- **Do not import an AI-provider SDK or store a provider key in the app.**
  Provider lives behind the backend endpoint.
- **One feature per Codex loop. Never more.** Phase A and Phase B are two
  separate loops, not one.

---

## 5. COPY DISCIPLINE (applies to every string written today)

- Full grammatical sentences. Normal punctuation. No clipped fragments.
- Zero wind references. Zero plays-like references. Including placeholders.
- Caddie voice gears: dry and decisive by default; blunt with light trash
  talk when Colt is about to do something dumb; calm and reset-focused when
  he's tilted.
- The caddie is unnamed. Colt is the user, not the caddie.

---

## 6. END-OF-EACH-PHASE PROTOCOL (do not skip — this is the anti-drift step)

After **each** phase completes, before moving on:

1. Build and verify in the simulator.
2. `git add -A && git commit -m "<what changed>" && git push`
   Commit and push even if the next phase starts in five minutes. The
   uncommitted-work-overnight problem is what causes lost days.
3. Update `Docs/ROADMAP.md` in the same change: tick the completed item, move
   the 👉 YOU ARE HERE marker if the phase changed, and rewrite SINGLE NEXT
   ACTION at the top.
4. Add a dated entry to `Docs/DECISIONS.md` for anything decided, anything tried
   that failed, and the recovery path if it failed.
5. State plainly what was proved and what was NOT proved. "Builds" is not
   "tested." "Tested" is not "works on device."

---

## 7. IF SOMETHING GOES WRONG

- **Tests won't run:** `xcodebuild` requires a concrete simulator
  destination for the test action. Keep the generic destination for builds
  only; list installed simulators and pick a concrete device ID for tests.
- **Full suite stalls:** run `COLTSCADDYTests` alone first to separate
  app/unit correctness from UI-runner trouble. Do not treat UI tests as
  passing until a clean full run completes.
- **New files don't appear in Xcode:** reopen the project before changing
  target membership.
- **Seeded bag values look wrong:** check whether a PlayerProfile already
  exists. The seeder refuses to overwrite by design. Edit carries in the bag
  editor or explicitly reset app data.
- **An instruction here conflicts with a repo doc:** stop and ask Colt.
  Do not resolve it silently.

---

## 8. END OF DAY — LEAVE A CLEAN LANDING

Before closing the laptop, regardless of how far you got:

1. Commit and push everything. No exceptions, even mid-feature.
2. `Docs/ROADMAP.md` reflects reality: correct YOU ARE HERE, correct SINGLE NEXT
   ACTION, correct ticks.
3. `Docs/DECISIONS.md` has today's dated entry.
4. Write one line at the top of the next session's context: what the very
   next action is and why.

If tomorrow-morning-Colt has to reconstruct what happened, today's agents
failed step 7.
