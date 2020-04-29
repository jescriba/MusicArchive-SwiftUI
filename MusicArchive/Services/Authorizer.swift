// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

public enum AuthError: Error {
    case generic
}

public class Authorizer: ObservableObject {
    public static let shared = Authorizer()
    @Published var authorized: Bool = false
    // Polish: real web session auth
    let username = "Sweet"
    let password = "Tunes"

    func authorize(username: String, password: String) -> AuthError? {
        guard self.username == username, self.password == password else { return .generic }
        store(token: username)
        authorized = true
        return nil
    }

    public func authorize(token _: String? = nil) -> AuthError? {
        // Polish: real web token auth
        guard UserDefaults.standard.value(forKey: "authToken") != nil else {
            return .generic
        }
        authorized = true
        return nil
    }

    func store(token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
}
