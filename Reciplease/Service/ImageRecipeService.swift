//
//  ImageRecipeService.swift
//  Reciplease
//
//  Created by Yoan on 09/05/2022.
//

import Foundation
import Alamofire

class ImageRecipeService {
    static var shared = ImageRecipeService(session: SessionTask.shared)
    var session: SessionTaskProtocol
    private init(session: SessionTaskProtocol) {
        self.session = session
    }

    func getImage(link: String, callBack: @escaping(Result <Data, Error>) -> Void) {
       
        session.sendTask(url: link) { result in
            switch result {
            case .success(let data):
                callBack(.success(data))
            case .failure(let error):
                callBack(.failure(error))
            }
        }
        
//        AF.request(url)
//            .validate(statusCode: 200..<400)
//            .response(queue: DispatchQueue.global(qos: .background), completionHandler: { (response) in
//                guard let data = response.data else {
//                    callBack(.failure(response.error ?? APIError.noData))
//                    return
//                }
//                callBack(.success(data))
//            })
    }
}
