//
//  IngredientApiNetworkManager.swift
//  Ellergic-iOS

import Foundation

class IngredientApiNetworkService: NetworkingService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(urlRequest: URLRequest) async throws -> Data? {
        do {
            let (data, _) = try await session.data(for: urlRequest)
            return data
        } catch {
            print("Network or decoding error: \(error)")
            throw error
        }
    }
}

