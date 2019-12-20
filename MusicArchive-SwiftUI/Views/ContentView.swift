//
//  ContentView.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import SwiftUI

enum ContentType {
    case artist
    case song
    case album
    case playlist
}

struct ContentView: View {
    @State var loading: Bool = false
    @State var contentType: ContentType = .artist
    @EnvironmentObject var content: ContentObserver
    @EnvironmentObject var audioPlayer: AudioPlayer
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
            if content.content.first?.typeString() != nil {
                Text(content.content.first!.typeString())
                    .fontWeight(.heavy)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            if loading {
                Text("Loading...")
            }
            Spacer()
            List(content.content, id: \.name) { content in
                ContentRow(content: content)
                    .onTapGesture {
                        self.content.selectionAction(content)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.getContent(type: Album.self)
                    self.contentType = .album
                }) {
                    Text("Albums")
                        .fontWeight(contentType == .album ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Artist.self)
                    self.contentType = .artist
                }) {
                    Text("Artists")
                        .fontWeight(contentType == .artist ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Song.self)
                    self.contentType = .song
                }) {
                    Text("Songs")
                        .fontWeight(contentType == .song ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Playlist.self)
                    self.contentType = .playlist
                }) {
                    Text("Playlists")
                        .fontWeight(contentType == .playlist ? .heavy : .semibold)
                }
                Spacer()
            }
            Spacer()
            AudioBar().environmentObject(audioPlayer)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentObserver())
    }
}
