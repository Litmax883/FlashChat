//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by MAC on 06.11.2020.
//  Copyright © 2020 Litmax. All rights reserved.
//

import UIKit
import CLTypingLabel

final class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = ""
        getLabel()
    }

    
    
    
// MARK: -- Private func's --
    
    private func getLabel() {
        var count = 1.0
        self.titleLabel.text = ""
        let label = K.appName
        for letter in label {
            Timer.scheduledTimer(withTimeInterval: 0.1 * count, repeats: false, block: { (_) in
                self.titleLabel.text!.append(letter)
            })
            count += 1
        }
    }
}
