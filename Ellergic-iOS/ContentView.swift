//  Ellergic-iOS

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var path = NavigationPath()
    @StateObject private var docViewModel = DocumentScannerViewModel()
    @State private var offset = CGSize.zero

    var drag: some Gesture {
        DragGesture(minimumDistance: 50)
            .onChanged { value in
                if value.translation.width < 0 {
                    offset = CGSize(width: value.translation.width, height: 0)
                }
            }
            .onEnded { value in
                if value.translation.width < -50 { path.append(10) }
                offset = .zero
            }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                DocumentScannerView(viewModel: docViewModel)
            }
            .offset(offset)
            .gesture(drag)

            .ignoresSafeArea()
            .sheet(isPresented: $docViewModel.showModal) {
                VStack {
                    if let returnedResults = docViewModel.returnedResults {
                        Text(returnedResults.foods[0].foodName)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
