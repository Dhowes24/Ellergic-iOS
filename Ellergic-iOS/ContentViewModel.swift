//  Ellergic-iOS


import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    let spoonacularProvider = SpoonacularManager(networkingService: MockNetworkingService())

    @Published var returnedResults: ProductByUpcResults?

    init() {
    }

    func callAPI() async throws {
        self.returnedResults = try await spoonacularProvider.findProductIngredients()
    }
}
