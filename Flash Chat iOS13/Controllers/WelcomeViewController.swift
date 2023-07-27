//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Chinmay Nawkar
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        // when overiding any func always call super method
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //using cocopods only one line of code is req to print text with animation.
        titleLabel.text = K.appName
        
       /* titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "⚡️FlashChat"
        for letter in titleText {
            print("-")
            print(0.1 * charIndex) // to create 0.1s delay while printing each char animation.
            print(letter)
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            
            charIndex += 1 */
        }
        
    }
    
    
    

