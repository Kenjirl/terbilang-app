//
//  NumberFormatterHelper.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import Foundation

enum NumberFormatterHelper {

    /// Formats a raw number with Indonesian separators: "1250000,75" → "1.250.000,75".
    static func formatThousands(_ value: String) -> String {
        guard !value.isEmpty else { return "" }

        let parts = value.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
        let integerPart = parts[0].isEmpty ? "0" : parts[0]

        var result = ""
        for (index, digit) in integerPart.enumerated() {
            let remaining = integerPart.count - index - 1
            result.append(digit)
            if remaining > 0 && remaining % 3 == 0 {
                result.append(".")
            }
        }

        // Keep the comma even while the decimals are still empty.
        if parts.count > 1 {
            result += "," + parts[1]
        }
        return result
    }

    /// Reads pasted text written the Indonesian way ("Rp 1.250.000,75")
    /// into a raw number ("1250000,75"). Dots are thousand separators; the first comma is decimal.
    static func rawNumber(fromPasted text: String) -> String {
        var result = ""
        var hasComma = false
        for char in text {
            if char.isNumber, let digit = char.wholeNumberValue {
                result.append(String(digit))
            } else if char == "," && !hasComma {
                result.append(",")
                hasComma = true
            }
        }
        return result
    }
}
