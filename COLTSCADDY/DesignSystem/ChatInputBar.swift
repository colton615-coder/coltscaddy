import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    let isEnabled: Bool
    let sendAction: () -> Void

    init(
        text: Binding<String>,
        isEnabled: Bool = true,
        sendAction: @escaping () -> Void
    ) {
        self._text = text
        self.isEnabled = isEnabled
        self.sendAction = sendAction
    }

    var body: some View {
        HStack(spacing: DS.Spacing.md) {
            TextField(
                text: $text,
                prompt: Text("Tell the caddie…")
                    .foregroundStyle(DS.Color.textTertiary)
            ) {
                EmptyView()
            }
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textPrimary)
                .tint(DS.Color.accent)
                .submitLabel(.next)
                .onSubmit(submitIfPossible)
                .disabled(!isEnabled)
                .accessibilityIdentifier("nuanceTextField")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, DS.Spacing.lg)
                .frame(minHeight: DS.Size.tapTarget)
                .background(
                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                        .fill(DS.Color.surface)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.button, style: .continuous)
                        .stroke(DS.Color.hairline)
                )

            Button(action: submitIfPossible) {
                Image(systemName: "arrow.up")
                    .font(DS.Font.body)
                    .fontWeight(.regular)
                    .foregroundStyle(DS.Color.accentInk)
                    .frame(width: DS.Size.sendButton, height: DS.Size.sendButton)
                    .background(Circle().fill(DS.Color.accent))
            }
            .buttonStyle(.plain)
            .disabled(!canSend)
            .opacity(canSend ? 1 : 0.35)
            .accessibilityLabel("Attach nuance to the next shot.")
            .accessibilityIdentifier("nuanceSendButton")
            .frame(width: DS.Size.tapTarget, height: DS.Size.tapTarget)
        }
    }

    private var canSend: Bool {
        isEnabled && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func submitIfPossible() {
        guard canSend else { return }
        sendAction()
    }
}

#Preview {
    ChatInputBar(text: .constant(""), isEnabled: true) {}
        .padding(DS.Spacing.xl)
        .background(DS.Color.bg)
}
