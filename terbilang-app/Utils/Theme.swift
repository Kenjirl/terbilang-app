//
//  Theme.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import SwiftUI
import UIKit

enum Theme {
    static let paper       = Color(light: 0xF4EFE6, dark: 0x1B1A17)
    static let card        = Color(light: 0xFFFDF8, dark: 0x25231F)
    static let keyFunction = Color(light: 0xE9E2D6, dark: 0x343029)
    static let ink         = Color(light: 0x23221F, dark: 0xEDE7DC)
    static let muted       = Color(light: 0x6C665C, dark: 0xA39B8E)
    static let line        = Color(light: 0xE2D9CB, dark: 0x3A362F)
    static let dashed      = Color(light: 0xD6CBB9, dark: 0x4A453C)
    static let accent      = Color(light: 0x284B8F, dark: 0x8FA8E6)
    static let onAccent    = Color(light: 0xFFFFFF, dark: 0x111A2E)
    static let danger      = Color(light: 0x9A3B2E, dark: 0xE58C7E)
}

extension Font {
    /// Monospaced digits for amounts and labels.
    static func mono(_ size: CGFloat, _ weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }

    /// Serif (New York) for titles and the written-out words.
    static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}

extension Color {
    init(light: UInt32, dark: UInt32) {
        self.init(UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
