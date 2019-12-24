//
//  Authorizer.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/23/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case generic
}

class Authorizer: ObservableObject {
    static let shared = Authorizer()
    @Published var authorized: Bool = false
    // Polish: real web session auth
    let username = "Sweet"
    let password = "Tunes"
    
    func authorize(username: String, password: String) -> AuthError? {
        guard self.username == username && self.password == password else { return .generic }
        authorized = true
        return nil
    }
}
