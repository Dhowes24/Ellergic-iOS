//
//  ProductSearchModel.swift
//  Ellergic-iOS
//
//  Created by Howes, Derek on 4/29/25.
//

import Foundation

struct SearchProductResults: Codable {
    let id: Int
    let title: String
    let badges: [String]
    let importantBadges: [String]
    let breadcrumbs: [String]
    let generatedText: String
    let image: String
    let imageType: String
    let upc: String
    let ingredients: [Ingredient]
    let ingredientList: String
}

struct Ingredient: Codable {
    let name: String
    let safetyLevel: String
    let description: String
}
