//
//  SignUpViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-14.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // @IBOutlet weak var txtName: UITextField!
   // @IBOutlet weak var txtNicNo: UITextField!
   // @IBOutlet weak var txtVehicalNo: UITextField!
   // @IBOutlet weak var txtPassword: UITextField!
   // @IBOutlet weak var txtRePassword: UITextField!
   // @IBOutlet weak var txtEmal: UITextField!
   // @IBOutlet weak var txtRegNo: UITextField!
    
    @IBOutlet weak var txtRegNo: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNicNo: UITextField!
    @IBOutlet weak var txtVehicalNo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var chk: UISwitch!
    @IBOutlet weak var btnSignUp: UIButton!
    
    public var db: Firestore? //Property Injection
    
    var uid : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore .firestore()
        
        GetNextRegId();
       
        
    }
    
    @IBAction func btnSignUp_Click(_ sender: Any) {
        
        if(chk.isOn)
        {
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) {  authResult, error in
                
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
            "RegistrationID" : txtRegNo.text!,
            "UserId" : uid,
            "Name" : txtName.text!,
            "NicNo" : txtNicNo.text!,
            "Email" : txtEmail.text!,
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
    
    func GetNextRegId() -> Void {
        
        var MaxId = 0
        
        let citiesRef = db!.collection("User")
        citiesRef.order(by: "RegistrationID", descending: true).limit(to: 1).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    MaxId  =   Int(document.get("RegistrationID") as! String) ?? 0
                   
                }
                MaxId = (MaxId + 1)
                self.txtRegNo.text = String(MaxId)
                self.txtEmail.becomeFirstResponder()
            }
            
        }
       
    }
    
    func ShowMessage(msg : String) -> Void {
        let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
