//  Ellergic-iOS


import Foundation

public class SpoonacularManager {
    //Temp storage, will change and reset key
    let searchProductsByUpcString = "https://api.spoonacular.com/food/products/upc/"
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String

    let networkingService: NetworkingService

    init(networkingService: NetworkingService = SpoonacularNetworkService()) {
        self.networkingService = networkingService
    }

    //Test UPC for Cadbury Eggs
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
            print(error)
            throw error
        }
    }

    func findProductIngredients(for UPC: String = "034000011346") async throws -> ProductByUpcResults? {
        guard let apiURL = buildURL(with: UPC) else { return nil }

        guard let data = try await networkingService.fetchData(apiURL: apiURL) else { return nil }

        return try decodeResults(from: data)
    }
}
