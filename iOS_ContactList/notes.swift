//
//  notes.swift
//  iOS_ContactList
//
//  Created by Natalie Nuno on 5/28/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.
//

import UIKit

//  Make calls using the phone number
//    var url:NSURL = NSURL(string: "telprompt://1234567891")!
//    UIApplication.sharedApplication().openURL(url)
//    clean the number first.
//
//    Okay I got help and figured it out. Also I put in a nice little alert system just in case the phone number is not valid. My issue was I was calling it right but the number had spaces and unwanted characters such as ("123 456-7890"). UIApplication only works or accepts if your number is ("1234567890"). So you basically remove the space and invalid characters by making a new variable to pull only the numbers. Then calls those numbers with the UIApplication.
//
//    func callSellerPressed (sender: UIButton!){
//        var newPhone = ""
//
//        for (var i = 0; i < countElements(busPhone); i++){
//
//            var current:Int = i
//            switch (busPhone[i]){
//            case "0","1","2","3","4","5","6","7","8","9" : newPhone = newPhone + String(busPhone[i])
//            default : println("Removed invalid character.")
//            }
//        }
//
//        if  (busPhone.utf16Count > 1){
//
//            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + newPhone)!)
//        }
//        else{
//            let alert = UIAlertView()
//            alert.title = "Sorry!"
//            alert.message = "Phone number is not available for this business"
//            alert.addButtonWithTitle("Ok")
//            alert.show()
//        }
//    }

