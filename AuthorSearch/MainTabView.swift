//
//  MainTabView.swift
//  AuthorSearch
//
//

// Tab bar

import SwiftUI
import SwiftData

struct MainTabView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle")
                }
                .tag(0)
            DetailsView()
                .tabItem {
                    Label("Details", systemImage: "person.crop.square.on.square.angled")
                }
                .tag(1)
            WorksView()
                .tabItem {
                    Label("Works", systemImage: "books.vertical")
                }
                .tag(2)
        }
        .environmentObject(appState)
        .tint(.orange)
    }
}

#Preview {
    MainTabView()
}
