//
//  PomyApp.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/24.
//

import SwiftUI

@main
struct PomyApp: App {
    @StateObject var bleManager = BLEManager()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(bleManager)
        }
    }
}
