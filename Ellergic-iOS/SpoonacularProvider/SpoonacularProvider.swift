//  Ellergic-iOS


import Foundation

public class SpoonacularProvider {
    //Temp storage, will change and reset key
    let searchProductsByUpcString = "https://api.spoonacular.com/food/products/upc/"
    let apiKey = "f241f7a5375a43088714e9c61321501d"

    //Test UPC for Cadbury Eggs
    func buildURL(UPC: String = "034000011346") -> String {
        "\(searchProductsByUpcString)\(UPC)?apiKey=\(apiKey)"
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

    func fetchProductByUPC() async throws -> ProductByUpcResults? {
        guard let apiURL = URL(string: buildURL()) else { return nil }

        let session: URLSession = {
            return URLSession(configuration: .ephemeral)
        }()

        do {
            let (data, _) = try await session.data(from: apiURL)
            return try decodeResults(from: data)
        } catch {
            print("Network or decoding error: \(error)")
            throw error
        }
    }

    // Response for UPC 034000011346 - Cadbury Eggs
    func fetchProductByUPCTestData() async throws -> ProductByUpcResults? {
        guard let url = Bundle.main.url(forResource: "response", withExtension: "json") else {
            throw NSError(domain: "LocalJSON", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        return try decodeResults(from: Data(contentsOf: url))
    }
}
