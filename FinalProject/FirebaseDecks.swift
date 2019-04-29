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
    var savedIndex = 0
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CloudToDetail" {
            let destination = segue.destination as! DetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.subject = subjects.subjectArray[index]
            destination.fromCloud = true
        }
        if segue.identifier == "CloudToMain"{
            let destination = segue.destination as! ViewController
            //let index = tableView.indexPathForSelectedRow!.row
            destination.saveFromCloud = subjects.subjectArray[savedIndex]
            destination.loadFromCloud = true
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
        
    }
    

    
 
    

    
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("subjects").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                
                return completed()
            }
            self.subjects.subjectArray = []
            for document in querySnapshot!.documents {
                let sub = document.data()
                let tname = sub["name"]
                let twords = sub["words"]
                let tdef = sub["def"]
                let tdisp = sub["display"]
                let tpost = ""
                let tdoc = ""
                
                let subject = Subject(name: tname as! String, words: twords as! [String], def: tdef as! [String], disp: tdisp as! Bool, post: tpost , doc: tdoc )
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let saveAction = UITableViewRowAction(style: .default, title: "Save", handler:  {(action, indexPath) in
            self.savedIndex = indexPath.row
            self.performSegue(withIdentifier: "CloudToMain", sender: self)
            

            
        })
        
        return [saveAction]
    }
}
