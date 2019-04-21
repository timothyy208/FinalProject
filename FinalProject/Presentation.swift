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
    
    var subject = Subject()
    var maxindex = 0
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        maxindex = subject.words.count
        currentWord.text = subject.words[currentIndex] ?? ""
        currentDefinition.text = subject.def[currentIndex] ?? ""
        currentDefinition.isHidden = true
        wordProgress.text = "\(currentIndex+1)/\(maxindex)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        if currentIndex < maxindex - 1{
            updateWord("right")
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        if currentIndex > 0 {
            updateWord("left")
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
