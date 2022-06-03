//
//  ImageServiceTest.swift
//  RecipleaseTests
//
//  Created by Yoan on 23/05/2022.
//

import XCTest
@testable import Reciplease

class ImageServiceTest: XCTestCase {
    func testGivenCallImageService_WhenCorrectData_ThenResultIsSuccess() {
        let session = SessionTaskMock()
        let imageService = ImageRecipeService(session: session)
        let response = FakeResponseData()
        let image = "image".data(using: .utf8)

        session.data = response.imageData

        imageService.getImage(link: "") { result in
            switch result {
            case .success(let imageData):
                XCTAssertEqual(image, imageData)
            case .failure(_):
                fatalError()
            }
        }
    }

    func testGivenCallImageService_WhenNoData_ThenResultIsFailed() {
        let session = SessionTaskMock()
        let imageService = ImageRecipeService(session: session)

        session.data = nil

        imageService.getImage(link: "") { result in
            switch result {
            case .success(_):
                fatalError()
            case .failure(let error):
                XCTAssertEqual(APIError.noData, error as! APIError)
            }
        }

    }

}
