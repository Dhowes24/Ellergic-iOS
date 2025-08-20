//
//  FirebaseUI.swift
//  Ellergic-iOS
//
//  Created by Derek Howes on 8/13/25.
//

import Foundation
import FirebaseAuth
import SwiftUI


class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?
    
    init() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] _ , user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
                self?.user = user
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
        if let authResult {
                strongSelf.user = authResult.user
            }
        }
    }
    
    func signUp(email: String, password: String) async throws {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult {
                self.user = authResult.user
            }
        }
    }
    
    func signOut() throws {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func updateDisplayName(_ displayName: String)  {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { error in
            print("Error changing display name: \(error?.localizedDescription ?? "Unknown Error")")
        }
    }
}
