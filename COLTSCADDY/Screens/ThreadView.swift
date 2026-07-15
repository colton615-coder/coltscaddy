import SwiftUI
import SwiftData

struct ThreadView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [PlayerProfile]
    @State private var messages: [ThreadMessage] = [
        ThreadMessage(
            content: .text(
                "Good to see you, Colt. Tell me what you're facing and I'll give you the smart play.",
                sender: .them
            )
        )
    ]
    @State private var isShotInputPresented = false
    @State private var isBagEditorPresented = false
    @State private var isAwaitingCaddyResponse = false

    private let voiceService: CaddyVoiceService

    init(voiceService: CaddyVoiceService = .live) {
        self.voiceService = voiceService
    }

    var body: some View {
        VStack(spacing: DS.Spacing.lg) {
            conversationFeed
            inputRow
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.md)
        .background(DS.Color.bg.ignoresSafeArea())
        .overlay(alignment: .topTrailing) {
            bagButton
                .padding(.trailing, DS.Spacing.xl)
                .padding(.top, DS.Spacing.sm)
        }
        .sheet(isPresented: $isShotInputPresented) {
            ShotInputTray { submission in
                addShot(submission)
            }
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isBagEditorPresented) {
            BagEditorView()
                .presentationDragIndicator(.visible)
        }
    }

    private var bagButton: some View {
        Button {
            isBagEditorPresented = true
        } label: {
            Image(systemName: "figure.golf")
                .font(DS.Font.label)
                .foregroundStyle(DS.Color.textPrimary)
                .frame(width: DS.Size.tapTarget, height: DS.Size.tapTarget)
                .background(
                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                        .fill(DS.Color.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                        .stroke(DS.Color.hairline)
                )
        }
        .buttonStyle(.plain)
    }

    private var conversationFeed: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: DS.Spacing.xl) {
                    ForEach(messages) { message in
                        threadItem(for: message)
                            .id(message.id)
                    }
                }
                .padding(.top, DS.Spacing.xxl)
                .padding(.bottom, DS.Spacing.lg)
            }
            .scrollIndicators(.hidden)
            .onAppear {
                scrollToLatest(using: proxy)
            }
            .onChange(of: messages.count) {
                scrollToLatest(using: proxy)
            }
        }
    }

    private var inputRow: some View {
        HStack(spacing: DS.Spacing.md) {
            Button {
                isShotInputPresented = true
            } label: {
                Text("+")
                    .font(DS.Font.playCall)
                    .foregroundStyle(DS.Color.textPrimary)
                    .frame(width: DS.Size.tapTarget, height: DS.Size.tapTarget)
                    .background(
                        RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                            .fill(DS.Color.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                            .stroke(DS.Color.hairline)
                    )
            }
            .buttonStyle(.plain)
            .disabled(isAwaitingCaddyResponse)

            ChatInputBar()
        }
    }

    private func addShot(_ submission: ShotSubmission) {
        messages.append(ThreadMessage(content: .text(submission.summary, sender: .me)))
        isAwaitingCaddyResponse = true

        let decision = CaddyEngine.recommend(for: submission.input, bag: currentBag)
        let voiceInput = CaddyVoiceInput(shot: submission.input, decision: decision)

        Task {
            let response = await voiceService.response(for: voiceInput)
            messages.append(ThreadMessage(content: .text(response, sender: .them)))
            messages.append(
                ThreadMessage(
                    content: .caddyCall(
                        CaddyCallItem(shot: submission.input, decision: decision)
                    )
                )
            )
            isAwaitingCaddyResponse = false
        }
    }

    @ViewBuilder
    private func threadItem(for message: ThreadMessage) -> some View {
        switch message.content {
        case let .text(text, sender):
            MessageBubble(text: text, sender: sender)
        case let .caddyCall(call):
            CaddyCallCard(
                play: call.decision.play,
                target: call.decision.target,
                safeMiss: call.decision.safeMiss,
                why: call.decision.why,
                confidence: call.decision.confidence.displayLabel,
                alternate: .init(
                    type: call.decision.alternate.type,
                    text: call.decision.alternate.text
                ),
                isLogResultEnabled: !call.isLogged,
                logAction: {
                    logResult(for: message.id)
                }
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func logResult(for messageID: UUID) {
        guard let index = messages.firstIndex(where: { $0.id == messageID }),
              case var .caddyCall(call) = messages[index].content,
              !call.isLogged else {
            return
        }

        do {
            try ShotHistoryStore.log(
                shot: call.shot,
                decision: call.decision,
                in: modelContext
            )
            call.isLogged = true
            messages[index].content = .caddyCall(call)
        } catch {
            assertionFailure("Failed to log the shot result: \(error)")
        }
    }

    private var currentBag: [CaddyBagClub] {
        let savedBag = profiles.first?.clubDistances.map {
            CaddyBagClub(name: $0.clubName, carryYards: $0.carryYards)
        } ?? []

        guard !savedBag.isEmpty else {
            return ProfileSeeder.defaultBag.map {
                CaddyBagClub(name: $0.name, carryYards: $0.carryYards)
            }
        }

        return savedBag
    }

    private func scrollToLatest(using proxy: ScrollViewProxy) {
        guard let latestID = messages.last?.id else { return }

        withAnimation {
            proxy.scrollTo(latestID, anchor: .bottom)
        }
    }
}

private struct ThreadMessage: Identifiable {
    enum Content {
        case text(String, sender: MessageBubble.Sender)
        case caddyCall(CaddyCallItem)
    }

    let id = UUID()
    var content: Content
}

private struct CaddyCallItem {
    let shot: CaddyShotInput
    let decision: CaddyDecision
    var isLogged = false
}

private extension ConfidenceBand {
    var displayLabel: String {
        switch self {
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .mediumHigh:
            "Medium-high"
        case .high:
            "High"
        }
    }
}

#Preview {
    ThreadView()
}
