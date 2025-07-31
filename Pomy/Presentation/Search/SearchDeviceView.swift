import SwiftUI
import CoreBluetooth

struct SearchDeviceView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景画像＋半透明マテリアルを分けて自然な見え方に
                Image("colorful_tomato")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea() // 画面全体に広げる場合
                Color(.systemBackground)
                    .opacity(0.3)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("設備検出一覧")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    Button(action: toggleScan) {
                        Text(isScanning ? "検出停止" : "検出開始")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isScanning ? Color.red.opacity(0.8) : Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // スキャン中はインジケータを表示しつつ、デバイスリストも表示
                    if isScanning {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("検出中…")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }
                    
                    Group {
                        if bleManager.devices.isEmpty {
                            Text("デバイスが見つかりませんでした")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            List(bleManager.devices, id: \.identifier) { device in
                                HStack {
                                    Text(device.name ?? "名前なしのデバイス")
                                        .lineLimit(1)
                                    Spacer()
                                    if bleManager.connectedPeripheral?.identifier == device.identifier {
                                        Text("接続済み")
                                            .foregroundColor(.green)
                                            .fontWeight(.semibold)
                                    } else {
                                        Button("接続") {
                                            bleManager.connect(to: device)
                                        }
                                        .buttonStyle(BorderlessButtonStyle()) // List内ボタンのトラブル回避
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    .frame(maxHeight: 400) // 高さ制限を調整可能に
                    
                    Spacer()
                }
                .padding(.top, 48)
                .padding(.bottom, 24)
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    private func toggleScan() {
        if isScanning {
            bleManager.stopScan()
        } else {
            bleManager.startScan()
        }
        isScanning.toggle()
    }
}

#Preview {
    SearchDeviceView()
        .environmentObject(BLEManager())
}
