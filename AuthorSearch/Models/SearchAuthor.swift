//
//  SearchAuthors.swift
//  AuthorSearch
//
//

// Model for API calls to Open Library

struct SearchAuthors: Identifiable, Decodable {
    let key: String
    let name: String
    let birthDate: String?
    let topWork: String?
    let workCount: Int?
    let topSubjects: [String]?
 
    var id: String { key }

    private enum CodingKeys: String, CodingKey {
        case key
        case name
        case birthDate = "birth_date"
        case topWork = "top_work"
        case workCount = "work_count"
        case topSubjects = "top_subjects"
    }
}

// Wrapper for the "docs" array containing the list of authors
struct SearchResponse: Decodable {
    let docs: [SearchAuthors]
}
