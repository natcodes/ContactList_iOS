//  viewDetailsController.swift
//  iOS_ContactList
//  Created by Natalie Nuno on 3/28/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.

import Foundation
import UIKit

class ViewDetailsController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var fnameItem: String?
    var lnameItem: String?
    var numberItem: String?
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let fullName = fnameItem! + " " + lnameItem!
        nameLabel.text = "Name: \(fullName)"
        numberLabel.text = "Number: \(numberItem!)"
        self.title = fullName
    }

}
