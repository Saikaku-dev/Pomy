//
//  HomeView.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/24.
//

import SwiftUI
import CoreBluetooth

struct HomeView: View {
    @EnvironmentObject var bleManager: BLEManager
    
    var body: some View {
        ZStack {
            Image("colorful_tomato")
                .resizable()
                .scaledToFill()
                .frame(width: 300)
            Color.clear.opacity(0.1)
                .background(.ultraThinMaterial)
            
            if let device = bleManager.connectedPeripheral {
                VStack {
                    Text("接続中デバイス UUID: \(device.identifier.uuidString)")
                    Text("Bool値: \(bleManager.m5StickBoolValue ? "true" : "false")")
                }
            } else {
                Text("デバイスに未接続です")
            }
            
            Text("")
        }
        .ignoresSafeArea(.all)
    }
}

extension Color {
    static var homeColor:Color {
        return Color(red: 251/255, green: 223/255, blue: 184/255)
    }
}

#Preview {
    HomeView()
        .environmentObject(BLEManager())
}
