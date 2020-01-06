//
//  ContentContainerView.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 1/5/20.
//  Copyright © 2020 joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentContainerView: View {
    @EnvironmentObject var authorizer: Authorizer
    @State var selectedContent: ContentType = .albums
    let contentTypes: [ContentType] = [.albums, .playlists, .songs, .artists]
    
    init() {
        UITabBar.appearance().backgroundColor = .black
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedContent) {
                ForEach(contentTypes, id: \.rawValue, content: { contentType in
                    ContentView()
                        .environmentObject(ContentObserver(type: contentType))
                        .environmentObject(AudioPlayer.shared)
                        .tabItem {
                            Image(systemName: contentType.imageName())
                            Text(contentType.rawValue.capitalized)
                        }.tag(contentType).padding(.bottom, 49)
                })
            }
            AudioBar()
                .environmentObject(AudioPlayer.shared)
                .offset(x: 0, y: -49)
        }
        .overlay(!self.authorizer.authorized ? AuthView().environmentObject(authorizer).background(Color(UIColor.systemBackground)) : nil)
    }
}
