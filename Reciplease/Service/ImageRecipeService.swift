//
//  ImageRecipeService.swift
//  Reciplease
//
//  Created by Yoan on 09/05/2022.
//

import Foundation
import Alamofire

class ImageRecipeService {
    static var shared = ImageRecipeService()

    private init() {}
    
    func getImage(link: String, callBack: @escaping(Result <Data, Error>) -> Void) {
        guard let url = URL(string: link) else {
            return
        }
        AF.request(url)
            .validate(statusCode: 200..<400)
            .response(queue: DispatchQueue.global(qos: .background), completionHandler: { (response) in
                guard let data = response.data else {
                    callBack(.failure(response.error ?? APIError.noData))
                    return
                }
                callBack(.success(data))
            })
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                guard let data = data, error != nil else {
//                    return
//                }
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    callBack(.failure(error!))
//                    return
//                }
//            let imageRecipe = ImageDTO(imageRecipe: data)
//                callBack(.success(imageRecipe.imageRecipe))
//            }
//        }.resume()
    }
}

