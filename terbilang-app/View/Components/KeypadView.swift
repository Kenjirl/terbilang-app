//
//  KeypadView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import SwiftUI

struct KeypadView: View {
    let onPress: (TerbilangViewModel.Key) -> Void

    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                digit("7"); digit("8"); digit("9")
                function(.delete, systemImage: "delete.left", label: "Hapus")
            }
            GridRow {
                digit("4"); digit("5"); digit("6")
                function(.clear, text: "C", label: "Bersihkan")
            }
            GridRow {
                digit("1"); digit("2"); digit("3")
                function(.comma, text: ",", label: "Koma")
            }
            GridRow {
                digit("000").gridCellColumns(2)
                digit("0").gridCellColumns(2)
            }
        }
    }

    private func digit(_ value: String) -> some View {
        KeyButton(kind: .digit, accessibilityLabel: value) {
            onPress(.digits(value))
        } label: {
            Text(value).font(.mono(24))
        }
    }

    private func function(_ key: TerbilangViewModel.Key, systemImage: String? = nil, text: String? = nil, label: String) -> some View {
        KeyButton(kind: .function, accessibilityLabel: label) {
            onPress(key)
        } label: {
            if let systemImage {
                Image(systemName: systemImage).font(.system(size: 20, weight: .medium))
            } else {
                Text(text ?? "").font(.mono(22))
            }
        }
    }
}

private struct KeyButton<Label: View>: View {
    enum Kind { case digit, function }

    let kind: Kind
    let accessibilityLabel: String
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    private let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)

    var body: some View {
        Button(action: action) {
            label()
                .foregroundStyle(Theme.ink)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(kind == .digit ? Theme.card : Theme.keyFunction, in: shape)
                .overlay {
                    if kind == .digit {
                        shape.strokeBorder(Theme.line, lineWidth: 1)
                    }
                }
                .contentShape(shape)
        }
        .buttonStyle(PressableStyle())
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    KeypadView { _ in }
        .padding()
        .background(Theme.paper)
}
