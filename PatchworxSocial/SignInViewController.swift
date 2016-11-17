//
//  SignInViewController.swift
//  PatchworxSocial
//
//  Created by Paul Denton on 17/11/2016.
//  Copyright © 2016 patchworx. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookLogin(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("PAUL: UNABLE TO AUTHENTICATE - \(error)")
            } else if result?.isCancelled == true {
                print("PAUL:USER CANCELLED FB AUTH")
            } else {
                print("PAUL: SUCCESSFULLY AUTHED WITH FACEBOOK")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("PAUL: UNABLE TO AUTHENTICATE WITH FIREBASE \(error)")
            } else {
                print("PAUL: SUCCESSFULLY AUTHED WITH FIREBASE")
            }

    })
}
    @IBAction func emailSignInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("PAUL: EMAIL USER AUTHENTICATED SUCCESSFULLY WITH FIREBASE")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("PAUL: UNABLE TO AUTHENTICATE WITH FIREBASE USING EMAIL")
                            } else {
                            print("PAUL: SUCCESSFULLY AUTHENTICATED WITH FIREBASE")
                        }
                    })
                }
            })
        }
        
    }
}
