//
//  Presentation.swift
//  FinalProject
//
//  Created by Timothy Yang on 4/21/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit

class Presentation: UIViewController {

    @IBOutlet weak var currentWord: UILabel!
    @IBOutlet weak var currentDefinition: UILabel!
    @IBOutlet weak var wordProgress: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    
    var studyWord: [String] = []
    var studyDef: [String] = []
    var subject = Subject(name: "", words: [], def: [], disp: true, post: "", doc: "")
    var maxindex = 0
    var currentIndex = 0
    var quiz = false
    var quizIndex = 0
    var quizMaxIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        maxindex = subject.words.count
        quizButton.isEnabled = false
        if maxindex > 0 {
            currentWord.text = subject.words[currentIndex]
            currentDefinition.text = subject.def[currentIndex]
            currentDefinition.isHidden = true
        }
        wordProgress.text = "\(currentIndex+1)/\(maxindex)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {

        rightButton.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        if quiz == false {
            if currentIndex < maxindex - 1{
                updateWord("right")
            }
        } else  {
            if quizIndex < quizMaxIndex - 1{
                updateWord("right")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.rightButton.backgroundColor = UIColor.white
        }

    }

    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        leftButton.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        if quiz == false {
            if currentIndex > 0 {
                updateWord("left")
            }
        } else {
            if quizIndex > 0  {
                updateWord("left")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.leftButton.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func showDefButtonPressed(_ sender: UIButton) {
        showButton.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        currentDefinition.isHidden = currentDefinition.isHidden == true ? false : true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.showButton.backgroundColor = UIColor.white
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if saveButton.imageView?.image == UIImage(named: "Sprite-4") {
            studyDef.append(currentDefinition.text ?? "")
            studyWord.append(currentWord.text ?? "")
            quizButton.isEnabled = true
            updateSaveButtonImage()
        } else {
            let tIndex = studyWord.firstIndex(of: currentWord.text ?? "")
            studyWord.remove(at: tIndex!)
            studyDef.remove(at: tIndex!)
            if studyWord.count == 0{
                quizButton.isEnabled = false
            }
            updateSaveButtonImage()
            
        }

        
    }
    
    func updateSaveButtonImage() {

        if studyWord.contains(currentWord.text ?? "") {
            saveButton.setImage(UIImage(named: "Sprite-3"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "Sprite-4"), for: .normal)
        }

    }
    
    @IBAction func quizButtonPressed(_ sender: UIButton) {
        if quiz == false{
            quizMaxIndex = studyDef.count
            quizIndex = 0
            quiz = true
            quizButton.setImage(UIImage(named: "Sprite-6"), for: .normal)
            saveButton.isHidden = true
            wordProgress.isHidden = true
            currentWord.text = studyWord[quizIndex]
            currentDefinition.text = studyDef[quizIndex]
            print(studyWord)
            print(studyDef)
        } else {
            quiz = true
            quizButton.setImage(UIImage(named: "Sprite-5"), for: .normal)
            saveButton.isHidden = false
            //reset
            currentWord.text = subject.words[currentIndex]
            currentDefinition.text = subject.def[currentIndex]
            wordProgress.text = "\(currentIndex+1)/\(maxindex)"
            wordProgress.isHidden = false
            currentDefinition.isHidden = true
        }
    }
    
    
    func updateWord(_ direction: String) {
        if quiz == false {
            if direction == "right" {
                currentIndex += 1
                currentWord.text = subject.words[currentIndex]
                currentDefinition.text = subject.def[currentIndex]
                wordProgress.text = "\(currentIndex+1)/\(maxindex)"
                currentDefinition.isHidden = true
            } else {
                currentIndex -= 1
                currentWord.text = subject.words[currentIndex]
                currentDefinition.text = subject.def[currentIndex]
                wordProgress.text = "\(currentIndex+1)/\(maxindex)"
                currentDefinition.isHidden = true
            }
            updateSaveButtonImage()
        } else {
            if direction == "right" {
                quizIndex += 1
                currentWord.text = studyWord[currentIndex]
                currentDefinition.text = studyDef[currentIndex]
                //wordProgress.text = "\(currentIndex+1)/\(maxindex)"
                currentDefinition.isHidden = true
            } else {
                quizIndex -= 1
                currentWord.text = studyWord[currentIndex]
                currentDefinition.text = studyDef[currentIndex]
                //wordProgress.text = "\(currentIndex+1)/\(maxindex)"
                currentDefinition.isHidden = true
            }
        }
    }
}
