//
//  AuthGateKeeper.swift
//  Ellergic-iOS
//
//  Created by Derek Howes on 8/20/25.
//

import SwiftUI

struct AuthGateKeeper: View {
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                MainAppView(onLogout: {
                    isLoggedIn = false
                })
            } else {
                AuthenticationView(onLoginSuccess: {
                    isLoggedIn = true
                })
            }
        }
        .animation(.easeInOut, value: isLoggedIn)
    }
}

#Preview {
    AuthGateKeeper()
}
