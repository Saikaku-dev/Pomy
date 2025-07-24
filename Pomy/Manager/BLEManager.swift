//
//  BLEManager.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/24.
//
import SwiftUI
import CoreBluetooth
import Combine
// BLEマネージャー
class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var devices: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    
    private var centralManager: CBCentralManager!
    private var scannedPeripheralIdentifiers = Set<UUID>()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // スキャンを手動で開始する
    func startScan() {
        devices.removeAll()
        scannedPeripheralIdentifiers.removeAll()
        connectedPeripheral = nil
        
        if centralManager.state == .poweredOn {
            // すべての周辺機器をスキャン
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        }
    }
    
    // スキャンを停止する
    func stopScan() {
        centralManager.stopScan()
    }
    
    // セントラルマネージャの状態が更新されたときに呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("BLE が有効になりました")
        default:
            print("BLE の状態が変更されました: \(central.state.rawValue)")
            devices.removeAll()
        }
    }
    
    // 周辺機器が発見されたときに呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        // デバイス名に“M5Stick”が含まれているデバイスをフィルタリング（必要に応じて変更可）
        if let name = peripheral.name, name.contains("M5Stick") {
            // 重複追加を防ぐ
            if !scannedPeripheralIdentifiers.contains(peripheral.identifier) {
                scannedPeripheralIdentifiers.insert(peripheral.identifier)
                devices.append(peripheral)
            }
        }
    }
    
    // デバイスに接続する
    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
    
    // 接続成功時のコールバック
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        print("\(peripheral.name ?? "名前なし") に接続しました")
        stopScan()
    }
    
    // 接続失敗時のコールバック
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("接続失敗: \(error?.localizedDescription ?? "不明なエラー")")
    }
}
