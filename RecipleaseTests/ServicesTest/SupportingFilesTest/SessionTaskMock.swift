//
//  mockSessionTask.swift
//  RecipleaseTests
//
//  Created by Yoan on 19/05/2022.
//

import Foundation
@testable import Reciplease

// transfert value into sendTask
class SessionTaskMock: SessionTaskProtocol {
    var data: Data?
    var responseError: Error?
    
    func sendTask(url: String, callBack: @escaping (Result<Data, Error>) -> Void) {
        if let data = data {
            callBack(.success(data))
        } else if let responseError = responseError {
            callBack(.failure(responseError))
        }
    }
}
