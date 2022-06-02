//
//  APIError.swift
//  Reciplease
//
//  Created by Yoan on 06/05/2022.
//

import Foundation

enum APIError: Error {
    case noData
    case statusCodeInvalid
    case decoding

//    details error if error is not return
    var detail: String {
        switch self {
        case .noData:
            return "Error for download data"
        case .statusCodeInvalid:
            return "Status code invalid"
        case .decoding:
            return "Error decoding"
        }
    }
}
