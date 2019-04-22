//
//  DetailVC.swift
//  FinalProject
//
//  Created by Timothy Yang on 4/21/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var presentButton: UIBarButtonItem!
    
    
    var subject = Subject()
    var defaultsData = UserDefaults.standard
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        loadDataDetailVC()
        if subject.def.count == 0 {
            presentButton.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        loadDataDetailVC()
        if subject.def.count == 0 {
            presentButton.isEnabled = false
            editButton.isEnabled = false
        } else {
            presentButton.isEnabled = true
            editButton.isEnabled = true
        }
    }
    
    func saveDataDetailVC() {
        let encoder = JSONEncoder()
        guard let encodedName = try? encoder.encode(subject) else {return}
        defaultsData.set(encodedName, forKey: "\(subject.name)")
    }
    
    func loadDataDetailVC() {
        let decoder = JSONDecoder()
        guard let saved = defaultsData.object(forKey: "\(subject.name)") as? Data else {return}
        if let data = try? decoder.decode(Subject.self, from: saved) {
            subject.name = data.name
            subject.words = data.words
            subject.def = data.def
            subject.currentlyDisplayingWord = false
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
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Word and Definition", message: "", preferredStyle: .alert)
        alert.addTextField {
            $0.placeholder = "Enter Word Here"
            $0.addTarget(alert, action: #selector(alert.textDidChange), for: .editingChanged)
            
        }
        alert.addTextField {
            $0.placeholder = "Enter Definition Here"
            $0.addTarget(alert, action: #selector(alert.textDidChange), for: .editingChanged)
            
        }
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak alert] (_) in
            let word = alert?.textFields![0].text
            let definition = alert?.textFields![1].text
            self.subject.def.append(definition!)
            self.subject.words.append(word!)
            self.tableView.reloadData()
            self.saveDataDetailVC()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        okAction.isEnabled = false
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        if subject.def.count == 0 {
            presentButton.isEnabled = false
            editButton.isEnabled = false
        } else {
            presentButton.isEnabled = true
            editButton.isEnabled = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentQuiz" {
            let destination = segue.destination as! Presentation
            destination.subject = subject
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    

    
    

}
extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject.words.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DCell", for: indexPath)
        cell.textLabel?.text = subject.words[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        //print(cell.textLabel?.text)
        cell.textLabel?.text = subject.currentlyDisplayingWord ? subject.def[indexPath.row] : subject.words[indexPath.row]
        subject.currentlyDisplayingWord = subject.currentlyDisplayingWord ? false : true
        
//        if subject.currentlyDisplayingWord == true{
//            cell.textLabel?.text = subject.def[indexPath.row]
//            subject.currentlyDisplayingWord = false
//        } else {
//            cell.textLabel?.text = subject.words[indexPath.row]
//            subject.currentlyDisplayingWord = true
//        }
        
    }

    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let wordToMove = subject.words[sourceIndexPath.row]
        let defToMove = subject.def[sourceIndexPath.row]
        subject.words.remove(at: sourceIndexPath.row)
        subject.def.remove(at: sourceIndexPath.row)
        subject.words.insert(wordToMove, at: destinationIndexPath.row)
        subject.def.insert(defToMove, at: destinationIndexPath.row)
        saveDataDetailVC()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) in
            let alertMessage = self.subject.currentlyDisplayingWord == true ? "Edit Word" : "Edit Definition"
            let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                if self.subject.currentlyDisplayingWord == true {
                    textField.text = self.subject.words[indexPath.row]
                } else {
                    textField.text = self.subject.def[indexPath.row]
                }
                
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {(updateAction) in
                if self.subject.currentlyDisplayingWord == true {
                    self.subject.words[indexPath.row] = (alert.textFields?.first?.text)!
                } else {
                    self.subject.def[indexPath.row] = (alert.textFields?.first?.text)!
                }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.saveDataDetailVC()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.subject.words.remove(at: indexPath.row)
            self.subject.def.remove(at: indexPath.row)
            tableView.reloadData()
        })
        if subject.def.count == 0 {
            presentButton.isEnabled = false
            editButton.isEnabled = false
        } else {
            presentButton.isEnabled = true
            editButton.isEnabled = true
        }
        return [deleteAction, editAction]
    }
    
    
}


extension UIAlertController {
    func isValidWord(_ word: String) -> Bool {
        return word.count > 0
    }
    
    func isValidDef(_ def: String) -> Bool {
        return def.count > 0
    }
    
    @objc func textDidChange() {
        if let word = textFields?[0].text, let def = textFields?[1].text {
            let action = actions.last
            action!.isEnabled = isValidWord(word) && isValidDef(def)
            
        }
    }
}
