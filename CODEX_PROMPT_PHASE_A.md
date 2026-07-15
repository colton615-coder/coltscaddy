# CODEX PROMPT — PHASE A (2026-07-15)

Paste everything below this line into Codex in Xcode.

---

## CONTEXT — READ FIRST

Read these repo files before writing any code, in this order:
`Docs/PROJECT.md`, `Docs/ROADMAP.md`, `Docs/CADDY_LOGIC.md`, `Docs/ARCHITECTURE.md`,
`Docs/DECISIONS.md`, `TEMP_DAY_PLAN_2026-07-15.md`.

These files are ground truth. Do not infer project state from memory or
from what seems reasonable.

## TASK — PHASE A ONLY

**Execute Phase A of TEMP_DAY_PLAN_2026-07-15.md. Do not start Phase B.**

Right now `ThreadView.addShot(_:)` calls `CaddyEngine.recommend()`, gets a
real `CaddyDecision`, passes it to `CaddyVoiceService`, and then appends
the voiced result as a plain `MessageBubble`. The structured decision is
being flattened into a paragraph. `CaddyCallCard` exists and renders
correctly in its own preview, but nothing in the app ever constructs one.

Fix that.

### Requirements

1. Move `CaddyCallCard.swift` from `DesignSystem/` to `Components/` per
   Docs/ARCHITECTURE.md. Confirm target membership after the move.
2. The thread's message model must be able to hold EITHER a text bubble OR
   a Caddy Call card. Do not fake this by stuffing card text into a string.
3. Populate the card from the `CaddyDecision` returned by `CaddyEngine` —
   never from parsed LLM prose. The voiced text from `CaddyVoiceService`
   may appear as the caddie's spoken bubble; the card's fields come from
   the engine. This split is non-negotiable (Docs/ARCHITECTURE.md).
4. The alternate play renders on the card immediately, alongside the
   primary — not behind a tap.
5. Confidence renders as a label. It never blocks or gates the call.
6. `Log result` and `Remind me how` stay present but remain inert. Wiring
   `Log result` is Phase B. Do not do it today.

### Hard stops

- Do not change any value in `Theme.swift`. The visual direction is NOT
  locked; Colt decides it from mockups in a later phase. Using existing DS
  tokens is fine; changing them is out of scope.
- Do not read from or write to `Tendency`. Learning behavior is dormant.
- No wind or plays-like references in any string, including placeholders.
- All caddie-visible copy: full grammatical sentences, normal punctuation.
- One feature per loop. Phase A only.

### Definition of done

- Build succeeds on a generic iOS Simulator destination.
- Submitting a shot from `ShotInputTray` produces a visible
  `CaddyCallCard` in the thread.
- Scroll-to-latest still works when a card is the last item.
- `git diff --check` passes.

## VERIFICATION RULES — CITE OR IT DIDN'T HAPPEN

- Every claim needs a **pointer** (the exact file/function/command that
  proves it) and a **falsifier** (the one check that would prove it wrong).
- Trust hierarchy: build/test result > observed simulator behavior >
  `git log` / `git diff` > file contents > doc claims > your own summary.
  Your memory ranks below the current files.
- **Compiles ≠ Tested ≠ Observed ≠ Shipped.** Report each honestly,
  including what was tried and NOT proved, and the recovery path.
- If an instruction here conflicts with a repo doc, STOP and ask. Do not
  resolve it silently.

## REQUIRED OUTPUT FORMAT

End your response with a **bold summary** stating exactly:
- **Which phase and which task**
- **What was completed**
- **What was proved** — labeled compiles / tested / observed / shipped
- **What was NOT proved**
- **Two or three 30-second checks Colt can run from his phone to verify
  your claims**
