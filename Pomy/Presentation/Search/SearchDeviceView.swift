//
//  ContentView.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/24.
//

import SwiftUI
import CoreBluetooth

struct SearchDeviceView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("colorful_tomato")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300)
                Color.clear.opacity(0.1)
                    .background(.ultraThinMaterial)
                VStack {
                    Text("設備検出一覧")
                        .font(.title)
                        .fontWeight(.bold)
                    Divider()
                    Button(isScanning ? "検出停止" : "検出開始") {
                        if isScanning {
                            bleManager.stopScan()
                        } else {
                            bleManager.startScan()
                        }
                        isScanning.toggle()
                    }
                    .foregroundColor(isScanning ? .red : .green)
                    .padding()
                    
                    if isScanning {
                        // スキャン中は「検出中…」を表示
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("検出中…")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    if bleManager.devices.isEmpty {
                        Text("デバイスが見つかりませんでした")
                            .padding()
                    } else {
                        List(bleManager.devices, id: \.identifier) { device in
                            HStack {
                                Text(device.name ?? "名前なしのデバイス")
                                Spacer()
                                if bleManager.connectedPeripheral?.identifier == device.identifier {
                                    Text("接続済み")
                                        .foregroundColor(.green)
                                } else {
                                    Button("接続") {
                                        bleManager.connect(to: device)
                                    }
                                }
                            }
                            .padding(5)
                        }
                    }
                    Spacer()
                }
                .frame(height: 700)
            }
            .navigationBarBackButtonHidden()
            .ignoresSafeArea()
        }
    }
}


#Preview {
    SearchDeviceView()
        .environmentObject(BLEManager())
}
