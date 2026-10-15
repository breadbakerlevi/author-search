//
//  Work.swift
//  AuthorSearch
//
//

// Model for author's works from /search.json endpoint

import Foundation

struct Work: Identifiable, Decodable {
    let key: String
    let title: String
    let firstPublishYear: Int?

    var id: String { key }

    private enum CodingKeys: String, CodingKey {
        case key
        case title
        case firstPublishYear = "first_publish_year"
    }
}

// Wrapper for /search.json response
struct WorksResponse: Decodable {
    let docs: [Work]
    let numFound: Int

    private enum CodingKeys: String, CodingKey {
        case docs
        case numFound = "num_found"
    }
}
