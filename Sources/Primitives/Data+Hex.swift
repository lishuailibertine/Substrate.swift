//
//  Data+Hex.swift
//  
//
//  Created by Yehor Popovych on 04.08.2021.
//

import Foundation

public extension Data {
    init?(hex: String) {
        guard let hexData = hex.data(using: .ascii) else { return nil }
        guard hexData.count % 2 == 0 else { return nil }
        let prefix = hex.hasPrefix("0x") ? 2 : 0
        let result: Data? = hexData.withUnsafeBytes { hex in
            var result = Data()
            result.reserveCapacity((hexData.count - prefix) / 2)
            var current: UInt8? = nil
            for indx in prefix ..< hex.count {
                let v: UInt8
                switch hex[indx] {
                case let c where c <= 57: v = c - 48
                case let c where c >= 65 && c <= 70: v = c - 55
                case let c where c >= 97: v = c - 87
                default: return nil
                }
                if let val = current {
                    result.append(val << 4 | v)
                    current = nil
                } else {
                    current = v
                }
            }
            return result
        }
        guard let _result = result else { return nil }
        self = _result
    }
    
    func hex(prefix: Bool = true) -> String {
        return self.withUnsafeBytes { data in
            var result = Data()
            result.reserveCapacity(data.count * 2 + (prefix ? 2 : 0))
            if prefix {
                result.append(UInt8(ascii: "0"))
                result.append(UInt8(ascii: "x"))
            }
            Self._hexCharacters.withUnsafeBytes { hex in
                for byte in data {
                    result.append(hex[Int(byte >> 4)])
                    result.append(hex[Int(byte & 0x0F)])
                }
            }
            return String(bytes: result, encoding: .ascii)!
        }
    }
    
    private static let _hexCharacters = Data("0123456789abcdef".utf8)
}
