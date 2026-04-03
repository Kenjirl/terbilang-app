//
//  TerbilangViewModel.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import Foundation
internal import Combine

class TerbilangViewModel: ObservableObject {
    @Published var displayInput: String = ""  // yang tampil di TextField (formatted)
    @Published var rawInput: String = ""      // angka bersih tanpa formatting
    @Published var result: String = ""

    func handleInputChange(_ newValue: String) {
        let stripped = newValue.replacingOccurrences(of: ".", with: "")
        let extracted = NumberFormatterHelper.extractNumberWithDecimal(stripped)

        let integerString = extracted.split(separator: ",").first.map(String.init) ?? extracted
        if let integerValue = Int(integerString), integerValue > TerbilangHelper.maxLimit {
            let previous = NumberFormatterHelper.formatThousands(rawInput)
            if previous != displayInput { displayInput = previous }
            result = "Over Limit"
            return
        }

        rawInput = extracted
        let formatted = NumberFormatterHelper.formatThousands(extracted)
        if formatted != displayInput { displayInput = formatted }
        result = extracted.isEmpty ? "" : TerbilangHelper.convertWithDecimal(extracted)
    }
}
