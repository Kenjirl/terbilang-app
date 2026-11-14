//
//  TerbilangHelper.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import Foundation

/// Converts numbers to Indonesian words ("terbilang"), in lowercase.
/// Casing, "rupiah" and "# … #" are applied later by `TerbilangStyle`.
enum TerbilangHelper {
    /// Up to 999.999.999.999.999 (999 triliun).
    static let maxIntegerDigits = 15
    static let maxDecimalDigits = 4

    private static let angka = ["", "satu", "dua", "tiga", "empat", "lima",
                                "enam", "tujuh", "delapan", "sembilan",
                                "sepuluh", "sebelas"]

    /// Digit names used after "koma", where 0 is read as "nol".
    private static let digitNames = ["nol", "satu", "dua", "tiga", "empat",
                                     "lima", "enam", "tujuh", "delapan", "sembilan"]

    static func words(for n: Int) -> String {
        n == 0 ? "nol" : terbilang(n)
    }

    /// `raw` uses a comma for decimals and no thousand separators, e.g. "1250000,75".
    static func words(forRaw raw: String) -> String {
        let parts = raw.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
        guard let integer = Int(parts[0].isEmpty ? "0" : parts[0]) else { return "" }

        var result = words(for: integer)
        if parts.count > 1, !parts[1].isEmpty {
            let decimals = parts[1].compactMap { $0.wholeNumberValue.map { digitNames[$0] } }
            result += " koma " + decimals.joined(separator: " ")
        }
        return result
    }

    private static func terbilang(_ n: Int) -> String {
        guard n > 0 else { return "" }
        func join(_ parts: String...) -> String {
            parts.filter { !$0.isEmpty }.joined(separator: " ")
        }
        switch n {
        case ..<12:                return angka[n]
        case ..<20:                return join(terbilang(n - 10), "belas")
        case ..<100:               return join(terbilang(n / 10), "puluh", terbilang(n % 10))
        case ..<200:               return join("seratus", terbilang(n - 100))
        case ..<1_000:             return join(terbilang(n / 100), "ratus", terbilang(n % 100))
        case ..<2_000:             return join("seribu", terbilang(n - 1_000))
        case ..<1_000_000:         return join(terbilang(n / 1_000), "ribu", terbilang(n % 1_000))
        case ..<1_000_000_000:     return join(terbilang(n / 1_000_000), "juta", terbilang(n % 1_000_000))
        case ..<1_000_000_000_000: return join(terbilang(n / 1_000_000_000), "miliar", terbilang(n % 1_000_000_000))
        default:                   return join(terbilang(n / 1_000_000_000_000), "triliun", terbilang(n % 1_000_000_000_000))
        }
    }
}
