//
//  NetworkingService.swift
//  Ellergic-iOS

import Foundation

protocol NetworkingService {
    func fetchData(apiURL: URL) async throws -> Data?
}
