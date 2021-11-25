//
//  LoginViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-14.
//

import UIKit
import SwiftUI
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var msg : String = ""
    var status : Bool = false
    
    
    //@StateObject private var test = UserViewModel()
    
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 20
        btnLogin.clipsToBounds = true
        
    }
    
    @IBAction func btnLogin_Click(_ sender: Any) {
        
        var status : Bool = false
        
        var msg : String = ""
        
        
        
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
            
            if let error = error as NSError? {
                
                
                switch AuthErrorCode(rawValue: error.code) {
                
                case .operationNotAllowed:
                    
                    msg = "Email is not allowed..!"
                    
                    break
                    
                case .userDisabled:
                    
                    msg = "The user account has been disabled by an administrator."
                    
                    break
                    
                case .invalidEmail:
                    
                    msg = "The email address is badly formatted."
                    
                    break
                    
                case .wrongPassword:
                    
                    msg = "The user name or password is invalid "
                    
                    break
                    
                default:
                    
                    msg = "Error"
                }
                
            } else {
                
                msg = "User signs in successfully..!"
                
                status = true
                
            }
            
            
            if(status)
            
            
            {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tbBarController") as! UITabBarController
                newViewController.modalPresentationStyle = .fullScreen
                        self.present(newViewController, animated: true, completion: nil)
                
                
            //    let alert = UIAlertController(title: "Alert Success", message: msg, preferredStyle: UIAlertController.Style.alert)
             //   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
             //   self.present(alert, animated: true, completion: nil)
                
                
            }
            
            else
            
            
            
            {
                
                
                
                let alert = UIAlertController(title: "Alert Error", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                
                
                self.present(alert, animated: true, completion: nil)
                
                
                
                
            }
            
            
            
            
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
}


