//
//  AppState.swift
//  AuthorSearch
//
//

// Shared state for selected author and current tab

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var selectedAuthor: SearchAuthors?
    @Published var selectedTab: Int = 0
}
