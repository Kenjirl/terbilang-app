//
//  HistoryView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import SwiftUI

struct HistoryView: View {
    /// Called with the raw number when an entry is tapped.
    let onSelect: (String) -> Void

    @Environment(HistoryStore.self) private var history
    @State private var confirmClear = false
    private var settings = StyleSettings()

    init(onSelect: @escaping (String) -> Void) {
        self.onSelect = onSelect
    }

    private var sections: [(day: Date, entries: [HistoryEntry])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: history.entries) { calendar.startOfDay(for: $0.date) }
        return grouped.keys.sorted(by: >).map { ($0, grouped[$0] ?? []) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Riwayat")
                    .font(.serif(30, .semibold))
                    .foregroundStyle(Theme.ink)

                if history.entries.isEmpty {
                    ContentUnavailableView(
                        "Belum ada riwayat",
                        systemImage: "clock",
                        description: Text("Angka yang kamu salin atau bagikan akan muncul di sini.")
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(sections, id: \.day) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(label(for: section.day))
                                .padding(.top, 6)
                            VStack(spacing: 0) {
                                ForEach(Array(section.entries.enumerated()), id: \.element.id) { index, entry in
                                    if index > 0 {
                                        Rectangle().fill(Theme.line).frame(height: 1)
                                    }
                                    row(entry)
                                }
                            }
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(Theme.line, lineWidth: 1)
                            }
                        }
                    }

                    Text("Ketuk untuk memakai lagi · tekan lama untuk menghapus")
                        .font(.caption)
                        .foregroundStyle(Theme.muted)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Theme.paper)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !history.entries.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Hapus Semua", role: .destructive) { confirmClear = true }
                        .tint(Theme.danger)
                }
            }
        }
        .confirmationDialog("Hapus semua riwayat?", isPresented: $confirmClear, titleVisibility: .visible) {
            Button("Hapus Semua", role: .destructive) {
                withAnimation { history.clear() }
            }
        }
    }

    private func row(_ entry: HistoryEntry) -> some View {
        Button {
            onSelect(entry.raw)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Rp \(NumberFormatterHelper.formatThousands(entry.raw))")
                        .font(.mono(17, .semibold))
                        .foregroundStyle(Theme.ink)
                    Spacer()
                    Text(entry.date.formatted(.dateTime.hour().minute().locale(Locale(identifier: "id_ID"))))
                        .font(.caption)
                        .foregroundStyle(Theme.muted)
                }
                Text(settings.style.apply(to: TerbilangHelper.words(forRaw: entry.raw)))
                    .font(.serif(15))
                    .italic()
                    .foregroundStyle(Theme.ink.opacity(0.75))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("Hapus", systemImage: "trash", role: .destructive) {
                withAnimation { history.delete(entry) }
            }
        }
    }

    private func label(for day: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) { return "Hari ini" }
        if calendar.isDateInYesterday(day) { return "Kemarin" }
        return day.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "id_ID")))
    }
}

#Preview {
    NavigationStack {
        HistoryView { _ in }
    }
    .environment(HistoryStore())
}
