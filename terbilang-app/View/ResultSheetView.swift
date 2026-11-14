//
//  ResultSheetView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import SwiftUI

/// Full result as a receipt, with letter case options, copy and share.
struct ResultSheetView: View {
    let amount: String
    let words: String
    let onCopy: () -> Void

    @Environment(\.dismiss) private var dismiss
    private var settings = StyleSettings()

    init(amount: String, words: String, onCopy: @escaping () -> Void) {
        self.amount = amount
        self.words = words
        self.onCopy = onCopy
    }

    private var text: String { settings.style.apply(to: words) }

    private var wordCount: Int {
        text.split(whereSeparator: \.isWhitespace).filter { $0 != "#" }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    receipt

                    VStack(alignment: .leading, spacing: 10) {
                        SectionLabel("Gaya huruf")
                        Picker("Gaya huruf", selection: settings.$letterCase) {
                            ForEach(LetterCase.allCases) { Text($0.label).tag($0) }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(16)
            }
            .background(Theme.paper)
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 8) {
                    CopyButton(text: text, title: "Salin teks", height: 52, onCopy: onCopy)
                    ShareLink(item: text) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.ink)
                            .frame(width: 52, height: 52)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(Theme.dashed, lineWidth: 1)
                            }
                    }
                    .accessibilityLabel("Bagikan")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Theme.paper)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Tutup") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Hasil Terbilang")
                        .font(.serif(18, .semibold))
                        .foregroundStyle(Theme.ink)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    private var receipt: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                SectionLabel("Jumlah")
                Spacer()
                Text("Rp \(amount)")
                    .font(.mono(22, .semibold))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            DashedRule()
            SectionLabel("Terbilang")
            Text(text)
                .font(.serif(27))
                .italic()
                .lineSpacing(4)
                .foregroundStyle(Theme.ink)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
                .animation(.snappy(duration: 0.2), value: text)
            Text("\(wordCount) kata · \(text.count) karakter")
                .font(.mono(11))
                .foregroundStyle(Theme.muted)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.top, 22)
        .padding(.bottom, 20)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 8)
    }
}

#Preview {
    ResultSheetView(amount: "27.500.000", words: "dua puluh tujuh juta lima ratus ribu") {}
}
