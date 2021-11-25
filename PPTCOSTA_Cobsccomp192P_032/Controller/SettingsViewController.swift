//
//  SettingsViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-15.
//

import UIKit
import Firebase
import FirebaseFirestore

class SettingsViewController: UIViewController {

    public var db: Firestore?
    
    @IBOutlet weak var txtRegNo: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtNicNo: UITextField!
    
    @IBOutlet weak var txtVehicalNo: UITextField!
    
    @IBOutlet weak var btnLogOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        btnLogOut.layer.cornerRadius = 20
        btnLogOut.clipsToBounds = true
        
        self.db = Firestore .firestore()
        GetSettings()
        
    }
    
    @IBAction func btnLogout_Click(_ sender: Any) {
    }
    
    
    func GetSettings() -> Void {
        
        let userID = Auth.auth().currentUser?.uid
        let docRef = self.db?.collection("User").document(userID!)
        docRef!.getDocument(source: .cache) { (document, error) in
          if let document = document {
            
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            
            self.txtName.text = String(document.get("Name") as! String)
            self.txtEmail.text = String(document.get("Email") as! String)
            self.txtVehicalNo.text = String(document.get("VehicalNo") as! String)
            self.txtNicNo.text = String(document.get("NicNo") as! String)
            self.txtRegNo.text =  "test" //String(document.get("RegistrationID") as! String)
            
          } else {
            print("Document does not exist in cache")
          }
        }
      
    }

}
