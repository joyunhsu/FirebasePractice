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
    var myID: String = "RBHDCuxbXabY4jitJWuW" // user_name: jo
    var userName: String = ""
    var friendID: String = ""
    
    var requestFromUserID: String = "" {
        didSet {
            friendRequestFrom.text = "Request form: \(requestFromUserID), \(self.receiveFriendStatus)"
        }
    }
    
    var requestFromUserName: String = ""
    
    var sendFriendStatusCode: Int = 0 {
        didSet {
            userSearchResult.text = "Search Result: \(userName), \(self.sendFriendStatus)"
//            friendRequestFrom.text = "Request from: jo, \(self.friendStatus)"
        }
    }
    
    var receiveFriendStatusCode: Int = 0 {
        didSet {
            friendRequestFrom.text = "Request form: \(requestFromUserID), \(self.receiveFriendStatus)"
        }
    }
    
    var sendFriendStatus: String {
        switch sendFriendStatusCode {
        case 0: return "待邀請"
        case 1: return "待接受"
        case 2: return "拒絕邀請"
        default: return "接受邀請"
        }
    }
    
    var receiveFriendStatus: String {
        switch receiveFriendStatusCode {
        case 0: return "待邀請"
        case 1: return "收到邀請"
        case 2: return "已拒絕邀請"
        default: return "已接受邀請"
        }
    }
    
    
    @IBOutlet weak var userSearchResult: UILabel!
    @IBOutlet weak var friendRequestFrom: UILabel!
    
    @IBAction func searchUserByEmail(_ sender: UIButton) {
        let userRef = db.collection("users")
        let userEmail = "1234@gmail.com"
        
        // Create a query against the collection.
        userRef.whereField("user_email", isEqualTo: "\(userEmail)").getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        let user_name = document.get("user_name") as! String
                        self.userName = user_name
                        print(self.userName)
                        
                        self.friendID = document.documentID
                        
//                        let friends = document.get("friends") as! [[String: Any]]
//                        let flatFriends = friends.flatMap { $0.values }
//
//                        print(flatFriends)
                        
//                        if let friendsInfo = document.data() ["friends"] as? [String: Any] {
//                            let friends = friendsInfo.map { $0.value }
//                            for friend in friends {
//                                guard let validFriend = friend as? Dictionary<String, Any> else { continue }
//                                let id = validFriend["id"] as? String ?? ""
//                                print(id)
//                            }
//                        }
                    }
                    
                    self.userSearchResult.text = "Search Result: \(self.userName), \(self.sendFriendStatus)"
                }
        }
        
    }
    
    @IBAction func sendFriendRequest(_ sender: UIButton) {
        // Update friends array in document
        //        let friendID = "trI5rZzVNg5FtgQbr07G"
        let friendRef = db.collection("users").document("\(friendID)")
        
        // Atomically add a new region to the "friends" array field.
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(myID)",
                    "statusCode": 1
                ]
                ])
            ])
        
        let myRef = db.collection("users").document("\(myID)")
        myRef.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(friendID)",
                    "statusCode": 1
                ]
                ])
            ])
        
        self.sendFriendStatusCode = 1
    }
    
    @IBAction func refreshSentRequest(_ sender: UIButton) {
        // Get document data from particular user with ID
        let docRef = db.collection("users").document("\(myID)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let friends = document.get("friends") as! [[String: Any]]
                let flatFriends = friends.flatMap { $0 }
                print(flatFriends)
                
                for i in flatFriends {
                    if let key = i.key as? String, let value = i.value as? String, key == "id" {
                        self.friendID = value
                        print("id: \(value)")
                    } else {
                        self.sendFriendStatusCode = i.value as! Int
                        print("statusCode: \(i.value)")
                    }
                }
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    // Receiving Request
    @IBAction func refreshFriendRequest(_ sender: UIButton) {
        // Get document data from particular user with ID
        let docRef = db.collection("users").document("\(myID)")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let friends = document.get("friends") as! [[String: Any]]
                let flatFriends = friends.flatMap { $0 }
                print(flatFriends)
                
                for i in flatFriends {
                    if let key = i.key as? String, let value = i.value as? String, key == "id" {
                        self.requestFromUserID = value
                        print("id: \(value)")
                    } else {
                        self.receiveFriendStatusCode = i.value as! Int
                        print("statusCode: \(i.value)")
                    }
                }
                

            } else {
                print("Document does not exist")
            }
        }
        
        
    }
    
    @IBAction func acceptFriendRequest(_ sender: UIButton) {
        //        let friendID = "trI5rZzVNg5FtgQbr07G"
        let friendRef = db.collection("users").document("\(requestFromUserID)")
        friendRef.updateData([
            "friends": FieldValue.arrayRemove([
                ["id": "\(myID)", "statusCode": 1]
                ])
            ])
        
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([
                ["id": "\(myID)", "statusCode": 3]
                ])
            ])
        
        let myRef = db.collection("users").document("\(myID)")
        myRef.updateData([
            "friends": FieldValue.arrayRemove([
                ["id": "\(requestFromUserID)", "statusCode": 1]
                ])
            ])
        
        myRef.updateData([
            "friends": FieldValue.arrayUnion([
                ["id": "\(requestFromUserID)", "statusCode": 3]
                ])
            ])
        
        self.receiveFriendStatusCode = 3
    }
    
    @IBAction func declineFriendRequeset(_ sender: UIButton) {
        //        let friendID = "trI5rZzVNg5FtgQbr07G"
        let friendRef = db.collection("users").document("\(requestFromUserID)")
        friendRef.updateData([
            "friends": FieldValue.arrayRemove([
                ["id": "\(myID)", "statusCode": 1]
                ])
            ])
        
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([
                ["id": "\(myID)", "statusCode": 2]
                ])
            ])
        
        let myRef = db.collection("users").document("\(myID)")
        myRef.updateData([
            "friends": FieldValue.arrayRemove([
                ["id": "\(requestFromUserID)", "statusCode": 1]
                ])
            ])
        
        myRef.updateData([
            "friends": FieldValue.arrayUnion([
                ["id": "\(requestFromUserID)", "statusCode": 2]
                ])
            ])
        
        self.sendFriendStatusCode = 2
        
    }
    
    @IBAction func postArticle(_ sender: UIButton) {
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        //         post article: add a new document in subcollection article
        articleRef = db.collection("article").addDocument(data:
            [
                "article_content": "every other day",
                //                "article_id": "byJo ",
                "article_tag": "\(Tag.Joke.rawValue)",
                "article_title": "Title it is",
                "author": "\(myID)",
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
    
    @IBAction func getAllArticles(_ sender: UIButton) {
        // Get all documents in a collection
        db.collection("article").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    @IBAction func getArticlesByTag(_ sender: UIButton) {
        let tag = Tag.Joke.rawValue
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
    
    @IBAction func getArticlesByUser(_ sender: UIButton) {
        let user_id = ""
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
    
    @IBAction func getArticlesByUserAndTag(_ sender: UIButton) {
        let user_id: String = myID
        let tag = Tag.Joke.rawValue
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        createUser(userName: "Jo H.", userEmail: "myemail@mail.com")
//
//        postArticle(user_id: myID, title: "title", tag: Tag.Gossiping.rawValue)
        
//        sendFriendRequest(fromID: myID, toID: "trI5rZzVNg5FtgQbr07G")
        
//        replyFriendRequest(fromID: myID, toID: "trI5rZzVNg5FtgQbr07G", reply: 3)


        
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
        let friendRef = db.collection("users").document("\(friendID)")
        
        // Atomically add a new region to the "friends" array field.
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(myID)",
                    "statusCode": 1
                ]
                ])
            ])
        
        let myRef = db.collection("users").document("\(myID)")
        myRef.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(friendID)",
                    "statusCode": 1
                ]
                ])
            ])
    }
    
    func replyFriendRequest(fromID myID: String, toID friendID: String, reply: Int) {
        // Update friends array in document
        let friendRef = db.collection("users").document("\(friendID)")
        
        // Atomically remove a region from the "friends" array field.
        friendRef.updateData([
            "friends": FieldValue.arrayRemove([
                [
                    "id": "\(myID)",
                    "statusCode": 1
                ]
                ])
            ])
        
        friendRef.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(myID)",
                    "statusCode": reply
                ]
                ])
            ])
        
        let myRef = db.collection("users").document("\(myID)")
        myRef.updateData([
            "friends": FieldValue.arrayRemove([
                [
                    "id": "\(friendID)",
                    "statusCode": 1
                ]
                ])
            ])
        
        myRef.updateData([
            "friends": FieldValue.arrayUnion([
                [
                    "id": "\(friendID)",
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






