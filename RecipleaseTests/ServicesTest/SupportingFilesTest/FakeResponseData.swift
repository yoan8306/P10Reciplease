//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Yoan on 19/05/2022.
//

import Foundation

class FakeResponseData {
    var recipesCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "RecipesList", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    var recipesIncorrectData = "I'm bad json".data(using: .utf8)
    var imageData = "image".data(using: .utf8)
    
    class ResponseError: Error {
        var responseError = ResponseError()
    }
}
