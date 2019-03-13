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
    var myID: String = "RBHDCuxbXabY4jitJWuW"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        createUser(userName: "Jo H.", userEmail: "myemail@mail.com")
//
//        postArticle(user_id: myID, title: "title", tag: Tag.Gossiping.rawValue)

        
        // Rewrite user info with ID
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

        
        
        // Get all documents in a collection
//        db.collection("article").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
        
        
    }
    
    func seeMyFriendRequest(myID: String) {
        let userRef = db.collection("users")
        // Query my profile
        
        
        
        // Query my friends status
        userRef
            .whereField("friends", arrayContains: "west_coast")
        
        // Get document data from particular user with ID
        let docRef = db.collection("users").document("\(myID)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }

    }
    
    func sendFriendRequest(fromID myID: String, toID friendID: String) {
        // Update friends array in document
        let jo2Ref = db.collection("users").document("\(friendID)")
        
        // Atomically add a new region to the "friends" array field.
        jo2Ref.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(myID)",
                    "statusCode": 0
                ]
                ])
            ])
    }
    
    func replyFriendRequest(fromID myID: String, toID friendID: String, reply: Int) {
        // Update friends array in document
        let jo2Ref = db.collection("users").document("\(friendID)")
        
        // Atomically remove a region from the "friends" array field.
        jo2Ref.updateData([
            "friends": FieldValue.arrayRemove([
                [
                    "id": " \(myID)",
                    "statusCode": 0
                ]
                ])
            ])
        
        // Atomically add a new region to the "friends" array field.
        jo2Ref.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(myID)",
                    "statusCode": reply
                ]
                ])
            ])
    }
    
    func createUser(userName: String, userEmail: String) {
        // Add a user with a generated ID
        ref = db.collection("users").addDocument(data: [
            "user_email": "\(userEmail)",
            "user_name": "\(userName)",
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
        
//        self.userID = self.ref!.documentID
    }
    
    
    
    func postArticle(user_id: String,title: String, tag: String) {
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
//         post article: add a new document in subcollection article
        articleRef = db.collection("article").addDocument(data:
            [
                "article_content": "every other day",
//                "article_id": "byJo ",
                "article_tag": "\(tag)",
                "article_title": "\(title)",
                "author": "\(user_id)",
                "created_time": time
            ]
        ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Successfully add article, ID: \(self.articleRef!.documentID)")
                }
        }
    }
    
    func filterArticlebyUser(user_id: String) {
        // Get document data from particular user with ID
//        let docRef = db.collection("users").document("\(user_id)")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        // Filter realtime data with constraint: Get multiple documents from a collection
        db.collection("article").whereField("author", isEqualTo: "\(user_id)")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
    }
    
    func filterArticleByUserAndTag(user_id: String, tag: String) {
        
        // Filter articles by user and tag
        // Create a reference to the cities collection
        let articleRef = db.collection("article")
        
        // Create a query against the collection.
        articleRef
            .whereField("author", isEqualTo: "\(user_id)")
            .whereField("article_tag", isEqualTo: "\(tag)").getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
    }
    
    func filterArticleByUser(user_id: String) {
        // Filter articles by user and tag
        // Create a reference to the cities collection
        let articleRef = db.collection("article")
        
        // Create a query against the collection.
        articleRef.whereField("author", isEqualTo: "\(user_id)").getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
        
    }
    
    func filterArticleByTag(tag: String) {
        // Filter articles by user and tag
        // Create a reference to the cities collection
        let articleRef = db.collection("article")
        
        // Create a query against the collection.
        articleRef.whereField("article_tag", isEqualTo: "\(tag)").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
    }

}

enum Tag: String {
    case SchoolLife
    case Beauty
    case Joke
    case Gossiping
}






