//
//  AuthenticationView.swift
//  Ellergic-iOS
//
//  Created by Derek Howes on 8/13/25.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    let onLoginSuccess: () -> Void

    var body: some View {
        VStack {
            Text("Login Screen")
            
            Button("Login") {
                // Do auth logic…
                onLoginSuccess()
            }
        }
    }
}

#Preview {
    AuthenticationView(onLoginSuccess: {})
}
