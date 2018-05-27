//
//  ContactDelegate.swift
//  iOS_ContactList
//
//  Created by Natalie Nuno on 3/27/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.
//

import Foundation
import UIKit

protocol ContactDelegate: class {
    func saveItem(fname: String, lname: String, number: String, at indexPath: IndexPath?)
    
    func cancelButtonPressed(by controller: AddEditViewController)
}
