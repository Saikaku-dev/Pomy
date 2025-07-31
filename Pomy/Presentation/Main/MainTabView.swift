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
                SearchDeviceView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .tint(.red)
    }
}



#Preview {
    MainTabView()
        .environmentObject(BLEManager())
}
