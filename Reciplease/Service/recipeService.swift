//
//  recipeService.swift
//  Reciplease
//
//  Created by Yoan on 07/05/2022.
//

import Foundation
import Alamofire

class RecipeService {
    static var shared = RecipeService()
    private var session: Session
    
    init(session: Session = Session.default) {
        self.session = session
    }
    
    func getTheRecipes(ingredients: String, callBack: @escaping(Result<RecipesDTO, Error>) -> Void) {
        let url = "https://api.edamam.com/api/recipes/v2?type=public&q=\(ingredients)&app_id=\(ApiKey.edamamAppId)&app_key=\(ApiKey.edamamAppKey)&imageSize=REGULAR"
        
        session.request(url)
            .validate(statusCode: 200..<400)
            .responseData { response in
                
                switch response.result {
                case .success(let result):
                    
                    switch response.response?.statusCode {
                    case 200:
                        guard let recipes = try? JSONDecoder().decode(RecipesDTO.self, from: result) else {
                            callBack(.failure(APIError.decoding))
                            return
                        }
                        callBack(.success(recipes))
                    default:
                        callBack(.failure(APIError.statusCodeInvalid))
                    }
                    
                case .failure(let error):
                    callBack(.failure(error))
                }
            }
    }
}
