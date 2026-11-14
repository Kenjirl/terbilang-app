//
//  TerbilangStyle.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import SwiftUI

enum LetterCase: String, CaseIterable, Identifiable {
    case title, sentence, upper

    var id: String { rawValue }

    var label: String {
        switch self {
        case .title: "Judul"
        case .sentence: "Kalimat"
        case .upper: "KAPITAL"
        }
    }
}

struct TerbilangStyle {
    var appendRupiah = true
    var hashMarks = true
    var letterCase = LetterCase.title

    /// "dua puluh ribu" → "# Dua Puluh Ribu Rupiah #"
    func apply(to words: String) -> String {
        guard !words.isEmpty else { return "" }
        var text = appendRupiah ? words + " rupiah" : words
        switch letterCase {
        case .title:
            text = text.split(separator: " ").map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined(separator: " ")
        case .sentence:
            text = text.prefix(1).uppercased() + text.dropFirst()
        case .upper:
            text = text.uppercased()
        }
        return hashMarks ? "# \(text) #" : text
    }
}

/// Settings stored in UserDefaults, shared by every screen.
struct StyleSettings: DynamicProperty {
    @AppStorage("appendRupiah") var appendRupiah = true
    @AppStorage("hashMarks") var hashMarks = true
    @AppStorage("letterCase") var letterCase = LetterCase.title
    @AppStorage("haptics") var haptics = true

    var style: TerbilangStyle {
        TerbilangStyle(appendRupiah: appendRupiah, hashMarks: hashMarks, letterCase: letterCase)
    }
}
