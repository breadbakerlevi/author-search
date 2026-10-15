//
//  SearchContext.swift
//  AuthorSearch
//
//

// Search context for debounced search

/* References:
 AmitAswal. (2024, October 10). Debounce in Combine : SwiftUI. Medium. https://medium.com/@amitaswal87/debounce-in-combine-swiftui-b6e55d2792dc

 Fadeeva, N. (2024, July 15). How to delay server requests for user’s search query with SwiftUI and Combine. Tanaschita.com. https://tanaschita.com/combine-swiftui-search-query-debounce/

 Saidi, D. (2025, January 8). Creating a debounced search context for performant SwiftUI searches. Danielsaidi.com. https://danielsaidi.com/blog/2025/01/08/creating-a-debounced-search-context-for-performant-swiftui-searches
*/

import Foundation
import Combine

class SearchContext: ObservableObject {
    
    init() {
        $query
            .debounce(for: .seconds(0.25), scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$debouncedQuery)
    }
    
    @Published var query = ""
    @Published var debouncedQuery = ""
    
    @Published var authors: [SearchAuthors] = []
    @Published var isLoading = false
    
    func performSearch(query: String) {
        guard !query.isEmpty else {
            authors = [];
            return }
        
        Task {
            await MainActor.run { isLoading = true }
            do {
                let service = AuthorService()
                let result = try await service.searchAuthors(query: query)
                await MainActor.run {
                    authors = result
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    authors = []
                    isLoading = false
                }
            }
        }
    }
}


