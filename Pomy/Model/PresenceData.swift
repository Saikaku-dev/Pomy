//
//  PresenceData.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/31.
//

import SwiftUI

struct PresenceData {
    var isPresent: Bool
    var timestamp: UInt32
    var sensorRaw: UInt8
    var confidence: UInt8

    init?(data: Data) {
        guard data.count >= 7 else { return nil }  // バイト数チェック
        self.isPresent = data[0] != 0
        self.timestamp = data.subdata(in: 1..<5).withUnsafeBytes { $0.load(as: UInt32.self) }
        self.sensorRaw = data[5]
        self.confidence = data[6]
    }
}
