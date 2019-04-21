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
    
    var subject = Subject()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
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
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        okAction.isEnabled = false
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
        if cell.textLabel?.text == subject.words[indexPath.row] {
            cell.textLabel?.text = subject.def[indexPath.row]
        } else {
            cell.textLabel?.text = subject.words[indexPath.row]
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subject.def.remove(at: indexPath.row)
            subject.words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let wordToMove = subject.words[sourceIndexPath.row]
        let defToMove = subject.def[sourceIndexPath.row]
        subject.words.remove(at: sourceIndexPath.row)
        subject.def.remove(at: sourceIndexPath.row)
        subject.words.insert(wordToMove, at: destinationIndexPath.row)
        subject.def.insert(defToMove, at: destinationIndexPath.row)
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
