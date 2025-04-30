//
//  ContentViewViewModel.swift
//  Ellergic-iOS
//
//  Created by Howes, Derek on 4/29/25.
//

import Foundation

class ContentViewModel: ObservableObject {

    let searchProductsByUpcString = "https://api.spoonacular.com/food/products/upc/"
    let apiKey = "f241f7a5375a43088714e9c61321501d"

    @Published var returnedResults: SearchProductResults?

    init() {

    }

    func callAPI() async throws {
        guard let apiURL = URL(string: buildURL()) else { return }

        let task = URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unkonwn Error")")
                return
            }

            self.returnedResults = try? self.decodeResults(from: data)

            do{
                let result = try JSONSerialization.jsonObject(with: data, options: [])
                print (result)
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }

    func buildURL(UPC: String = "034000011346") -> String {
//        "\(searchProductsByUpcString)\(UPC)?apiKey=\(apiKey)"
        "https://api.spoonacular.com/recipes/716429/information?apiKey=f241f7a5375a43088714e9c61321501d&includeNutrition=true"
    }

    func decodeResults(from json: Data) throws -> SearchProductResults {
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchProductResults.self, from: json)
        return response
    }
}
