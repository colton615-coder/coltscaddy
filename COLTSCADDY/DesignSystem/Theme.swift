import SwiftUI

enum DS {
    enum Color {
        static let bg = SwiftUI.Color(hex: 0x08090A)
        static let surface = SwiftUI.Color(hex: 0x121417)
        static let surfaceBubbleThem = SwiftUI.Color(hex: 0x141719)
        static let surfaceBubbleMe = SwiftUI.Color(hex: 0x1D2A31)
        static let hairline = SwiftUI.Color.rgba(red: 255, green: 255, blue: 255, alpha: 0.10)
        static let textPrimary = SwiftUI.Color(hex: 0xF5F7F8)
        static let textSecondary = SwiftUI.Color(hex: 0x8A949B)
        static let textTertiary = SwiftUI.Color(hex: 0x5C666D)
        static let accent = SwiftUI.Color(hex: 0x4CC9F0)
        static let accentInk = SwiftUI.Color(hex: 0x04222B)
        static let confidence = SwiftUI.Color(hex: 0x3DDC97)
        static let confidenceFill = SwiftUI.Color.rgba(red: 61, green: 220, blue: 151, alpha: 0.12)
        static let alternate = SwiftUI.Color(hex: 0xF5B841)
    }

    enum Font {
        static let playCall = SwiftUI.Font.system(size: Size.playCall, weight: .semibold, design: .rounded)
        static let playDistance = SwiftUI.Font.system(size: Size.playDistance, weight: .semibold, design: .rounded)
        static let fieldLabel = SwiftUI.Font.system(size: Size.fieldLabel, weight: .semibold, design: .rounded)
        static let fieldValue = SwiftUI.Font.system(size: Size.fieldValue, weight: .regular, design: .rounded)
        static let caddieSpeak = SwiftUI.Font.system(size: Size.caddieSpeak, weight: .regular, design: .rounded)
        static let body = SwiftUI.Font.system(size: Size.body, weight: .regular, design: .rounded)
        static let label = SwiftUI.Font.system(size: Size.label, weight: .medium, design: .rounded)
        static let caption = SwiftUI.Font.system(size: Size.caption, weight: .semibold, design: .rounded)
        static let badge = SwiftUI.Font.system(size: Size.badge, weight: .medium, design: .rounded)
        static let captionTracking = Size.caption * 0.12

        private enum Size {
            static let playCall: CGFloat = 44
            static let playDistance: CGFloat = 26
            static let fieldLabel: CGFloat = 19
            static let fieldValue: CGFloat = 15
            static let caddieSpeak: CGFloat = 16
            static let body: CGFloat = 15
            static let label: CGFloat = 14
            static let caption: CGFloat = 12
            static let badge: CGFloat = 11
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
