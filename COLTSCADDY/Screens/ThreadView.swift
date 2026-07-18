import SwiftUI
import SwiftData

struct ThreadView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [PlayerProfile]
    @State private var messages: [ThreadMessage]
    @State private var isShotInputPresented = false
    @State private var isBagEditorPresented = false
    @State private var outcomePicker: OutcomePickerRequest?
    @State private var nuanceText = ""
    @State private var scrollRequestCount = 0

    init() {
        _messages = State(initialValue: Self.initialMessages)
    }

    private static var initialMessages: [ThreadMessage] {
#if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-UITestCompactCaddyCall") {
            let shot = CaddyShotInput(
                shotType: .tee,
                lie: .tee,
                trouble: [.ob],
                distanceYards: 450
            )
            let bag = ProfileSeeder.defaultBag.map {
                CaddyBagClub(name: $0.name, carryYards: $0.carryYards)
            }
            let decision = CaddyEngine.recommend(for: shot, bag: bag)

            return [
                ThreadMessage(
                    content: .text(
                        "450 yards, tee shot, trouble marked: ob.",
                        sender: .me
                    )
                ),
                ThreadMessage(content: .caddyCall(CaddyCallItem(shot: shot, decision: decision)))
            ]
        }

        if ProcessInfo.processInfo.arguments.contains("-UITestLongThread") {
            return (1...8).map { index in
                ThreadMessage(
                    content: .text(
                        "Long thread message \(index) confirms that every bubble remains fully visible while the conversation scrolls.",
                        sender: index.isMultiple(of: 2) ? .them : .me
                    )
                )
            }
        }
#endif

        return [
            ThreadMessage(
                content: .text(
                    "Good to see you, Colt. Tell me what you're facing and I'll give you the smart play.",
                    sender: .them
                )
            )
        ]
    }

    var body: some View {
        VStack(spacing: DS.Spacing.lg) {
            conversationFeed
            inputRow
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.md)
        .background(DS.Color.bg.ignoresSafeArea())
        .safeAreaInset(edge: .top, alignment: .trailing, spacing: 0) {
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
        .sheet(item: $outcomePicker) { request in
            OutcomePickerSheet(
                club: request.club,
                distanceText: request.distanceText
            ) { outcome in
                logResult(for: request.messageID, outcome: outcome)
            }
            .presentationDetents([.height(344)])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(28)
            .presentationBackground(DS.Color.surface)
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
        .accessibilityIdentifier("bagButton")
    }

    private var conversationFeed: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: DS.Spacing.xl) {
                    ForEach(messages) { message in
                        threadItem(for: message)
                            .id(message.id)
                            .accessibilityElement(children: .contain)
                            .accessibilityIdentifier(
                                message.id == messages.first?.id
                                    ? "topmostThreadMessage"
                                    : "threadMessage"
                            )
                    }
                }
                .padding(.top, DS.Spacing.xxl)
                .padding(.bottom, DS.Spacing.lg)
            }
            .scrollIndicators(.hidden)
            .clipped()
            .accessibilityIdentifier("conversationFeed")
            .onAppear {
                scrollToLatest(using: proxy)
            }
            .onChange(of: messages.count) {
                scrollToLatest(using: proxy)
            }
            .onChange(of: scrollRequestCount) {
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(250))
                    scrollToLatest(using: proxy)
                }
            }
        }
    }

    private var inputRow: some View {
        HStack(spacing: DS.Spacing.md) {
            Button {
                isShotInputPresented = true
            } label: {
                Text("+")
                    .font(DS.Font.screenTitle)
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

            ChatInputBar(
                text: $nuanceText,
                isEnabled: true
            ) {
                isShotInputPresented = true
            }
        }
    }

    private func addShot(_ submission: ShotSubmission) {
        let submission = submission.attachingNuance(nuanceText)
        nuanceText = ""

        messages.append(ThreadMessage(content: .text(submission.summary, sender: .me)))

        let decision = CaddyEngine.recommend(for: submission.input, bag: currentBag)
        messages.append(
            ThreadMessage(
                content: .caddyCall(
                    CaddyCallItem(shot: submission.input, decision: decision)
                )
            )
        )
    }

    @ViewBuilder
    private func threadItem(for message: ThreadMessage) -> some View {
        switch message.content {
        case let .text(text, sender):
            MessageBubble(text: text, sender: sender)
        case let .caddyCall(call):
            CaddyCallCard(
                club: call.decision.club,
                distanceText: call.decision.distanceText,
                target: call.decision.target,
                safeMiss: call.decision.safeMiss,
                why: call.decision.why,
                alternate: .init(
                    type: call.decision.alternate.type,
                    text: call.decision.alternate.text
                ),
                executionTip: CaddyEngine.executionTip(for: call.shot.shotType),
                isLogResultEnabled: !call.isLogged,
                expansionAction: { isExpanded in
                    guard isExpanded, message.id == messages.last?.id else { return }
                    scrollRequestCount += 1
                },
                logAction: {
                    presentOutcomePicker(for: message.id)
                }
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func presentOutcomePicker(for messageID: UUID) {
        guard let message = messages.first(where: { $0.id == messageID }),
              case let .caddyCall(call) = message.content,
              !call.isLogged else {
            return
        }

        outcomePicker = OutcomePickerRequest(
            messageID: messageID,
            club: call.decision.club,
            distanceText: call.decision.distanceText
        )
    }

    private func logResult(for messageID: UUID, outcome: Outcome) {
        guard let index = messages.firstIndex(where: { $0.id == messageID }),
              case var .caddyCall(call) = messages[index].content,
              !call.isLogged else {
            return
        }

        do {
            try ShotHistoryStore.log(
                shot: call.shot,
                decision: call.decision,
                outcome: outcome,
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

private struct OutcomePickerRequest: Identifiable {
    let messageID: UUID
    let club: String
    let distanceText: String

    var id: UUID { messageID }
}

#Preview {
    ThreadView()
}
