// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import SwiftUI

struct ContentRow: View {
    @State var content: Content

    var body: some View {
        HStack {
            Text(content.name)
                .fontWeight(.semibold)
                .padding(.all, 15)
        }
    }
}

struct ContentRowPreview: PreviewProvider {
    static var previews: some View {
        ContentRow(content: Song(id: 0, createdAt: Date(), name: "Song", description: "", artists: [Artist]()))
    }
}
