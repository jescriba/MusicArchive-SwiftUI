// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authorizer: Authorizer
    @State var name: String = ""
    @State var password: String = ""
    @State var error: AuthError?

    var body: some View {
        VStack {
            Text("Music Archive")
                .font(.title)
                .padding(.vertical, 30)
            if error != nil {
                Text("auth error...")
                    .font(.callout)
                    .padding(10)
            }
            Text("Authorize")
                .font(.headline)
            TextField("Username", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 30)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
            Button(action: {
                self.error = self.authorizer.authorize(username: self.name,
                                                       password: self.password)
            }, label: {
                Text("Submit").font(.system(size: 25))
                })
            Spacer()
        }.padding()
    }
}
