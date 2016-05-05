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
            
            let uid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
            
            // Retrieve new posts as they are added to your database
            FIREBASE_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
                print((snapshot.value.objectForKey(uid)?.objectForKey("info")?.objectForKey("name"))!)
            })
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
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        if email != "" && password != "" {
            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                if error == nil {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    print("Logged in succeessfully with the userID: \(authData.uid)")
                    self.logoutButton.hidden = false
                } else {
                    print(error.description)
                    //Check if info in the TextFields can match with the info in Firebase.
                    self.checkLoginInput(error.description)
                }
            })
        } else {
            self.ifIsEmpty()
        }
    }
    
    /*
     Loguot current user and hide the logout button in the View.
     */
    @IBAction func logoutAction(sender: UIButton) {
        CURRENT_USER.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.logoutButton.hidden = true
    }
    
    /*
     This method will let system popup differt alerts to remind users 
     depending on "error code (returned by Firebase)".
     */
    func checkLoginInput(error: String) -> Void {
        if error.rangeOfString("-5") != nil {
            let alert = UIAlertController(title: "Sorry", message: "The specified email address is invalid...", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if error.rangeOfString("-6") != nil {
            let alert = UIAlertController(title: "Sorry", message: "The specified password is incorrect...", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*
     Call this method if users don't finish fillig the blanks.
     This method will let system popup an alert to reminder users.
     */
    func ifIsEmpty() -> Void {
        let alert = UIAlertController(title: "Sorry", message: "Empty input cannot be accepted...", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}



















