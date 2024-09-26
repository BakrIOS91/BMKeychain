//
//  KeychainError.swift
//  BMKeychain
//
//  Created by Bakr mohamed on 26/09/2024.
//

import Foundation

public enum KeychainError: Error {
    case failedToConvertValueToData
    case failedToSaveValue
    case failedToRetrieveValue
    case faildToDeleteValue
    case failedToUpdateValue
    
    var localizedDescription: String {
        switch self {
        case .failedToConvertValueToData:
            return "Failed to convert value to data"
        case .failedToSaveValue:
            return "Failed to save value"
        case .failedToRetrieveValue:
            return "Failed to retrieve value"
        case .faildToDeleteValue:
            return "Failed to delete value"
        case .failedToUpdateValue:
            return "Failed to update value"
        }
    }
    
}
