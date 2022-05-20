//
//  SessionTask.swift
//  Reciplease
//
//  Created by Yoan on 18/05/2022.
//

import Foundation
import Alamofire

protocol SessionTaskProtocol {
    func sendTask(url: String, callBack: @escaping (Result<Data, Error>) -> Void)
}

class SessionTask: SessionTaskProtocol {
    static let shared = SessionTask()
    private init() {}
    
    func sendTask(url: String, callBack: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url)
            .validate(statusCode: 200..<400)
            .response(queue: DispatchQueue.global(qos: .background), completionHandler: { (response) in
                guard let data = response.data else {
                    callBack(.failure(response.error ?? APIError.noData))
                    return
                }
                callBack(.success(data))
            })
    }
}
