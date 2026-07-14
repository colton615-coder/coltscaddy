import SwiftUI

enum DS {
    enum Color {
        static let bg = SwiftUI.Color(hex: 0x0B0B0C)
        static let surface = SwiftUI.Color(hex: 0x161618)
        static let surfaceBubbleThem = SwiftUI.Color(hex: 0x1C1D20)
        static let surfaceBubbleMe = SwiftUI.Color(hex: 0x26333A)
        static let hairline = SwiftUI.Color.rgba(red: 255, green: 255, blue: 255, alpha: 0.08)
        static let textPrimary = SwiftUI.Color(hex: 0xF4F3F1)
        static let textSecondary = SwiftUI.Color.rgba(red: 244, green: 243, blue: 241, alpha: 0.55)
        static let textTertiary = SwiftUI.Color.rgba(red: 244, green: 243, blue: 241, alpha: 0.35)
        static let accent = SwiftUI.Color(hex: 0xC9A96A)
        static let accentInk = SwiftUI.Color(hex: 0x1A1509)
    }

    enum Font {
        static let caddieSpeak = SwiftUI.Font.system(size: Size.caddieSpeak, weight: .regular, design: .serif)
        static let playCall = SwiftUI.Font.system(size: Size.playCall, weight: .semibold, design: .serif)
        static let body = SwiftUI.Font.system(size: Size.body, weight: .regular, design: .default)
        static let label = SwiftUI.Font.system(size: Size.label, weight: .medium, design: .default)
        static let caption = SwiftUI.Font.system(size: Size.caption, weight: .semibold, design: .default)
        static let captionTracking = Size.caption * 0.08

        private enum Size {
            static let caddieSpeak: CGFloat = 22
            static let playCall: CGFloat = 19
            static let body: CGFloat = 16
            static let label: CGFloat = 13
            static let caption: CGFloat = 11
        }
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 28
        static let xxxl: CGFloat = 40
    }

    enum Radius {
        static let bubble: CGFloat = 18
        static let card: CGFloat = 16
        static let button: CGFloat = 14
        static let bubbleTailCorner: CGFloat = 5
    }

    enum Size {
        static let tapTarget: CGFloat = 44
        static let bubbleMaxWidthFraction: CGFloat = 0.8
        static let sendButton: CGFloat = 44
        static let swatch: CGFloat = 44
    }
}

private extension SwiftUI.Color {
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }

    static func rgba(red: Double, green: Double, blue: Double, alpha: Double) -> SwiftUI.Color {
        SwiftUI.Color(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, opacity: alpha)
    }
}
