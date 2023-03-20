//
//  CompletionRequest.swift
//  
//
//  Created by Ramunas Jurgilas on 2023-03-20.
//

import Foundation

// MARK: - CompletionRequest
struct CompletionRequest: Codable {
    let prompt: String
    let model: String?
    let maxTokens: Int?
    let temperature: Double?
    let topP: Int?
    let n: Int?
    let stream: Bool?
    let logprobs: Int?
    let stop: String?

    enum CodingKeys: String, CodingKey {
        case model, prompt
        case maxTokens = "max_tokens"
        case temperature
        case topP = "top_p"
        case n, stream, logprobs, stop
    }
}
