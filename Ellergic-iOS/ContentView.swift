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
                if let returnedResults = docViewModel.returnedResults {
                    Text(returnedResults.title)
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
