//  Ellergic-iOS

import Foundation

public class IngredientApiManager {
    //Temp storage, will change and reset key
    let nutrionixAppKey = Bundle.main.infoDictionary?["Nutrionix_App_Key"] as? String
    let nutrionixAppId = Bundle.main.infoDictionary?["Nutrionix_App_ID"] as? String

    let networkingService: NetworkingService

    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }

    func buildNutritionixURL(with barcode: String) -> URLRequest? {
        guard let url = URL(string: "https://trackapi.nutritionix.com/v2/search/item/?upc=\(barcode)") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(nutrionixAppId ?? "", forHTTPHeaderField: "x-app-id")
        request.addValue(nutrionixAppKey ?? "", forHTTPHeaderField: "x-app-key")

        return request
    }

    func decodeResults(from json: Data) throws -> FoodResponse {
        let decoder = JSONDecoder()
        do{
            let response = try decoder.decode(FoodResponse.self, from: json)
            return response
        } catch {
            throw IngredientManagerError.invalidResponse
        }
    }

    func findProductIngredients(for UPC: String) async throws -> FoodResponse? {
        guard let urlRequest = buildNutritionixURL(with: UPC) else {
            throw IngredientManagerError.failedUrlCreation
        }

        let data: Data

        do {
            guard let fetchedData = try await networkingService.fetchData(urlRequest: urlRequest) else {
                throw IngredientManagerError.failedToFetchIngredients
            }
            data = fetchedData
        } catch {
            throw IngredientManagerError.failedToFetchIngredients
        }

        return try decodeResults(from: data)
    }
}
