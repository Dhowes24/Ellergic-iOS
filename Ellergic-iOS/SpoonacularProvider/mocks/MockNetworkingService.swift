//
//  MockNetworkingService.swift
//  Ellergic-iOS

import Foundation

class MockNetworkingService: NetworkingService {
    let breakResponse: Bool

    init(breakResponse: Bool = false) {
        self.breakResponse = breakResponse
    }

    // Response for UPC 034000011346 - Cadbury Eggs
    func fetchData(apiURL: URL) async throws -> Data? {
        guard let url = Bundle.main.url(forResource: breakResponse ? "brokenResponse" : "response", withExtension: "json") else {
            throw NSError(domain: "LocalJSON", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        if let data = try? Data(contentsOf: url) {
            return data
        } else {
            throw NSError(domain: "MockNetworkingServiceErrorDomain", code: -1, userInfo: nil)
        }
    }
}
