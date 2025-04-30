//
//  ContentView.swift
//  Ellergic-iOS
//
//  Created by Derek Howes on 4/28/25.
//

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
            Text("Ellergic")

            if let returnedResults = viewModel.returnedResults {
                Text("\(returnedResults.ingredientList)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
