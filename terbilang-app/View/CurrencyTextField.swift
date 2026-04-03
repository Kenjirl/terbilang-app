//
//  CurrencyTextField.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import SwiftUI

struct CurrencyTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onChanged: (String) -> Void

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.keyboardType = .decimalPad
        tv.delegate = context.coordinator
        tv.font = UIFont.preferredFont(forTextStyle: .title2)
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textContainer.lineFragmentPadding = 0
        tv.textContainerInset = .zero
        tv.text = placeholder
        tv.textColor = .placeholderText
        tv.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tv.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update teks terformat dari ViewModel, pertahankan kursor
        if uiView.text != text {
            let offset = context.coordinator.cursorOffset(in: uiView)
            uiView.text = text
            uiView.textColor = .label
            context.coordinator.setCursor(in: uiView, offset: offset)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(placeholder: placeholder, onChanged: onChanged)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var placeholder: String
        var onChanged: (String) -> Void

        init(placeholder: String, onChanged: @escaping (String) -> Void) {
            self.placeholder = placeholder
            self.onChanged = onChanged
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholder
                textView.textColor = .placeholderText
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            let offset = cursorOffset(in: textView)
            onChanged(textView.text ?? "")
            // Kursor diset di updateUIView setelah teks diformat
            // Simpan offset untuk dipakai updateUIView
            pendingCursorOffset = offset
        }

        var pendingCursorOffset: Int = 0

        func cursorOffset(in tv: UITextView) -> Int {
            guard let selectedRange = tv.selectedTextRange else { return tv.text.count }
            let cursorPos = tv.offset(from: tv.beginningOfDocument, to: selectedRange.end)
            let oldPrefix = String(tv.text.prefix(cursorPos))
            let oldDotsCount = oldPrefix.filter { $0 == "." }.count
            return cursorPos - oldDotsCount
        }

        func setCursor(in tv: UITextView, offset: Int) {
            let text = tv.text ?? ""
            var newOffset = 0
            var digitsSeen = 0

            for char in text {
                if digitsSeen == offset { break }
                newOffset += 1
                if char != "." { digitsSeen += 1 }
            }

            let clamped = min(newOffset, text.count)
            guard let pos = tv.position(from: tv.beginningOfDocument, offset: clamped) else { return }
            tv.selectedTextRange = tv.textRange(from: pos, to: pos)
        }
    }
}
