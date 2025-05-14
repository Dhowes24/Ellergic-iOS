//
//  SpoonacularManagerTests.swift
//  Ellergic-iOSTests


import XCTest
@testable import Ellergic_iOS

final class SpoonacularManagerTests: XCTestCase {
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
        let dummyURL = "https://example.com"

        spoonacularManager = SpoonacularManager(networkingService: service, baseURL: dummyURL)

        do {
            _ = try await spoonacularManager.findProductIngredients(for: "1010101")
        } catch {
            XCTAssert(error as! DocumentScannerError == DocumentScannerError.failedToFetchIngredients)
        }
    }

    func testURLBuilderFailure() async throws {
        spoonacularManager = SpoonacularManager(networkingService: MockNetworkingService())

        do {
            _ = try await spoonacularManager.findProductIngredients(for: "invalid Url")
        } catch {
            XCTAssert(error as! DocumentScannerError == DocumentScannerError.failedUrlCreation)
        }
    }

    func testResponseParsingError() async throws {
        spoonacularManager = SpoonacularManager(networkingService: MockNetworkingService(breakResponse: true))

        do {
            _ = try await spoonacularManager.findProductIngredients(for: "validUrl")
        } catch {
            XCTAssert(error as! DocumentScannerError == DocumentScannerError.invalidResponse)
        }
    }
}
