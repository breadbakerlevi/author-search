//
//  Author.swift
//  AuthorSearch
//
//

// Model for author details from /authors/<KEY>.json endpoint

import Foundation

/* Reference:
 Stack Overflow. (2017, October 15). Swift structures: handling multiple types for a single property. Stack Overflow. https://stackoverflow.com/questions/46759044/swift-structures-handling-multiple-types-for-a-single-property
 */

struct Author: Identifiable, Decodable {
    let key: String
    let name: String
    let birthDate: String?
    let deathDate: String?
    let topWork: String?
    let workCount: Int?
    let bio: Bio?
    let photos: [Int]?

    var id: String { key }
    
    // Photo IDs of -1 means no photo
    var photoURLs: [URL] {
        guard let photos = photos else { return [] }
        var urls: [URL] = []
        for id in photos {
            if id > 0 {
                if let url = URL(string: "https://covers.openlibrary.org/a/id/\(id)-M.jpg") {
                    urls.append(url)
                }
            }
        }
        return urls
    }

    private enum CodingKeys: String, CodingKey {
        case key
        case name
        case birthDate = "birth_date"
        case deathDate = "death_date"
        case topWork = "top_work"
        case workCount = "work_count"
        case bio
        case photos
    }

    init(key: String, name: String, birthDate: String? = nil, deathDate: String? = nil, topWork: String? = nil, workCount: Int? = nil, bio: Bio? = nil, photos: [Int]? = nil) {
        self.key = key
        self.name = name
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.topWork = topWork
        self.workCount = workCount
        self.bio = bio
        self.photos = photos
    }
}

// Bio can be either a plain string or an object with type/value.
enum Bio: Codable {
    case string(String)
    case object(value: String)
    
    private struct BioObject: Codable {
        let type: String?
        let value: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            let stringVal = try container.decode(String.self)
            self = .string(stringVal)
        } catch DecodingError.typeMismatch {
            let objectVal = try container.decode(BioObject.self)
            self = .object(value: objectVal.value)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let bioText):
            try container.encode(bioText)
        case .object(let bioText):
            try container.encode(BioObject(type: "/type/text", value: bioText))
        }
    }
    
    // To make the code in DetailsView simpler
    var text: String {
        switch self {
        case .string(let bioText): return bioText
        case .object(let bioText): return bioText
        }
    }
}
