//
//  LandingView.swift
//  terbilang-app
//
//  Created by Benedict Kenjiro Lehot on 03/04/26.
//

import SwiftUI

struct LandingView: View {
    @State private var selection = 1

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            TabView(selection: $selection) {
                TerbilangView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(1)
                
                SettingView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .tag(2)
            }
        }
    }
}

#Preview {
    LandingView()
}
