//
//  Photo.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/3/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import Foundation

struct Photo {
    let photoId: String
    let postedDate: Date
    let userName: String
    let userId: String
    let photoURL: String
    let photoText: String
    let category: String
}

extension Photo {
    init(_ dictionary: [String: Any]) {
        self.photoId = dictionary["photoId"] as? String ?? "no item name"
        self.postedDate = dictionary["posteddate"] as? Date ?? Date()
        self.userName = dictionary["userName"] as? String ?? "no name"
        self.userId = dictionary["userId"] as? String ?? "no user Id"
        self.photoURL = dictionary["photoURL"] as? String ?? "no photo URL"
        self.photoText = dictionary["photoText"] as? String ?? "no text"
        self.category = dictionary["category"] as? String ?? "no category"
    }
}
