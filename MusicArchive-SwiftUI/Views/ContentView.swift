//
//  ContentView.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var loading: Bool = false
    @EnvironmentObject var content: ContentObserver
    func getContent<T: Content>(type: T.Type) {
        self.loading = true
        ArchiveClient.shared.getContent(type: type, completionHandler: { fetchedContent -> () in
            DispatchQueue.main.async {
                self.content.content = fetchedContent
                self.loading = false
            }
        })
    }
    
    var body: some View {
        VStack {
            if loading {
                Text("Loading...")
            }
            Spacer()
            List(content.content, id: \.name) { content in
                ContentRow(content: content).environmentObject(AudioPlayer.shared)
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.getContent(type: Album.self)
                }) {
                    Text("Albums")
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Artist.self)
                }) {
                    Text("Artists")
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Song.self)
                }) {
                    Text("Songs")
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Playlist.self)
                }) {
                    Text("Playlists")
                }
                Spacer()
            }
            Spacer()
            AudioBar().environmentObject(AudioPlayer.shared)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentObserver())
    }
}
