//
//  SearchItemModel.swift
//  Ellergic-iOS

import Foundation

struct FoodResponse: Codable {
    let foods: [Food]
}

struct Food: Codable {
    let foodName: String
    let brandName: String
    let tags: String?
    let nfIngredientStatement: String?

    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
        case brandName = "brand_name"
        case tags
        case nfIngredientStatement = "nf_ingredient_statement"
    }
}
