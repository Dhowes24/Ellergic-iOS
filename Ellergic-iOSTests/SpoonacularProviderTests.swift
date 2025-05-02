//
//  SpoonacularProviderTests.swift
//  Ellergic-iOSTests


import XCTest
@testable import Ellergic_iOS

final class SpoonacularProviderTests: XCTestCase {
    var spoonacularManager: SpoonacularManager!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        spoonacularManager = nil
    }

    func testFindProductIngredientsSuccess() async throws {
        spoonacularManager = SpoonacularManager(networkingService: MockNetworkingService())

        let response = try await spoonacularManager.findProductIngredients(for: "")

        XCTAssertTrue(response?.title == "CADBURY, Milk Chocolate with Caramel Mini Eggs Candy, Easter, 3.8 oz, Pack")
    }

    func testFindProductIngredientsFailure() async throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = SpoonacularNetworkService(session: session)

        spoonacularManager = SpoonacularManager(networkingService: service)


        let testError = URLError(.notConnectedToInternet)
        MockURLProtocol.errorToThrow = testError

        let dummyURL = URL(string: "https://example.com")!

        do {
            _ = try await service.fetchData(apiURL: dummyURL)
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }


}
