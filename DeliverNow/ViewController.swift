//
//  ViewController.swift
//  DeliverNow
//
//  Created by 滕施男 on 4/05/2016.
//  Copyright © 2016 TENG. All rights reserved.
//

import UIKit
//import Firebase

class ViewController: UIViewController {
    
    //let ref = Firebase(url: "https://delivernow-monash4039.firebaseio.com")

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil {
            self.logoutButton.hidden = false
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: UIButton) {
//        ref.authUser(emailTextField.text!, password: passwordTextField.text!, withCompletionBlock: { error, authData in
//            if error != nil {
//                print(error)
//            } else {
//                let uid = authData.uid
//                print("Login successfully with the uid: \(uid!)")
//            }
//        })
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != "" {
            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                if error == nil {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    print("Logged in succeessfully with the userID: \(authData.uid)")
                    self.logoutButton.hidden = false
                } else {
                    print(error)
                }
            })
        } else {
            let alert = UIAlertController(title: "Sorry", message: "Empty input cannot be accepted...", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func logoutAction(sender: UIButton) {
        CURRENT_USER.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.logoutButton.hidden = true
    }
    
}



















