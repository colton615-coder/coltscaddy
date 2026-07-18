# Roadmap

This is the only authority for the next implementation action. The approved
north-star direction is implemented one narrow vertical slice at a time.

## SINGLE NEXT ACTION

Build the Play + History app shell: route the existing working flow into Play,
add a truthful History empty state and chronology from existing ShotHistory
records, and preserve the unfinished Play state while switching tabs.

Do not add one-live-turn reset behavior, Player Knowledge, Shot Detail,
learning, natural-language parsing, Aim View, speech, or iCloud sync in this
slice.

---

## Phase 0 — Source-of-truth reconciliation ✅ DONE

- `Docs/PROJECT.md` is the canonical product and experience authority.
- Current implementation, approved north star, deferred slices, and permanent
  non-goals are separated explicitly.
- Architecture, Caddy Logic, Decisions, Roadmap, and Handoff agree on the
  deterministic boundary, confirmed-knowledge gate, no-round model, manual Aim
  View boundary, future private iCloud sync, and Scorecard Daylight.
- The July 13 external source update remains historical input only.

## Existing implementation baseline ✅ DONE

- SwiftUI thread shell, app-level SwiftData container, idempotent profile seed,
  and editable bag carries.
- Deterministic offline `CaddyEngine` with focused unit coverage.
- Tap-first structured shot tray and optional typed nuance.
- Compact command-first Caddy Call with Alternate and Remind me how.
- Required-outcome `ShotHistoryStore.log` seam and six-choice Quick Grid.
- Provider-neutral optional voice boundary with local fallback.

## Phase 5 — Visual lock and polish ✅ CLOSED

- Compact command-first Caddy Call: selected source, runtime capture, normalized
  comparison, focused UI test, and passed design QA.
- Compact outcome picker: committed before/after spacing captures and focused
  behavior test.
- Scorecard Daylight: applied in `Theme.swift`; focused captures cover the
  thread, composer, shot tray, Caddy Call states, outcome sheet, and bag editor.
  `design-qa.md` reports no actionable P0/P1/P2 findings and `final result:
  passed` for the locked theme scope.
- Proof boundary: this closure uses recorded simulator/build/test evidence from
  the implementation loops. Phase 0 itself did not rerun builds, tests, or the
  simulator. No physical-device visual pass has occurred.

## Approved north-star delivery sequence

Only the first unchecked slice is active. Later slices are direction, not
authorization to implement adjacent work.

1. **Play + History app shell.** 👉 NEXT
   - Route the working flow into Play.
   - Add a truthful History empty state and calendar-date chronology from
     existing records.
   - Preserve unfinished Play state across tab switches.
2. **Current-shot workspace.** Replace accumulation with one restorable live
   turn while preserving the current call and result behavior.
3. **Player Profile hub.** Evolve the golfer button and preserve Bag editing;
   do not ship empty knowledge destinations.
4. **Shot Detail and enrichment.** Add actual club, measured/estimated distance
   with provenance, correction, and deletion.
5. **Review queue.** Ask for detail only when it materially helps learning.
6. **Evidence analyzer.** Create observations without changing calls.
7. **Learning proposals.** Require explicit confirmation before knowledge can
   affect calls.
8. **Typed natural-language entry.** Parse into a validated structured draft
   with the tap-first path as fallback.
9. **Smart follow-up.** Ask one material question and reuse confirmed answers.
10. **Manual Aim View.** Visualize the structured decision without location,
    course imagery, or course data.
11. **Press-to-talk.** Feed the transcript through the same structured path.
12. **Private iCloud sync.** Add CloudKit only after local schema and edit
    semantics are stable.

## Rules of the road

- One feature per Codex loop.
- Read and quote the exact `SINGLE NEXT ACTION` before editing.
- Update this file and `Docs/DECISIONS.md` in the same loop that completes a
  slice.
- Preserve existing behavior and user data through migrations.
- Build with `generic/platform=iOS Simulator`; test with a concrete installed
  simulator.
- Treat build, automated tests, simulator observation, visual comparison,
  physical-device observation, commit, push, and remote visibility as separate
  proof claims.
- No push or next slice without Colt's approval.
