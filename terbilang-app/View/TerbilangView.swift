//
//  TerbilangView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import SwiftUI

struct TerbilangView: View {
    @StateObject private var vm = TerbilangViewModel()
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    CurrencyTextField(
                        text: $vm.displayInput,
                        placeholder: "Masukkan angka"
                    ) { newValue in
                        vm.handleInputChange(newValue)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
                }
                
                Divider()
                
                VStack {
                    Text(vm.result.isEmpty ? "Hasil terbilang muncul di sini" : vm.result)
                        .lineLimit(5)
                        .padding()
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(vm.result == "Over Limit" ? .red : .primary)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button {
                            if !vm.result.isEmpty && vm.result != "Over Limit" {
                                showSheet = true
                            }
                        } label: {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(24)
                        .sheet(isPresented: $showSheet) {
                            ResultSheetView(result: vm.result)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 20)
            }
            .navigationTitle("Terbilang")
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

#Preview {
    TerbilangView()
}
