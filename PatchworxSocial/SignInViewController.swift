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
import SwiftKeychainWrapper

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
}
    
    
    @IBAction func emailSignInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("PAUL: EMAIL USER AUTHENTICATED SUCCESSFULLY WITH FIREBASE")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("PAUL: UNABLE TO AUTHENTICATE WITH FIREBASE USING EMAIL")
                            } else {
                            print("PAUL: SUCCESSFULLY AUTHENTICATED WITH FIREBASE")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("PAUL: DATA SAVED TO KEYCHAIN \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)

    }
}
