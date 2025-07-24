//
//  ContentView.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/24.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var isScanning = false

    var body: some View {
        NavigationView {
            VStack {
                Button(isScanning ? "検出停止" : "検出開始") {
                    if isScanning {
                        bleManager.stopScan()
                    } else {
                        bleManager.startScan()
                    }
                    isScanning.toggle()
                }
                .padding()

                if isScanning {
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("検出中…")
                    }
                    .padding()
                } else {
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
                }

                Spacer()
            }
            .navigationTitle("M5Stick デバイス一覧")
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(BLEManager())
}
