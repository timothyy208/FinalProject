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
        subjects.subjectArray.append(Subject(name:"Ecology and Evolution", words:["mitochondria","vestigial trait"], def: ["powerhouse","useless"], currentlyDisplayingWord: true))
        subjects.subjectArray.append(Subject(name:"Psychology", words:["iq","eq"], def: ["intelligent","emotional"], currentlyDisplayingWord: true))
        subjects.subjectArray.append(Subject(name:"Japanese", words:["Namae","gohan"], def: ["name","rice"], currentlyDisplayingWord: true))
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
        let alert = UIAlertController(title: "Add Subject", message: "", preferredStyle: .alert)
        alert.addTextField {
            $0.placeholder = "Enter Subject Here"
            $0.addTarget(alert, action: #selector(alert.subjectDidChange), for: .editingChanged)
            
        }
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak alert] (_) in
            let textField = alert?.textFields![0].text
            self.subjects.subjectArray.append(Subject(name:textField!, words: [], def: [], currentlyDisplayingWord: true))
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        okAction.isEnabled = false
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = subjects.subjectArray[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.subjectArray.count
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let subjectToMove = subjects.subjectArray[sourceIndexPath.row]
        subjects.subjectArray.remove(at: sourceIndexPath.row)
        subjects.subjectArray.insert(subjectToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit Subject", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in textField.text = self.subjects.subjectArray[indexPath.row].name

            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {(updateAction) in
                self.subjects.subjectArray[indexPath.row].name = (alert.textFields?.first?.text)!
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.subjects.subjectArray.remove(at: indexPath.row)
            tableView.reloadData()
        })
        return [deleteAction, editAction]
    }
}

extension UIAlertController {
    func isValidSubject(_ subject: String) -> Bool {
        return subject.count > 0
    }
    
    @objc func subjectDidChange() {
        if let subject = textFields?[0].text{
            let action = actions.last
            action!.isEnabled = isValidSubject(subject)
            
        }
    }
}
