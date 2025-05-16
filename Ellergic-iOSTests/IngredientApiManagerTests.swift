//
//  IngredientApiManagerManagerTests.swift
//  Ellergic-iOSTests


import XCTest
@testable import Ellergic_iOS

final class IngredientApiManagerTests: XCTestCase {
    var ingredientApiManager: IngredientApiManager!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        ingredientApiManager = nil
    }

    func testFindProductIngredientsSuccess() async throws {
        ingredientApiManager = IngredientApiManager(networkingService: MockNetworkingService())

        let response = try await ingredientApiManager.findProductIngredients(for: "")

        XCTAssertEqual(response?.foods[0].foodName, "Peanut Butter Protein Granola")
    }

    func testFindProductIngredientsFailure() async throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = IngredientApiNetworkService(session: session)
        let dummyURL = "https://example.com"

        ingredientApiManager = IngredientApiManager(networkingService: service, baseURL: dummyURL)

        do {
            _ = try await ingredientApiManager.findProductIngredients(for: "1010101")
        } catch {
            XCTAssertEqual(error as! IngredientManagerError, IngredientManagerError.failedToFetchIngredients)
        }
    }

    func testURLBuilderFailure() async throws {
        ingredientApiManager = IngredientApiManager(networkingService: MockNetworkingService())

        do {
            _ = try await ingredientApiManager.findProductIngredients(for: "invalid Url")
        } catch {
            XCTAssert(error as! IngredientManagerError == IngredientManagerError.failedUrlCreation)
        }
    }

    func testResponseParsingError() async throws {
        ingredientApiManager = IngredientApiManager(networkingService: MockNetworkingService(breakResponse: true))

        do {
            _ = try await ingredientApiManager.findProductIngredients(for: "validUrl")
        } catch {
            XCTAssert(error as! IngredientManagerError == IngredientManagerError.invalidResponse)
        }
    }
}
