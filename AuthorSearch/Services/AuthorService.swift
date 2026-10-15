//
//  AuthorService.swift
//  AuthorSearch
//
//

// Network layer for searching for authors via Open Library API

import Foundation

struct AuthorService {
    // Search for authors by name
    func searchAuthors(query: String) async throws -> [SearchAuthors] {
        guard !query.isEmpty else {
            return []
        }
        
        guard let url = URL(string: "https://openlibrary.org/search/authors.json?q=\(query)") else {
            print("Invalid URL in searchAuthors().")
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(SearchResponse.self, from: data)
        return result.docs
    }
    
    
    // Fetch detailed author info
    func fetchAuthorDetails(key: String) async throws -> Author {
        guard let url = URL(string: "https://openlibrary.org/authors/\(key).json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Author.self, from: data)
    }
    
    
    // Fetch author's works with pagination (50 per page)
    func fetchAuthorWorks(key: String, offset: Int = 0) async throws -> WorksResponse {
        guard let url = URL(string: "https://openlibrary.org/search.json?author_key=\(key)&limit=50&offset=\(offset)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WorksResponse.self, from: data)
    }
}
