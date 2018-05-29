
//  ViewController.swift
//  iOS_ContactList
//  Created by Natalie Nuno on 3/27/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.

import UIKit
import CoreData

class MainViewController: UIViewController, ContactDelegate, UISearchBarDelegate {
    
    var contacts:[Contacts] = []
//    var num: String
    
//    var myPhoneNumber = String()
    
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "fname CONTAINS[c] %@", searchText)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Contacts")
            fetchRequest.predicate = predicate
            do {
                contacts = try managedObjectContext.fetch(fetchRequest) as! [Contacts]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        } else if searchText.isEmpty {
            fetchAll()
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contact List"
        fetchAll()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        let firstSort = NSSortDescriptor(key: "fname", ascending: true)
        let secondSort = NSSortDescriptor(key: "lname", ascending: true)
        request.sortDescriptors = [firstSort, secondSort]
        do {
            let results = try managedObjectContext.fetch(request)
            contacts = results as! [Contacts]
        } catch {
            print("\(error)")
        }
    }
    
    func saveItem(fname: String, lname: String, number: String, at indexPath: IndexPath?) {
        if let ip = indexPath {
            let addition = contacts[ip.row]
            addition.fname = fname;
            addition.lname = lname;
            addition.number = number;
        }else {
            let newcont = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: managedObjectContext) as! Contacts
            newcont.fname = fname
            newcont.lname = lname
            newcont.number = formattedNumber(number: number)
        }
        appDelegate.saveContext()
        fetchAll()
        tableView.reloadData() //reload the tableview with the new item.
        dismiss(animated: true, completion: nil) //dismiss the view.
    }
    
    func formattedNumber(number: String) -> String {
        var cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask = "+X (XXX) XXX-XXXX"
        
        if cleanPhoneNumber.count == 10 {
            cleanPhoneNumber = "1" + cleanPhoneNumber
        }
        else if cleanPhoneNumber.count == 7 {
            mask = "XXX-XXXX"
        }
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex { //if start and end are the same, string is empty, therefore break
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func cancelButtonPressed(by controller: AddEditViewController) {
        dismiss(animated: true, completion: nil)
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let navController = segue.destination as! UINavigationController //we go through the nav controller segue
        if segue.identifier == "AddEditItemSegue" {
            let addController = navController.topViewController as! AddEditViewController // nav connects to the addvc
            addController.delegate = self  // this main controller is the addview controller delegate
        
            if let indexPath = sender as? IndexPath { // if the request was sent from an index path send the following values from the cell.
                let sendcont = contacts[indexPath.row]         // values for the edit through the prepare.
                addController.fnameItem = sendcont.fname!   // taskitem descitem, dateitem in the addvc.swift hold the values while it segues.
                addController.lnameItem = sendcont.lname!   // sending the index path allows these items to set in the same cell after editing.
                addController.numberItem = sendcont.number!
                addController.indexPath = indexPath     //without the indexpath it will add the edit into a new cell.
            }
        }
        if segue.identifier == "ViewSegue" {
            let viewController = navController.topViewController as! ViewDetailsController // nav connects to the addvc
            
            let indexPath = sender as! IndexPath  // if the request was sent from an index path send the following values from the cell.
            let sendcont = contacts[indexPath.row]         // values for the edit through the prepare.
            viewController.fnameItem = sendcont.fname!   // taskitem descitem, dateitem in the addvc.swift hold the values while it segues.
            viewController.lnameItem = sendcont.lname!   // sending the index path allows these items to set in the same cell after editing.
            viewController.numberItem = sendcont.number!
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        let fullName = contact.fname! + " " + contact.lname!
        
        cell.textLabel?.text = fullName
        // textLabel is always left det label.
        cell.detailTextLabel?.text = contact.number
        // detailTextLabel is always the right side detail label.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!)-> Void in
            let item = self.contacts[indexPath.row]
            self.managedObjectContext.delete(item)
            self.appDelegate.saveContext()
            self.contacts.remove(at: indexPath.row) //remove the cell after deletion.
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!)-> Void in
            self.performSegue(withIdentifier: "AddEditItemSegue", sender: indexPath)
        })
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "ViewSegue", sender: indexPath)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })

        optionMenu.addAction(viewAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)

        present(optionMenu, animated: true, completion: nil)
    }
}
