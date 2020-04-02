// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import SwiftUI

struct ContentContainerView: View {
    @EnvironmentObject var authorizer: Authorizer
    @State var selectedContent: ContentType = .albums
    let contentTypes: [ContentType] = [.albums, .playlists, .songs, .artists]

    init() {
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .clear
        // SwiftUI bug? incorrectly changes bar tint to dark mode in light mode so commented out...
        // UITabBar.appearance().barTintColor = .systemBackground
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().showsVerticalScrollIndicator = false
        UINavigationBar.appearance().barTintColor = .systemBackground
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
