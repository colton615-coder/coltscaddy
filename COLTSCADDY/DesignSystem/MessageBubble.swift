import SwiftUI

struct MessageBubble: View {
    enum Sender {
        case them
        case me
    }

    let text: String
    let sender: Sender

    var body: some View {
        HStack {
            if sender == .me {
                Spacer(minLength: DS.Spacing.xxxl)
            }

            Text(text)
                .font(font)
                .foregroundStyle(DS.Color.textPrimary)
                .multilineTextAlignment(sender == .them ? .leading : .trailing)
                .padding(.horizontal, DS.Spacing.lg)
                .padding(.vertical, DS.Spacing.md)
                .background(backgroundShape.fill(backgroundColor))
                .frame(alignment: alignment)

            if sender == .them {
                Spacer(minLength: DS.Spacing.xxxl)
            }
        }
        .frame(minHeight: DS.Size.tapTarget)
    }

    private var font: Font {
        switch sender {
        case .them:
            DS.Font.caddieSpeak
        case .me:
            DS.Font.body
        }
    }

    private var backgroundColor: Color {
        switch sender {
        case .them:
            DS.Color.surfaceBubbleThem
        case .me:
            DS.Color.surfaceBubbleMe
        }
    }

    private var alignment: Alignment {
        switch sender {
        case .them:
            .leading
        case .me:
            .trailing
        }
    }

    private var backgroundShape: UnevenRoundedRectangle {
        switch sender {
        case .them:
            UnevenRoundedRectangle(
                topLeadingRadius: DS.Radius.bubble,
                bottomLeadingRadius: DS.Radius.bubbleTailCorner,
                bottomTrailingRadius: DS.Radius.bubble,
                topTrailingRadius: DS.Radius.bubble
            )
        case .me:
            UnevenRoundedRectangle(
                topLeadingRadius: DS.Radius.bubble,
                bottomLeadingRadius: DS.Radius.bubble,
                bottomTrailingRadius: DS.Radius.bubbleTailCorner,
                topTrailingRadius: DS.Radius.bubble
            )
        }
    }
}

#Preview {
    VStack(spacing: DS.Spacing.xl) {
        MessageBubble(text: "Tell me the number, the lie, and the safest miss.", sender: .them)
        MessageBubble(text: "165 yards from the fairway with bunker long right.", sender: .me)
    }
    .padding(DS.Spacing.xl)
    .background(DS.Color.bg)
}
