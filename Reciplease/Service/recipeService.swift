//
//  recipeService.swift
//  Reciplease
//
//  Created by Yoan on 07/05/2022.
//

import Foundation
import Alamofire

class RecipeService {
    static var shared = RecipeService(session: SessionTask.shared)
    var session : SessionTaskProtocol
    
    init(session: SessionTaskProtocol) {
        self.session = session
    }
    
    func getTheRecipes(ingredients: String, callBack: @escaping(Result<RecipesDTO, Error>) -> Void) {
        let url = "https://api.edamam.com/api/recipes/v2?type=public&q=\(ingredients)&app_id=\(ApiKey.edamamAppId)&app_key=\(ApiKey.edamamAppKey)&imageSize=REGULAR"
        session.sendTask(url: url) { result in
            
            switch result {
            case .success(let data):
                guard let recipes = try? JSONDecoder().decode(RecipesDTO.self, from: data) else {
                    callBack(.failure(APIError.decoding))
                    return
                }
                callBack(.success(recipes))
                
            case.failure(let error):
                callBack(.failure(error))
            }
        }
    }
}
