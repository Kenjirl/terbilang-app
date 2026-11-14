//
//  ReceiptComponents.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import SwiftUI
import UIKit

/// Small monospaced caps label, like the printed labels on a receipt.
struct SectionLabel: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text.uppercased())
            .font(.mono(11, .semibold))
            .tracking(1.5)
            .foregroundStyle(Theme.muted)
    }
}

/// Round paper button used in headers.
struct CircleIcon: View {
    let systemName: String

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Theme.ink)
            .frame(width: 44, height: 44)
            .background(Theme.card, in: Circle())
            .overlay { Circle().strokeBorder(Theme.line, lineWidth: 1) }
    }
}

/// Horizontal dashed rule.
struct DashedRule: View {
    var body: some View {
        Line()
            .stroke(Theme.dashed, style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
            .frame(height: 1.5)
    }

    private struct Line: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            }
        }
    }
}

/// Primary "Salin" button that copies text and briefly shows "Tersalin".
struct CopyButton: View {
    let text: String
    var title = "Salin"
    var height: CGFloat = 44
    let onCopy: () -> Void

    @State private var copied = false

    var body: some View {
        Button {
            UIPasteboard.general.string = text
            onCopy()
            withAnimation(.snappy) { copied = true }
            Task {
                try? await Task.sleep(for: .seconds(1.6))
                withAnimation(.snappy) { copied = false }
            }
        } label: {
            Label(copied ? "Tersalin" : title, systemImage: copied ? "checkmark" : "doc.on.doc")
                .font(.system(size: 15, weight: .semibold))
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(Theme.onAccent)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(PressableStyle())
        .accessibilityLabel(copied ? "Tersalin" : "Salin teks terbilang")
    }
}

/// Secondary outlined button style used for "Bagikan".
struct OutlineLabel: View {
    let title: String
    let systemImage: String
    var height: CGFloat = 44

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 16)
            .frame(height: height)
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Theme.dashed, lineWidth: 1)
            }
    }
}

/// Slight shrink while pressed.
struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}
