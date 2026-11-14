//
//  HomeView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 15/11/26.
//

import SwiftUI
import UIKit

struct HomeView: View {
    enum Route: Hashable {
        case history, settings
    }

    @Environment(HistoryStore.self) private var history
    @State private var vm = TerbilangViewModel()
    @State private var path: [Route] = []
    @State private var showResult = false
    @State private var copyCount = 0
    private var settings = StyleSettings()

    private var resultText: String { settings.style.apply(to: vm.words) }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 18) {
                header
                amountBlock
                receiptCard
                Spacer(minLength: 0)
                KeypadView { vm.press($0) }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Theme.paper)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .history:
                    HistoryView { raw in
                        vm.raw = raw
                        path.removeAll()
                    }
                case .settings:
                    SettingsView()
                }
            }
            .sheet(isPresented: $showResult) {
                ResultSheetView(amount: vm.display, words: vm.words) {
                    history.record(vm.raw)
                    copyCount += 1
                }
            }
            .sensoryFeedback(.impact(weight: .light), trigger: vm.raw) { _, _ in settings.haptics }
            .sensoryFeedback(.success, trigger: copyCount) { _, _ in settings.haptics }
            .sensoryFeedback(.warning, trigger: vm.limitReached) { _, new in settings.haptics && new }
        }
    }

    // MARK: - Sections

    private var header: some View {
        HStack {
            Text("Terbilang")
                .font(.serif(30, .semibold))
                .foregroundStyle(Theme.ink)
            Spacer()
            NavigationLink(value: Route.history) {
                CircleIcon(systemName: "clock.arrow.circlepath")
            }
            .accessibilityLabel("Riwayat")
            NavigationLink(value: Route.settings) {
                CircleIcon(systemName: "slider.horizontal.3")
            }
            .accessibilityLabel("Pengaturan")
        }
    }

    private var amountBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionLabel("Jumlah")
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("Rp")
                    .font(.mono(22))
                    .foregroundStyle(Theme.muted)
                Text(vm.display)
                    .font(.mono(40))
                    .tracking(-0.8)
                    .foregroundStyle(vm.isEmpty ? Theme.muted : Theme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.45)
                    .contentTransition(.numericText())
                    .animation(.snappy(duration: 0.15), value: vm.display)
                Rectangle()
                    .fill(Theme.accent)
                    .frame(width: 2, height: 32)
                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 4 }
            }
            .frame(minHeight: 52, alignment: .leading)
            .contentShape(Rectangle())
            .contextMenu {
                Button("Tempel Angka", systemImage: "doc.on.clipboard") {
                    vm.paste(UIPasteboard.general.string ?? "")
                }
                Button("Salin Angka", systemImage: "number") {
                    UIPasteboard.general.string = vm.display
                }
                .disabled(vm.isEmpty)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Jumlah \(vm.display) rupiah")
            .accessibilityHint("Tekan lama untuk menempel angka")

            if vm.limitReached {
                Text("Maksimal 999 triliun dengan 4 angka di belakang koma")
                    .font(.caption)
                    .foregroundStyle(Theme.danger)
                    .transition(.opacity)
            }
        }
        .animation(.snappy, value: vm.limitReached)
    }

    private var receiptCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionLabel("Terbilang")
                Spacer()
                Button {
                    showResult = true
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.muted)
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .padding(-8)
                .disabled(vm.isEmpty)
                .accessibilityLabel("Lihat hasil penuh")
            }

            Text(vm.isEmpty ? "Ketik angka di bawah untuk melihat terbilang" : resultText)
                .font(.serif(21))
                .italic()
                .lineSpacing(3)
                .foregroundStyle(vm.isEmpty ? Theme.muted : Theme.ink)
                .lineLimit(4)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity, minHeight: 90, alignment: .topLeading)
                .onTapGesture { if !vm.isEmpty { showResult = true } }
                .animation(.snappy(duration: 0.2), value: resultText)

            HStack(spacing: 8) {
                CopyButton(text: resultText) {
                    history.record(vm.raw)
                    copyCount += 1
                }
                ShareLink(item: resultText) {
                    OutlineLabel(title: "Bagikan", systemImage: "square.and.arrow.up")
                }
                .simultaneousGesture(TapGesture().onEnded { history.record(vm.raw) })
            }
            .disabled(vm.isEmpty)
            .opacity(vm.isEmpty ? 0.5 : 1)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
        }
    }
}

#Preview {
    HomeView()
        .environment(HistoryStore())
        .tint(Theme.accent)
}
