//
//  HistoryStore.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import Foundation
import Observation

struct HistoryEntry: Codable, Identifiable, Hashable {
    var id = UUID()
    let raw: String
    let date: Date
}

@Observable
final class HistoryStore {
    private(set) var entries: [HistoryEntry] = []

    private let defaults: UserDefaults
    private let key = "history.v1"
    private let limit = 50

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: key),
           let saved = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            entries = saved
        }
    }

    /// Adds a number to the top; the same number is moved up instead of repeated.
    func record(_ raw: String) {
        guard !raw.isEmpty else { return }
        entries.removeAll { $0.raw == raw }
        entries.insert(HistoryEntry(raw: raw, date: .now), at: 0)
        if entries.count > limit {
            entries.removeLast(entries.count - limit)
        }
        save()
    }

    func delete(_ entry: HistoryEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func clear() {
        entries.removeAll()
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            defaults.set(data, forKey: key)
        }
    }
}
