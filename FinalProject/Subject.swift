//
//  Subject.swift
//  FinalProject
//
//  Created by Timothy Yang on 4/21/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import Foundation
import Firebase

class Subject: Codable{
    var name = ""
    var words = [String]()
    var def = [String]()
    var currentlyDisplayingWord = true
    var postingUserID = ""
    var documentID = ""
    
    
    init(name: String, words: [String], def: [String], disp: Bool, post: String, doc: String) {
        self.name = name
        self.words = words
        self.def = def
        self.currentlyDisplayingWord = disp
        self.postingUserID = post
        self.documentID = doc
    }
    

    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dictionary = ["name":self.name, "words":self.words, "def":self.def, "display":self.currentlyDisplayingWord, "post":self.postingUserID, "doc":self.documentID] as [String : Any]
        print(dictionary)
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        
        let dataToSave = dictionary
        
        if self.documentID != "" {
            let ref = db.collection("subjects").document(self.documentID)
            
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("subjects").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
    
    
}
