//
//  ResultSheetView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import SwiftUI

struct ResultSheetView: View {
    let result: String

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    Text(result)
                        .padding(.vertical, 40)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    UIPasteboard.general.string = result
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(24)
            }
            .navigationTitle(Text(""))
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    ResultSheetView(result: "Hello World")
}
