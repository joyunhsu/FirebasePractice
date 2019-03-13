//
//  ViewController.swift
//  FirebasePractice
//
//  Created by 徐若芸 on 2019/3/13.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    lazy var db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var articleRef: DocumentReference? = nil
    var userID: String = "YrVzf2PvU2ukDsTvQOxS"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        // Add a user with a generated ID
//        ref = db.collection("users").addDocument(data: [
//            "user_email": "jo3@mail.com",
//            "user_name": "jo3",
//            "friends": [
//                [
//                "id": "token1",
//                "statusCode": 1
//                ]
//            ]
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(self.ref!.documentID)")
//            }
//        }
//
//        self.userID = self.ref!.documentID
        
        // Update user info with ID
//        let usersRef = db.collection("users")
//
//        usersRef.document("\(userID)").setData([
//        "user_id": "\(userID)"
//        ]) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("update success")
//                }
//            }
        
        
        // post article: add a new document in subcollection article
//        articleRef = db.collection("article").addDocument(data:
//            [
//                "article_content": "today is the best day",
//                "article_id": "byJo",
//                "article_tag": "SchoolLife",
//                "article_title": "Today",
//                "author": "\(userID)",
//                "created_time": time
//            ]
//        ) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Successfully add article, ID: \(self.articleRef!.documentID)")
//                }
//            }
        
        
        // Get all document data from collection users
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
        
        
        // Get document data from particular user with ID
//        let docRef = db.collection("users").document("\(userID)")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        
        let jo2Ref = db.collection("users").document("\(userID)")
        
        // Atomically add a new region to the "regions" array field.
        jo2Ref.updateData([
            "friends": FieldValue.arrayUnion([
                    [
                    "id": "token2",
                    "statusCode": 1
                    ]
                ])
            ])
        
        // Atomically remove a region from the "regions" array field.
//        washingtonRef.updateData([
//            "regions": FieldValue.arrayRemove(["east_coast"])
//            ])

    }

}

