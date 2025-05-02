//
//  MockNetworkingService.swift
//  Ellergic-iOS
//
//  Created by Derek Howes on 5/1/25.
//

import Foundation

class MockNetworkingService: NetworkingService {

    // Response for UPC 034000011346 - Cadbury Eggs
    func fetchData(apiURL: URL) async throws -> Data? {
        
        guard let url = Bundle.main.url(forResource: "response", withExtension: "json") else {
            throw NSError(domain: "LocalJSON", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        if let data = try? Data(contentsOf: url) {
            return data
        } else {
            throw NSError(domain: "MockNetworkingServiceErrorDomain", code: -1, userInfo: nil)
        }
    }
}
