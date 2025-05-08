//  Ellergic-iOS


import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var docViewModel = DocumentScannerViewModel()

    var body: some View {
        ZStack {
            DocumentScannerView(viewModel: docViewModel)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $docViewModel.showModal) {
            VStack {
                Image(systemName: "tortoise")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        Task {
                            try await docViewModel.callAPI()
                        }
                    }

                if let returnedResults = docViewModel.returnedResults {
                    List(returnedResults.ingredients, id: \.self) { ingredient in
                        Text(ingredient.name)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
