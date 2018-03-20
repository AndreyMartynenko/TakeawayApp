//
//  ClientError.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

enum ClientError: Error {
    case jsonConversionFailure
    case jsonParsingFailure
    case jsonInvalidPath
    case invalidData
    case custom(
        code: Int?,
        description: String?
    )
    
    var localizedDescription: String {
        switch self {
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .jsonInvalidPath: return "JSON Invalid Path"
        case .invalidData: return "Invalid Data"
        case .custom(let code, let description): if let code = code, let description = description { return "\(code): \(description)" } else { return "" }
        }
    }
}
