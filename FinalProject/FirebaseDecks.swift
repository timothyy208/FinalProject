//
//  FirebaseDecks.swift
//  FinalProject
//
//  Created by Timothy Yang on 4/22/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit
import Firebase
class FirebaseDecks: UIViewController {
    var subjects = Subjects()
    var db: Firestore!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        db = Firestore.firestore()
        loadData {
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadData {
            self.tableView.reloadData()
        }
    }
    

    
 
    

    
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("subjects").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.subjects.subjectArray = []
            for document in querySnapshot!.documents {
                let sub = document.data()
                let tname = sub["name"]
                let twords = sub["words"]
                let tdef = sub["def"]
                let tdisp = sub["display"]
                let tpost = sub["post"]
                let tdoc = sub["doc"]
                
                let subject = Subject(name: tname as! String, words: twords as! [String], def: tdef as! [String], disp: tdisp as! Bool, post: tpost as! String, doc: tdoc as! String)
                subject.documentID = document.documentID
                self.subjects.subjectArray.append(subject)
            }
            completed()
        }
    }

}

extension FirebaseDecks: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FCell", for: indexPath)
        cell.textLabel?.text = subjects.subjectArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.subjectArray.count
    }
}
