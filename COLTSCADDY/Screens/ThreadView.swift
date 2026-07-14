import SwiftUI

struct ThreadView: View {
    @State private var messages: [ThreadMessage] = [
        ThreadMessage(
            text: "Good to see you, Colt. Tell me what you're facing and I'll give you the smart play.",
            sender: .them
        )
    ]
    @State private var isShotInputPresented = false

    var body: some View {
        VStack(spacing: DS.Spacing.lg) {
            conversationFeed
            inputRow
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.md)
        .background(DS.Color.bg.ignoresSafeArea())
        .sheet(isPresented: $isShotInputPresented) {
            ShotInputTray { summary in
                addShotSummary(summary)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private var conversationFeed: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: DS.Spacing.xl) {
                    ForEach(messages) { message in
                        MessageBubble(text: message.text, sender: message.sender)
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

            ChatInputBar()
        }
    }

    private func addShotSummary(_ summary: String) {
        messages.append(ThreadMessage(text: summary, sender: .me))
        messages.append(ThreadMessage(text: "Got it — I can see the shot clearly. I'll have your read the moment my decision engine is wired up.", sender: .them))
    }

    private func scrollToLatest(using proxy: ScrollViewProxy) {
        guard let latestID = messages.last?.id else { return }

        withAnimation {
            proxy.scrollTo(latestID, anchor: .bottom)
        }
    }
}

private struct ThreadMessage: Identifiable {
    let id = UUID()
    let text: String
    let sender: MessageBubble.Sender
}

#Preview {
    ThreadView()
}
