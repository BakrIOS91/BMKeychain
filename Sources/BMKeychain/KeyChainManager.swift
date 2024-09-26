//
//  KeyChainManager.swift
//  BMKeychain
//
//  Created by Bakr mohamed on 26/09/2024.
//

import Foundation
import Security

@MainActor
public struct KeychainHelper {
    public static let shared = KeychainHelper()
    
    private let service: String = Bundle.main.bundleIdentifier ?? "com.keychain.service"
    
    func saveValue(_ value: String, forKey: String) throws {
        if try retrieveValue(forKey: forKey)?.isEmpty  ?? true {
            guard let data = value.data(using: .utf8) else {
                throw KeychainError.failedToConvertValueToData
            }
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: forKey,
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw KeychainError.failedToSaveValue
            }
        } else {
            try updateValue(value, forKey: forKey)
        }
        
    }
    
    func updateValue(_ value: String, forKey: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.failedToConvertValueToData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: forKey
        ]
        
        let updateFields: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, updateFields as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError.failedToUpdateValue
        }
    }
    
    func retrieveValue(forKey: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: forKey,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            throw KeychainError.failedToRetrieveValue
        }
        
        if let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            throw KeychainError.failedToRetrieveValue
        }
    }
    
    func deleteValue(forKey: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: forKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError.faildToDeleteValue
        }
    }
}
