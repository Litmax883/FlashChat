//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by MAC on 06.11.2020.
//  Copyright © 2020 Litmax. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       labelAnimation()
    
    }
    
    
    
// MARK: -- Private func's --
    
    private func labelAnimation () {
        titleLabel.text = ""
        let title = "⚡️FlashChat"
        var charIndex = 0.0
        
        for letter in title {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }

}
