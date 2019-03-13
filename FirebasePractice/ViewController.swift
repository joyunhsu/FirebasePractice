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
        
        // Add data with a new ID
//        ref = db.collection("users").addDocument(data: [
//            "user_email": "jo@mail.com",
//            "user_id": 139,
//            "user_name": "jo"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(self.ref!.documentID)")
//            }
//        }
        
        
        // Update data in document
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
        
        
        // add article in article subcollection in user
        ref = db.collection("users/cma5EgufnDsWMz9Hi1n5/article").addDocument(data:
            [
                "article_content": "today is the best day",
                "article_id": "byJo",
                "article_tag": "SchoolLife",
                "article_title": "Today",
                "author": "Jo",
                "created_time": 234
            ]
        ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Successfully add article to user, ID: \(self.ref!.documentID)")
                }
            }
        
        
        // Get data
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
        
        
        // Get certain document
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

