//
//  SystemStorage.swift
//  
//
//  Created by Yehor Popovych on 1/12/21.
//

import Foundation

public struct AccountStorageKey<S: System> {
    /// Account to retrieve the `AccountInfo<S>` for.
    public let accountId: S.TAccountId
}

extension AccountStorageKey: StorageKey {
    public typealias Value = AccountInfo<S>
    
    public static var MODULE: Module.Type { SystemModule<S>.self }
    public static var FIELD: String { "Account" }
    
    public var path: [ScaleDynamicEncodable] { return [accountId] }
}