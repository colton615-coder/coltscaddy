import SwiftUI

struct ChatInputBar: View {
    let sendAction: () -> Void

    init(sendAction: @escaping () -> Void = {}) {
        self.sendAction = sendAction
    }

    var body: some View {
        HStack(spacing: DS.Spacing.md) {
            Text("Tell the caddie…")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textTertiary)
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

            Button(action: sendAction) {
                Image(systemName: "arrow.up")
                    .font(DS.Font.body)
                    .fontWeight(.regular)
                    .foregroundStyle(DS.Color.accentInk)
                    .frame(width: DS.Size.sendButton, height: DS.Size.sendButton)
                    .background(Circle().fill(DS.Color.accent))
            }
            .buttonStyle(.plain)
            .frame(width: DS.Size.tapTarget, height: DS.Size.tapTarget)
        }
    }
}

#Preview {
    ChatInputBar()
        .padding(DS.Spacing.xl)
        .background(DS.Color.bg)
}
