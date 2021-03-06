// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import SwiftUI

public struct ContentContainerView: View {
    @EnvironmentObject var authorizer: Authorizer
    @State var selectedContent = ContentType.albums

    public init() {
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .clear
        // SwiftUI bug? incorrectly changes bar tint to dark mode in light mode so commented out...
        // UITabBar.appearance().barTintColor = .systemBackground
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().showsVerticalScrollIndicator = false
        UINavigationBar.appearance().barTintColor = .systemBackground
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedContent) {
                ContentTab<Artist>()
                ContentTab<Song>()
                ContentTab<Album>()
                ContentTab<Playlist>()
            }
            AudioBar()
                .environmentObject(AudioPlayer.shared)
                .offset(x: 0, y: -49)
        }
        .overlay(!self.authorizer.authorized ? AuthView().environmentObject(authorizer).background(Color(UIColor.systemBackground)) : nil)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentTab<Content: MusicArchiveFramework.Content>: View {
    var body: some View {
        ContentView<Content>()
            .environmentObject(ContentObserver<Content>())
            .environmentObject(AudioPlayer.shared)
            .tabItem {
                Image(systemName: Content.imageName())
                Text(Content.description.capitalized)
            }.tag(Content.contentType).padding(.bottom, 49)
    }
}

extension Content {}
