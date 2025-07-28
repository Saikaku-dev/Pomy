//
//  MainTabView.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Home")
                }
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Setting")
                }
        }
        .tint(.red)
    }
}



#Preview {
    MainTabView()
}
