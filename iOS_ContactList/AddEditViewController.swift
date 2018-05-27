//
//  AddEditViewController.swift
//  iOS_ContactList
//
//  Created by Natalie Nuno on 3/27/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
 
    @IBOutlet weak var fnameText: UITextField!
    @IBOutlet weak var lnameText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    
    weak var delegate: ContactDelegate?
    
    var fnameItem: String?
    var lnameItem: String?
    var numberItem: String?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (indexPath != nil) {
            self.title = "Edit Contact"
        } else {
            self.title = "New Contact"
        }
        
        fnameText.text = fnameItem
        lnameText.text = lnameItem
        numberText.text = numberItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: AddEditViewController) {
        var ulname = lnameText.text!
        var ufname = fnameText.text!
        var unumber = numberText.text!
        
        ulname = ulname.trimmingCharacters(in: .whitespaces)
    
        ufname = ufname.trimmingCharacters(in: .whitespaces)

        unumber = unumber.trimmingCharacters(in: .whitespaces)
        
        
        delegate?.saveItem(fname: ufname, lname: ulname, number: unumber, at: indexPath)
    }

}
