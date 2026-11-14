//
//  SettingsView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(HistoryStore.self) private var history
    @State private var confirmClear = false
    private var settings = StyleSettings()

    private var preview: String {
        settings.style.apply(to: TerbilangHelper.words(for: 1_250_000))
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Pengaturan")
                    .font(.serif(30, .semibold))
                    .foregroundStyle(Theme.ink)

                VStack(alignment: .leading, spacing: 6) {
                    SectionLabel("Pratinjau · Rp 1.250.000")
                    Text(preview)
                        .font(.serif(18))
                        .italic()
                        .foregroundStyle(Theme.ink)
                        .animation(.snappy(duration: 0.2), value: preview)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                }

                SectionLabel("Format hasil").padding(.top, 6)
                group {
                    toggleRow("Akhiran “Rupiah”", hint: "Tambahkan kata rupiah di akhir", isOn: settings.$appendRupiah)
                    divider
                    toggleRow("Tanda pagar # … #", hint: "Seperti penulisan di kuitansi", isOn: settings.$hashMarks)
                    divider
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Gaya huruf")
                            .font(.body.weight(.medium))
                            .foregroundStyle(Theme.ink)
                        Picker("Gaya huruf", selection: settings.$letterCase) {
                            ForEach(LetterCase.allCases) { Text($0.label).tag($0) }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 14)
                }

                SectionLabel("Lainnya").padding(.top, 6)
                group {
                    toggleRow("Getar", hint: "Saat menekan tombol dan menyalin", isOn: settings.$haptics)
                    divider
                    Button("Hapus Riwayat", role: .destructive) { confirmClear = true }
                        .foregroundStyle(Theme.danger)
                        .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                        .disabled(history.entries.isEmpty)
                }

                Text("Terbilang \(appVersion)")
                    .font(.mono(11))
                    .foregroundStyle(Theme.muted)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Theme.paper)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Hapus semua riwayat?", isPresented: $confirmClear, titleVisibility: .visible) {
            Button("Hapus Semua", role: .destructive) { history.clear() }
        }
    }

    private var divider: some View {
        Rectangle().fill(Theme.line).frame(height: 1)
    }

    private func group<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0, content: content)
            .padding(.horizontal, 14)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Theme.line, lineWidth: 1)
            }
    }

    private func toggleRow(_ title: String, hint: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Theme.ink)
                Text(hint)
                    .font(.footnote)
                    .foregroundStyle(Theme.muted)
            }
        }
        .tint(Theme.accent)
        .frame(minHeight: 60)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(HistoryStore())
}
