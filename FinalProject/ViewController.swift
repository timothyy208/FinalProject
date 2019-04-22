//
//  ViewController.swift
//  FinalProject
//
//  Created by Timothy Yang on 4/15/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var subjects = Subjects()
    var saveFromCloud: Subject?
    var authUI: FUIAuth!
    var loadFromCloud = false
    var defaultsData = UserDefaults.standard
    var userName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = (Auth.auth().currentUser?.uid)!

        authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = self
        signIn()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        userName = (Auth.auth().currentUser?.uid)!
        signIn()
        if loadFromCloud {
            loadSaveFromCloud()
            loadFromCloud = false
        }
        //print(saveFromCloud.name)
        
    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) {
        
    }

    func loadSaveFromCloud() {
        for item in subjects.subjectArray {
            if item.name == saveFromCloud!.name {
                return
            }
        }
        subjects.subjectArray.append(saveFromCloud!)
        
        tableView.reloadData()
        //print("hi")
    }

    func signIn() {
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
            ]
        if authUI.auth?.currentUser == nil {
            
            self.authUI.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            tableView.isHidden = false
            
        }
        loadData()
        tableView.reloadData()
        
    }
    
    @objc func naviAdd() {
        let alert = UIAlertController(title: "Add Subject", message: "", preferredStyle: .alert)
        alert.addTextField {
            $0.placeholder = "Enter Subject Here"
            $0.addTarget(alert, action: #selector(alert.subjectDidChange), for: .editingChanged)
            
        }
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak alert] (_) in
            let textField = alert?.textFields![0].text
            self.subjects.subjectArray.append(Subject(name:textField!, words: [], def: [], disp: true, post: "", doc: ""))
            self.saveData()
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        okAction.isEnabled = false
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func naviEdit() {
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
    
    func saveData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(subjects.subjectArray) {
            defaultsData.set(encoded, forKey: "\(userName)")
            
        } else {
            print("error saving")
        }
        
    }
    

    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        
        do {
            try authUI!.signOut()
            subjects = Subjects()
            print("signed out")
            signIn()
        } catch {
            tableView.isHidden = true
            print("signout error")
        }
    }
    
    func loadData() {
        print(userName,"adfasdf")
        if let savedData = defaultsData.object(forKey: "\(userName)") as? Data {
            let decoder = JSONDecoder()
            if let data = try? decoder.decode([Subject].self, from: savedData) {
                subjects.subjectArray = data
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailVC" {
            let destination = segue.destination as! DetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.subject = subjects.subjectArray[index]
            destination.fromCloud = false
            destination.userName = userName
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
            self.subjects.subjectArray.append(Subject(name:textField!, words: [], def: [], disp: true, post: "", doc: ""))
            self.saveData()
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
        saveData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit Subject", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in textField.text = self.subjects.subjectArray[indexPath.row].name

            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {(updateAction) in
                let old = self.subjects.subjectArray[indexPath.row]
                var oldData = Subject(name: "", words: [], def: [], disp: true, post: "", doc: "")
                if let savedData = self.defaultsData.object(forKey: old.name) as? Data {
                    let decoder = JSONDecoder()
                    if let data = try? decoder.decode(Subject.self, from: savedData) {
                        oldData = data
                    }
                }
                self.subjects.subjectArray[indexPath.row].name = (alert.textFields?.first?.text)!
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                self.saveData()
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(oldData) {
                    self.defaultsData.set(encoded, forKey: (alert.textFields?.first?.text)!)
                } else {
                    print("error saving")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            

            self.present(alert, animated: false)
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.subjects.subjectArray.remove(at: indexPath.row)
            self.saveData()
            tableView.reloadData()
        })
        
        let uploadAction = UITableViewRowAction(style: .default, title: "Upload", handler:  {(action, indexPath) in
            print("hi")
            //put firebase save datahere
            self.subjects.subjectArray[indexPath.row].saveData {success in
                if success {
                    print("saved data ot firebase")
                } else {
                    print("error saving data")
                }
                
            }
        })

        return [deleteAction, editAction, uploadAction]
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

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        tableView.isHidden = false
        print("signed in with \(user?.displayName ?? "")")
        //userName = user?.displayName ?? ""
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginVC = FUIAuthPickerViewController(authUI: authUI)
        loginVC.view.backgroundColor = UIColor.white
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets * 2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "Sprite-1")
        logoImageView.contentMode = .scaleAspectFit
        loginVC.view.addSubview(logoImageView)
        
        return loginVC
    }
}


