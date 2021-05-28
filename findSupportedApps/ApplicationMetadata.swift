//
//  ApplicationMetadata.swift
//  findSupportedApps
//
//  Created by Daniel Bates on 27/05/2021.
//

import Foundation


struct ApplicationMetadata: Codable {
    let displayName: String
    let supportedDocumentTypes: [CFBundleDocumentType]
    
    enum CodingKeys: String, CodingKey {
        case displayName = "CFBundleDisplayName"
        case supportedDocumentTypes = "CFBundleDocumentTypes"
    }
    
    init?(dictionary: [String: Any])
    {
        do {
            if !JSONSerialization.isValidJSONObject(dictionary) {
                return nil
            }
            self = try JSONDecoder().decode(ApplicationMetadata.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch {
            return nil
        }

    }
    
}

extension ApplicationMetadata: CustomStringConvertible {
    var description: String {
        return "Display Name:" + displayName
    }
}

struct CFBundleDocumentType: Codable {
    
    let lsItemContentTypes: [String]
    
    enum CodingKeys: String, CodingKey {
        case lsItemContentTypes = "LSItemContentTypes"
    }
}




