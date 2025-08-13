//
//  HomeView.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/24.
//

import SwiftUI
import CoreBluetooth
import Combine
import AudioToolbox

class HomeViewModel: ObservableObject {
    // 必要に応じて追加
}

struct HomeView: View {
    @EnvironmentObject var bleManager: BLEManager

    @State private var isTimeSetting: Bool = false
    @State private var isWork: Bool = false

   

    var body: some View {
        NavigationStack {
            ZStack {
                Image("colorful_tomato")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300)
                Color.clear.opacity(0.1)
                    .background(.ultraThinMaterial)

                VStack {
                    Spacer()

                    // 接続中表示
                    if let device = bleManager.connectedPeripheral {
                        HStack {
                            Image(systemName: "shareplay")
                            Text("接続中")
                        }
                        .foregroundColor(.green)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background(Color(hex:"2C3E50")!)
                        .cornerRadius(30)
                        VStack {
                            // デバッグ表示例
                            // Text("接続中デバイス UUID: \(device.identifier.uuidString)")
                            // Text("Bool値: \(String(bleManager.m5StickBoolValue))")
                        }
                    } else {
                        HStack {
                            Text("!")
                                .foregroundColor(.white)
                                .padding(8)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                            Text("接続してください")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background(Color(hex:"2C3E50")!)
                        .cornerRadius(30)
                    }

                    Spacer()

                    // 集中してください（警告表示）
//                    if !bleManager.m5StickBoolValue {
//                        HStack {
//                            Text("!")
//                                .foregroundColor(.red)
//                                .padding(8)
//                                .overlay(
//                                    Circle()
//                                        .stroke(Color.red, lineWidth: 2)
//                                )
//                            Text("集中してください")
//                                .foregroundColor(.red)
//                        }
//                        .padding(.vertical,4)
//                        .padding(.horizontal,18)
//                        .background(Color.black)
//                        .cornerRadius(24)
//                    }

                    Spacer()

                    ZStack {
                        gauge()
                        VStack {
                            Text("集中時間")
                                .font(.title2)
                                .fontWeight(.bold)
                            HStack {
                                Text("/")
                            }
                            Button(action: {
                                isTimeSetting = true
                            }) {
                                Text("目標値を設定")
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .padding(4)
                                    .background(Color.gray)
                                    .cornerRadius(12)
                            }
                        }
                    }

                    Spacer()

                    Button(action: {
                        isWork = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "EC4F30")!)
                                .frame(width: 100)
                            Text("スタート")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 48)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .ignoresSafeArea(.all)
            .navigationDestination(isPresented: $isWork) {
                WorkView()
            }
        }
        // bleManager.m5StickBoolValueの変化を監視し、振動＆警告音を制御
        
    }

    private func gauge() -> some View {
        ZStack {
            Circle()
                .fill(.white)
                .padding(8)
            Circle()
                .stroke(
                    Color.gray.opacity(0.2),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
            Circle()
                .trim(from: 0, to: 0.9)
                .stroke(Color(hex: "EC4F30")!, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(radius: 1)
        }
        .scaledToFit()
        .frame(width: 250)
    }

    
}

extension Color {
    static var homeColor: Color {
        Color(red: 251/255, green: 223/255, blue: 184/255)
    }
}

extension Color {
    static var btnColor: Color {
        Color(red: 255/255, green: 100/255, blue: 14/255)
    }
}

extension Color {
    /// hex文字からColorを生成するイニシャライザ
    init?(hex: String, opacity: Double = 1.0) {
        let hexNorm = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        let scanner = Scanner(string: hexNorm)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let red = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(color & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: opacity)
        } else {
            return nil
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(BLEManager())
}
