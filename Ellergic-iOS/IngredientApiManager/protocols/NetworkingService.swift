//
//  NetworkingService.swift
//  Ellergic-iOS

import Foundation

protocol NetworkingService {
    func fetchData(urlRequest: URLRequest) async throws -> Data?
}
