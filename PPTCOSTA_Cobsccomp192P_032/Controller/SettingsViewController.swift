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
    
 
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.db = Firestore .firestore()
        //self.txtName!.text = "pubudu"//String(document.get("Name") as! String)
        GetSettings()
        // Do any additional setup after loading the view.
    }
    
    
    func GetSettings() -> Void {
        
        let userID = Auth.auth().currentUser?.uid
        let docRef = self.db?.collection("User").document(userID!)
        docRef!.getDocument(source: .cache) { (document, error) in
          if let document = document {
            
           // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
           //self.txtName.text = "pubudu"//String(document.get("Name") as! String)
           // self.txtEmal.text = "w"//String(document.get("Email") as! String)
           // self.txtVehicalNo.text = "w"//String(document.get("VehicalNo") as! String)
            
            
          } else {
            print("Document does not exist in cache")
          }
        }
      
    }

}
