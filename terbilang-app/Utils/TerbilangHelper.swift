//
//  TerbilangHelper.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import Foundation

struct TerbilangHelper {
    static let maxLimit = 999_999_999_999_999

    private static let angka = ["", "satu", "dua", "tiga", "empat", "lima",
                                 "enam", "tujuh", "delapan", "sembilan",
                                 "sepuluh", "sebelas"]

    static func convert(_ n: Int) -> String {
        if n == 0 { return "Nol" }
        guard n <= maxLimit else { return "Over Limit" }
        return terbilang(n).capitalized.trimmingCharacters(in: .whitespaces)
    }

    private static func terbilang(_ n: Int) -> String {
        guard n > 0 else { return "" }
        if n < 12       { return angka[n] }
        if n < 20       { return terbilang(n - 10) + " belas" }
        if n < 100      { return (terbilang(n / 10) + " puluh " + terbilang(n % 10)).trimmingCharacters(in: .whitespaces) }
        if n < 200      { return ("seratus " + terbilang(n - 100)).trimmingCharacters(in: .whitespaces) }
        if n < 1_000    { return (terbilang(n / 100) + " ratus " + terbilang(n % 100)).trimmingCharacters(in: .whitespaces) }
        if n < 2_000    { return ("seribu " + terbilang(n - 1000)).trimmingCharacters(in: .whitespaces) }
        if n < 1_000_000          { return (terbilang(n / 1_000) + " ribu " + terbilang(n % 1_000)).trimmingCharacters(in: .whitespaces) }
        if n < 1_000_000_000      { return (terbilang(n / 1_000_000) + " juta " + terbilang(n % 1_000_000)).trimmingCharacters(in: .whitespaces) }
        if n < 1_000_000_000_000  { return (terbilang(n / 1_000_000_000) + " milyar " + terbilang(n % 1_000_000_000)).trimmingCharacters(in: .whitespaces) }
        return (terbilang(n / 1_000_000_000_000) + " triliun " + terbilang(n % 1_000_000_000_000)).trimmingCharacters(in: .whitespaces)
    }

    static func convertWithDecimal(_ value: String) -> String {
        let parts = value.split(separator: ",", maxSplits: 1).map(String.init)
        guard !parts[0].isEmpty, let integerPart = Int(parts[0]) else { return "" }
        guard integerPart <= maxLimit else { return "Over Limit" }

        var result = convert(integerPart)

        if parts.count > 1 && !parts[1].isEmpty {
            let decimalText = parts[1].compactMap {
                Int(String($0)).map { angka[$0].capitalized }
            }.joined(separator: " ")
            result += " Koma " + decimalText  // ← "Koma" kapital
        }

        return result
    }
}
