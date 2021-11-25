//
//  ResetPasswordViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-25.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnReset: UIButton!
    
    public var db: Firestore? //Property Injection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore .firestore()
        btnReset.layer.cornerRadius = 20
        btnReset.clipsToBounds = true
    }
    
    
    @IBAction func btnReset_Click(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: txtEmail?.text! ?? "") { error in
            self.ShowMessage(msg: "Password Reset Sent.");
                    }
        
    }
    
    func ShowMessage(msg : String) -> Void {
        let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
