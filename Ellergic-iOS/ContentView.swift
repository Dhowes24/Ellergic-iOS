//  Ellergic-iOS


import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .onTapGesture {
                    Task {
                        try await viewModel.callAPI()
                    }
                }

            if let returnedResults = viewModel.returnedResults {
                List(returnedResults.ingredients, id: \.self) { ingredient in
                    Text(ingredient.name)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
