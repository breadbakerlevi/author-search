//
//  UserPhoto.swift
//  AuthorSearch
//
//

// SwiftData model for persisting user-added photos

import Foundation
import SwiftData

@Model
class UserPhoto {
    var authorKey: String
    var imageData: Data
    
    init(authorKey: String, imageData: Data) {
        self.authorKey = authorKey
        self.imageData = imageData
    }
}
