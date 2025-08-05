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
    @Published var m5StickBoolValue: Bool = false
    
    private var centralManager: CBCentralManager!
    private var scannedPeripheralIdentifiers = Set<UUID>()
    
    // 固有UUIDをここで定義する
    private let m5StickServiceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789abc")
    private let m5StickBoolCharacteristicUUID = CBUUID(string: "87654321-4321-4321-4321-cba987654321")
    private var targetCharacteristic: CBCharacteristic?
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
        } else {
            print("BLE が利用可能な状態ではありません")
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
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    // 接続成功時のコールバック
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        print("\(peripheral.name ?? "名前なし") に接続しました")
        stopScan()
        peripheral.discoverServices([m5StickServiceUUID]) // M5StickのサービスUUIDで探索（またはnilで全部）
    }
    
    // 接続失敗時のコールバック
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("接続失敗: \(error?.localizedDescription ?? "不明なエラー")")
    }
    
    // サービス発見
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == m5StickServiceUUID {
                peripheral.discoverCharacteristics([m5StickBoolCharacteristicUUID], for: service)
            }
        }
    }
    
    // キャラクタリスティック発見
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == m5StickBoolCharacteristicUUID {
                targetCharacteristic = characteristic
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    // キャラクタリスティックの値更新受信（TRUE/FALSE の受け取り）
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor called, uuid: \(characteristic.uuid.uuidString)")
        if let data = characteristic.value {
            print("Received data: \(data as NSData)")
            if let presenceData = PresenceData(data: data) {
                print("Parsed bool value: \(presenceData.isPresent)")
                DispatchQueue.main.async {
                    self.m5StickBoolValue = presenceData.isPresent
                }
            } else {
                print("Data parsing failed")
            }
        }
    }
}
