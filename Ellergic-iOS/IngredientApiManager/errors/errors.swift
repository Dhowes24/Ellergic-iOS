//
//  errors.swift
//  Ellergic-iOS

import Foundation

enum IngredientManagerError: Error, LocalizedError {
    case invalidUPC
    case failedToFetchIngredients
    case invalidResponse
    case failedUrlCreation

    var errorDescription: String? {
        switch self {
        case .invalidUPC:
            return "The UPC code is missing or invalid."
        case .failedToFetchIngredients:
            return "Failed to fetch product ingredients from the API."
        case .invalidResponse:
            return "The response from the server was invalid."
        case .failedUrlCreation:
            return "Failed to create request URL."
        }
    }
}
