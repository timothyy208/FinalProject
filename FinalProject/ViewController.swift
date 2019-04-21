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
}
