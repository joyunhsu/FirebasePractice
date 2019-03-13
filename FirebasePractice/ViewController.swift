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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add a user with a generated ID
        ref = db.collection("users").addDocument(data: [
            "user_email": "jo@mail.com",
            "user_name": "jo",
            "friends": [
                [
                "id": "token1",
                "statusCode": 1
                ]
                
            ]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        
        
        // Update user info with ID
//        let usersRef = db.collection("users")
//
//        usersRef.document("cma5EgufnDsWMz9Hi1n5").setData([
//            "user_email": "jo@mail.com",
//            "user_id": 139,
//            "user_name": "jo"
//        ]) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("update success")
//                }
//            }
        
        
        // add a new document in subcollection article
//        ref = db.collection("users/cma5EgufnDsWMz9Hi1n5/article").addDocument(data:
//            [
//                "article_content": "today is the best day",
//                "article_id": "byJo",
//                "article_tag": "SchoolLife",
//                "article_title": "Today",
//                "author": "Jo",
//                "created_time": 234
//            ]
//        ) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Successfully add article to user, ID: \(self.ref!.documentID)")
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
//        let docRef = db.collection("users").document("cma5EgufnDsWMz9Hi1n5")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
    }

}

