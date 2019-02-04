//
//  ViewController.swift
//  FirebaseFacebook
//
//  Created by Andrew Seeley on 29/1/19.
//  Copyright © 2019 Seemu. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

class ViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        loginButton.center = view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        if let accessToken = AccessToken.current {
            // User is already logged in with facebook
            print("User is already logged in")
            print(accessToken)
            firebaseFaceBookLogin(accessToken: accessToken.authenticationToken)
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("User logged in")
        
        switch result {
        case .failed(let err):
            print(err)
        case .cancelled:
            print("cancelled")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("success")
            print(accessToken)
            firebaseFaceBookLogin(accessToken: accessToken.authenticationToken)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("User logged out")
    }
    
    func firebaseFaceBookLogin(accessToken: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signInAndRetrieveData(with: credential, completion: {(authResult, error) in
            if let error = error {
                print("Firebase Login Error")
                print(error)
                return
            }
            // User has signed
            print("Firebase Login Done")
            print(authResult)
            if let user = Auth.auth().currentUser {
                print("Current firebase user is")
                print(user)
            }
        })
    }
    

}

