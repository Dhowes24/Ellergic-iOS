//
//  SpoonacularNetworkManager.swift
//  Ellergic-iOS
//
//  Created by Derek Howes on 5/1/25.
//

import Foundation

class SpoonacularNetworkService: NetworkingService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = URLSession(configuration: .ephemeral)
    }

    func fetchData(apiURL: URL) async throws -> Data? {
        do {
            let (data, _) = try await session.data(from: apiURL)
            return data
        } catch {
            print("Network or decoding error: \(error)")
            throw error
        }
    }
}
