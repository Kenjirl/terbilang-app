//
//  TerbilangViewModel.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import Foundation
import Observation

@Observable
final class TerbilangViewModel {
    enum Key: Hashable {
        case digits(String)   // "0"…"9" or "000"
        case comma
        case delete
        case clear
    }

    /// Clean number without thousand separators, decimal comma, e.g. "1250000,75".
    var raw = ""
    /// True right after an input was refused because it is too long.
    private(set) var limitReached = false

    init(raw: String = "") {
        self.raw = raw
    }

    var isEmpty: Bool { raw.isEmpty }

    /// "1.250.000,75", or "0" when empty.
    var display: String { raw.isEmpty ? "0" : NumberFormatterHelper.formatThousands(raw) }

    /// Lowercase words, empty when there is no input.
    var words: String { raw.isEmpty ? "" : TerbilangHelper.words(forRaw: raw) }

    func press(_ key: Key) {
        limitReached = false
        switch key {
        case .clear:
            raw = ""
        case .delete:
            if !raw.isEmpty { raw.removeLast() }
        case .comma:
            if !raw.contains(",") { raw = (raw.isEmpty ? "0" : raw) + "," }
        case .digits(let digits):
            append(digits)
        }
    }

    /// Accepts text like "Rp 1.250.000,75". Returns false when it has no digits or is too long.
    @discardableResult
    func paste(_ text: String) -> Bool {
        let candidate = NumberFormatterHelper.rawNumber(fromPasted: text)
        guard candidate.contains(where: \.isNumber) else { return false }
        let parts = candidate.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
        let integer = trimmedLeadingZeros(parts[0])
        let decimals = parts.count > 1 ? String(parts[1].prefix(TerbilangHelper.maxDecimalDigits)) : nil
        guard integer.count <= TerbilangHelper.maxIntegerDigits else {
            limitReached = true
            return false
        }
        limitReached = false
        raw = integer + (decimals.map { "," + $0 } ?? "")
        return true
    }

    private func append(_ digits: String) {
        if let commaIndex = raw.firstIndex(of: ",") {
            let decimalCount = raw.distance(from: commaIndex, to: raw.endIndex) - 1
            let room = TerbilangHelper.maxDecimalDigits - decimalCount
            if room <= 0 {
                limitReached = true
            } else {
                raw += digits.prefix(room)
            }
        } else {
            let integer = trimmedLeadingZeros(raw + digits)
            if integer.count > TerbilangHelper.maxIntegerDigits {
                limitReached = true
            } else {
                raw = integer
            }
        }
    }

    private func trimmedLeadingZeros(_ value: String) -> String {
        let trimmed = value.drop { $0 == "0" }
        return trimmed.isEmpty ? (value.isEmpty ? "" : "0") : String(trimmed)
    }
}
