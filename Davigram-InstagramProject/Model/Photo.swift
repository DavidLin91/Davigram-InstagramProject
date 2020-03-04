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
    let photo: String
    let photoDescription: String
    let category: Category
}

struct Category {
    let funny: String
    let nsfw: String
    let travel: String
    let food: String
    let fitness: String
    let hobby: String
}
