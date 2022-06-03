//
//  CoreDataError.swift
//  Reciplease
//
//  Created by Yoan on 19/05/2022.
//

import Foundation

enum CoreDataError: Error {
    case deleteError
    case saveError

    var detail: String {
        switch self {
        case .deleteError:
            return "Error during deleting"
        case .saveError:
            return "Error while saving"
        }
    }
}
