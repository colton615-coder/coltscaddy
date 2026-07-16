# Architecture

## Tech Stack

- SwiftUI
- SwiftData (persistence is in scope for v1)
- Swift
- iOS 26+ (deployment target 26.5, matching project.pbxproj)
- Provider-neutral backend endpoint for the caddie voice

## The Split (most important rule in this file)

CaddyEngine owns ALL decision logic. It is deterministic, rule-ordered, and
testable without a network connection. The LLM never chooses the club, the
target, the safe miss, or the confidence. The LLM receives the engine's
structured decision and engine-owned `lead`, then may re-voice that lead in the
caddie's personality. If the network is down, the app still produces the
engine's complete one-sentence lead and the correct structured Caddy Call.

The iOS app never imports an AI-provider SDK and never stores a provider API
key. It posts the shot context and completed CaddyDecision to the configured
`CADDY_VOICE_ENDPOINT`; provider selection and credentials live behind that
backend boundary. The backend returns `{ "assistantText": "..." }`, where
`assistantText` is ONE short sentence in the caddie's voice. It may re-voice
the lead with personality, but it may not restate the card fields or alter the
structured decision.

## Target Folder Structure

COLTSCADDY/
  App/           — app entry, ModelContainer setup
  Screens/       — ThreadView, ShotInputTray
  Components/    — reusable UI not tied to one screen (CaddyCallCard moves here)
  Models/        — SwiftData @Model types + shared enums (CoreTypes)
  CaddyEngine/   — deterministic decision logic, no UI imports
  DesignSystem/  — Theme, MessageBubble, ChatInputBar

All new code files go in their designated folder. Confirm placement before
creating files.

## Persistence Rules

- One ModelContainer, created at app entry, injected via .modelContainer().
- Views read via @Query; writes go through small, named store functions —
  no scattered modelContext.insert calls inside view bodies.
- Schema: ShotContext, ShotHistory, PlayerProfile, ClubDistance, Tendency,
  CoachingCue.

## Design System Rules

- SF Symbols only, one weight, used sparingly. Prefer text labels.
- The visual direction is locked as Range Finder: near-black with cool grays,
  one cyan accent, and SF Rounded throughout. No serif.
- Color carries meaning and is not decorative: cyan is the accent, green is
  confidence, and amber is the alternate play.
- 44pt minimum tap targets. Generous whitespace.
