//
//  ListModelsResponse.swift
//  
//
//  Created by Ramunas Jurgilas on 2023-03-12.
//

import Foundation

// MARK: - ListModelsResponse
public struct ListModelsResponse: Codable {
    let data: [Datum]
    let object: String
}

// MARK: - Datum
public struct Datum: Codable {
    let id, object, ownedBy: String

    enum CodingKeys: String, CodingKey {
        case id, object
        case ownedBy = "owned_by"
    }
}
