//
//  SignUpViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-14.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var txtReqNo: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtNicNo: UITextField!
    @IBOutlet weak var txtVehicalNo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var txtEmal: UITextField!
    
    @IBOutlet weak var chk: UISwitch!
    
    public var db: Firestore? //Property Injection
    
    var uid : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore .firestore()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btnSignUp_Click(_ sender: Any) {
        
        if(chk.isOn)
        {
            Auth.auth().createUser(withEmail: txtEmal.text!, password: txtPassword.text!) {  authResult, error in
                
                if(authResult != nil)
                {
                    self.ShowMessage(msg: "Successfully Account Created !")
                }
                else
                {
                    self.ShowMessage(msg: "Something went wrong !")
                    return
                }
                
                self.uid = (authResult?.user.uid)! as String
               
                if(self.CreateCustomerAccount())
                {
                    self.ShowMessage(msg:"Success");
                }
                else
                {
                    self.ShowMessage(msg:"error");
                }
            }
        }
        else
        {
            self.ShowMessage(msg: "You muct agree to terms.")
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "UserId" : uid,
            "Name" : txtName.text!,
            "NicNo" : txtNicNo.text!,
            "Email" : txtEmal.text!,
            "VehicalNo" : txtVehicalNo.text!,
            "Password" : txtPassword.text!,
        ]
    }
    
    func CreateCustomerAccount() -> Bool {
        var chk : Bool = false
        
        self.db?.collection("User").document(uid).setData(dictionaryRepresentation) { err in
            if ( err == nil )
            {
                chk = true
            }
        }
        
        return chk
    }
    
    func ShowMessage(msg : String) -> Void {
        let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
