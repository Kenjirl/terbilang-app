//
//  terbilang_appApp.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import SwiftUI

@main
struct terbilang_appApp: App {
    @State private var history = HistoryStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(history)
                .tint(Theme.accent)
        }
    }
}
