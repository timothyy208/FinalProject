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
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    var subject = Subject(name: "", words: [], def: [], disp: true, post: "", doc: "")
    var maxindex = 0
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        maxindex = subject.words.count
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
        if currentIndex < maxindex - 1{
            updateWord("right")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.rightButton.backgroundColor = UIColor.white
        }

    }

    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        leftButton.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        if currentIndex > 0 {
            updateWord("left")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.leftButton.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func showDefButtonPressed(_ sender: UIButton) {
        currentDefinition.isHidden = currentDefinition.isHidden == true ? false : true
    }
    
    func updateWord(_ direction: String) {
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
    }
}
