//
//  ViewController.swift
//  FinalProject
//
//  Created by Timothy Yang on 4/15/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var subjects = Subjects()
    //let a = Subject(name:"dog",words:["dog":"dog"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjects.subjectArray.append(Subject(name:"Ecology and Evolution", words:["mitochondria","vestigial trait"], def: ["powerhouse","useless"]))
        subjects.subjectArray.append(Subject(name:"Psychology", words:["iq","eq"], def: ["intelligent","emotional"]))
        subjects.subjectArray.append(Subject(name:"Japanese", words:["Namae","gohan"], def: ["name","rice"]))
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailVC" {
            let destination = segue.destination as! DetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.subject = subjects.subjectArray[index]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            addButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
            addButton.isEnabled = false
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Subject", message: "Enter Subject Name Here", preferredStyle: .alert)
        alert.addTextField {(textField) in textField.text = ""}
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {[weak alert] (_) in
            let textField = alert?.textFields![0]
            self.subjects.subjectArray.append(Subject(name:(textField?.text)!, words: [], def: []))
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = subjects.subjectArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.subjectArray.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subjects.subjectArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let subjectToMove = subjects.subjectArray[sourceIndexPath.row]
        subjects.subjectArray.remove(at: sourceIndexPath.row)
        subjects.subjectArray.insert(subjectToMove, at: destinationIndexPath.row)
    }
}
