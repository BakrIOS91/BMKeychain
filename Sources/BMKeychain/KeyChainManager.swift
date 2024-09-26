//
//  KeyChainManager.swift
//  BMKeychain
//
//  Created by Bakr mohamed on 26/09/2024.
//

import Foundation
import Security

/// A helper struct for interacting with the iOS Keychain to securely store, update, retrieve, and delete sensitive data.
@MainActor
public struct KeychainHelper {
    
    /// Singleton instance of KeychainHelper to provide easy access to its methods.
    public static let shared = KeychainHelper()
    
    /// The service name for the Keychain entries, using the app's bundle identifier. Defaults to "com.keychain.service" if unavailable.
    private let service: String = Bundle.main.bundleIdentifier ?? "com.keychain.service"
    
    /// Saves a value in the Keychain for a specified key.
    /// - Parameters:
    ///   - value: The string value to save in the Keychain.
    ///   - forKey: The unique key associated with the value.
    /// - Throws: Throws `KeychainError.failedToConvertValueToData` if the string cannot be converted to `Data`.
    ///           Throws `KeychainError.failedToSaveValue` if the save operation fails.
    ///
    /// If a value already exists for the given key, it will update the value instead.
    func saveValue(_ value: String, forKey: String) throws {
        // Check if the value already exists for the given key
        if try retrieveValue(forKey: forKey)?.isEmpty ?? true {
            // Convert the string value to Data for secure storage
            guard let data = value.data(using: .utf8) else {
                throw KeychainError.failedToConvertValueToData
            }
            
            // Keychain query dictionary to define the save operation
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,   // Specify the keychain item class
                kSecAttrService as String: service,             // Define the service (bundle identifier)
                kSecAttrAccount as String: forKey,              // Key used to identify the item
                kSecValueData as String: data                   // Data to store (converted from string)
            ]
            
            // Attempt to add the item to the Keychain
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw KeychainError.failedToSaveValue
            }
        } else {
            // If value exists, update it instead
            try updateValue(value, forKey: forKey)
        }
    }
    
    /// Updates an existing value in the Keychain for a specified key.
    /// - Parameters:
    ///   - value: The new string value to update in the Keychain.
    ///   - forKey: The unique key associated with the value.
    /// - Throws: Throws `KeychainError.failedToConvertValueToData` if the string cannot be converted to `Data`.
    ///           Throws `KeychainError.failedToUpdateValue` if the update operation fails.
    func updateValue(_ value: String, forKey: String) throws {
        // Convert the string value to Data
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.failedToConvertValueToData
        }
        
        // Keychain query to find the item to update
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,   // Specify the keychain item class
            kSecAttrService as String: service,             // Service identifier
            kSecAttrAccount as String: forKey               // Key used to find the item
        ]
        
        // Fields to update (new data)
        let updateFields: [String: Any] = [
            kSecValueData as String: data                   // New data to update in the keychain
        ]
        
        // Attempt to update the item in the Keychain
        let status = SecItemUpdate(query as CFDictionary, updateFields as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError.failedToUpdateValue
        }
    }
    
    /// Retrieves a value from the Keychain for a specified key.
    /// - Parameter forKey: The unique key associated with the value to retrieve.
    /// - Returns: The stored string value, or `nil` if no value exists.
    /// - Throws: Throws `KeychainError.failedToRetrieveValue` if the retrieval operation fails.
    func retrieveValue(forKey: String) throws -> String? {
        // Keychain query to search for the item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,   // Specify the keychain item class
            kSecAttrService as String: service,             // Service identifier
            kSecAttrAccount as String: forKey,              // Key used to find the item
            kSecMatchLimit as String: kSecMatchLimitOne,    // Limit the search to one matching item
            kSecReturnData as String: true                  // Return the stored data if found
        ]
        
        var result: AnyObject?
        // Attempt to retrieve the matching item from the Keychain
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        // Ensure the operation succeeded and the result is not nil
        guard status == errSecSuccess, let data = result as? Data else {
            throw KeychainError.failedToRetrieveValue
        }
        
        // Convert the retrieved data back into a string
        if let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            throw KeychainError.failedToRetrieveValue
        }
    }
    
    /// Deletes a value from the Keychain for a specified key.
    /// - Parameter forKey: The unique key associated with the value to delete.
    /// - Throws: Throws `KeychainError.faildToDeleteValue` if the delete operation fails.
    func deleteValue(forKey: String) throws {
        // Keychain query to identify the item to delete
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,   // Specify the keychain item class
            kSecAttrService as String: service,             // Service identifier
            kSecAttrAccount as String: forKey               // Key used to find the item
        ]
        
        // Attempt to delete the item from the Keychain
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError.faildToDeleteValue
        }
    }
}
