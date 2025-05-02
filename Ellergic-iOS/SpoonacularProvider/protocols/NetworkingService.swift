//
//  NetworkingService.swift
//  Ellergic-iOS
//
//  Created by Derek Howes on 5/1/25.
//

import Foundation

protocol NetworkingService {
    func fetchData(apiURL: URL) async throws -> Data?
}
