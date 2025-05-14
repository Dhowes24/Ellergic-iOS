//  Ellergic-iOS

import Foundation

public class SpoonacularManager {
    //Temp storage, will change and reset key
    let searchProductsByUpcString: String
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String

    let networkingService: NetworkingService

    init(networkingService: NetworkingService, baseURL: String = "https://api.spoonacular.com/food/products/upc/") {
        self.searchProductsByUpcString = baseURL
        self.networkingService = networkingService
    }

    func buildURL(with UPC: String) -> URL? {
        guard let key = apiKey else { return nil }
        return URL(string: "\(searchProductsByUpcString)\(UPC)?apiKey=\(key)")
    }

    func decodeResults(from json: Data) throws -> ProductByUpcResults {
        let decoder = JSONDecoder()
        do{
            let response = try decoder.decode(ProductByUpcResults.self, from: json)
            return response
        } catch {
            throw DocumentScannerError.invalidResponse
        }
    }

    func findProductIngredients(for UPC: String) async throws -> ProductByUpcResults? {
        guard let apiURL = buildURL(with: UPC) else {
            throw DocumentScannerError.failedUrlCreation
        }

        let data: Data

        do {
            guard let fetchedData = try await networkingService.fetchData(apiURL: apiURL) else {
                throw DocumentScannerError.failedToFetchIngredients
            }
            data = fetchedData
        } catch {
            throw DocumentScannerError.failedToFetchIngredients
        }

        return try decodeResults(from: data)
    }
}
