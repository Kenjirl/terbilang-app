//
//  NumberFormatterHelper.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import Foundation

struct NumberFormatterHelper {

    /// Ekstrak angka bersih dari input user, normalisasi decimal ke koma
    static func extractNumberWithDecimal(_ value: String) -> String {
        var hasDecimal = false
        var result = ""

        for char in value {
            if char.isNumber {
                result.append(char)
            } else if (char == "." || char == ",") && !hasDecimal {
                result.append(",")  // normalisasi ke koma
                hasDecimal = true
            }
        }
        return result
    }

    /// Format angka mentah ke format ribuan (contoh: 1000000 → 1.000.000)
    static func formatThousands(_ value: String) -> String {
        guard !value.isEmpty else { return "" }

        let parts = value.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
        let integerPart = parts[0]

        var result = ""
        let count = integerPart.count

        for (index, digit) in integerPart.enumerated() {
            let remainingDigits = count - index - 1
            result.append(digit)
            if remainingDigits > 0 && remainingDigits % 3 == 0 {
                result.append(".")
            }
        }

        // Tambahkan koma + desimal, termasuk kalau desimal masih kosong
        if parts.count > 1 {
            result += "," + parts[1]
        }

        return result
    }
}
