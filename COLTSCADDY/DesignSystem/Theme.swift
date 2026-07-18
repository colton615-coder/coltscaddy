import SwiftUI

enum DS {
    static let preferredColorScheme: SwiftUI.ColorScheme = .light

    enum Color {
        static let bg = SwiftUI.Color(hex: 0xF7F3E8)
        static let surface = SwiftUI.Color(hex: 0xECE6D9)
        static let surfaceBubbleThem = SwiftUI.Color(hex: 0xECE6D9)
        static let surfaceBubbleMe = SwiftUI.Color(hex: 0x285C3D)
        static let hairline = SwiftUI.Color(hex: 0xD1C7B8)
        static let textPrimary = SwiftUI.Color(hex: 0x202720)
        static let callDetail = SwiftUI.Color(hex: 0x303A32)
        static let textSecondary = SwiftUI.Color(hex: 0x4E5B51)
        static let textTertiary = SwiftUI.Color(hex: 0x5D675F)
        static let accent = SwiftUI.Color(hex: 0x285C3D)
        static let accentInk = SwiftUI.Color(hex: 0xFFF9EE)
        static let eyebrow = SwiftUI.Color(hex: 0xA33A32)
        static let alternate = SwiftUI.Color(hex: 0x6B4A08)
        static let alternateFill = SwiftUI.Color(hex: 0xF3E1A9)
    }

    enum Font {
        static let playCall = SwiftUI.Font.system(.title, design: .rounded, weight: .semibold)
        static let screenTitle = SwiftUI.Font.system(size: Size.screenTitle, weight: .semibold, design: .rounded)
        static let playDistance = SwiftUI.Font.system(.title2, design: .rounded, weight: .semibold)
        static let playTarget = SwiftUI.Font.system(.title2, design: .rounded, weight: .semibold)
        static let fieldLabel = SwiftUI.Font.system(.caption, design: .rounded, weight: .bold)
        static let fieldValue = SwiftUI.Font.system(.body, design: .rounded, weight: .medium)
        static let sectionLabel = SwiftUI.Font.system(size: Size.sectionLabel, weight: .bold, design: .rounded)
        static let commitCue = SwiftUI.Font.system(size: Size.commitCue, weight: .semibold, design: .rounded)
        static let button = SwiftUI.Font.system(size: Size.button, weight: .semibold, design: .rounded)
        static let caddieSpeak = SwiftUI.Font.system(size: Size.caddieSpeak, weight: .regular, design: .rounded)
        static let body = SwiftUI.Font.system(size: Size.body, weight: .regular, design: .rounded)
        static let label = SwiftUI.Font.system(size: Size.label, weight: .medium, design: .rounded)
        static let caption = SwiftUI.Font.system(size: Size.caption, weight: .semibold, design: .rounded)
        static let badge = SwiftUI.Font.system(size: Size.badge, weight: .medium, design: .rounded)
        static let captionTracking = Size.caption * 0.12

        private enum Size {
            static let screenTitle: CGFloat = 26
            static let sectionLabel: CGFloat = 15
            static let commitCue: CGFloat = 15
            static let button: CGFloat = 17
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
}
