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
    init(session: SessionTaskProtocol) {
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
    }
}
