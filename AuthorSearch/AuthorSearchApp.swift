//
//  AuthorSearchApp.swift
//  AuthorSearch
//
//

import SwiftUI
import SwiftData

@main
struct AuthorSearchApp: App {
    @State private var showSplash = true
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .opacity(showSplash ? 0 : 1)
                if showSplash {
                    SplashView(showSplash: $showSplash)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
        .modelContainer(for: UserPhoto.self)
    }
}
