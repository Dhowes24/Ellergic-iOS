//  Ellergic-iOS

import Foundation

struct ProductByUpcResults: Codable {
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

struct Ingredient: Codable, Hashable {
    let name: String
    let safety_level: String?
    let description: String?
}
