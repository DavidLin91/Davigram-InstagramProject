//
//  DatabaseServices.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/3/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let photosCollection = "photos" // a collection
    
    // let's get a rrference to the Firebase Firestore database
    private let db = Firestore.firestore()
    
    public func createPicture(photoDescription: String, category: Category, postedDate: Date, userName: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        // generate a document id for the "items" collection
        // db references overall database
        // if items collection "item" is not yet created, this will automatically create the collection
        let documentRef = db.collection(DatabaseService.photosCollection).document()
        
        // create a document in our "items" collection
        db.collection(DatabaseService.photosCollection).document(documentRef.documentID).setData(["photoDescription": photoDescription, "category": category, "displayName":documentRef.documentID , "postedDate": Timestamp(date: Date ()), "userName": userName, "userId": user.uid, "categoryName": category]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
}
