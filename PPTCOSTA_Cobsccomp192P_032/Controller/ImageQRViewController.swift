//
//  ImageQRViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-23.
//https://stackoverflow.com/questions/24844086/how-to-scan-qr-code-from-an-image-picked-with-uiimagepickercontroller-in-ios/40254225
//

import UIKit
import AVFoundation
import Firebase

class ImageQRViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var imagePicker = UIImagePickerController()
    var db = Firestore .firestore()
    
    
    @IBOutlet weak var ImgQR: UIImageView!
    @IBOutlet weak var btnReTake: UIButton!
    @IBOutlet weak var btnConform: UIButton!
    
    public var QRText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.db = Firestore .firestore()
        LoadImagePopUp()
        
    }
    
    func LoadImagePopUp() -> Void {
        
        let type = UIImagePickerController.SourceType.photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = type
        //picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        self.present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                        context: nil,
                                        options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let ciImage = CIImage(image: pickedImage),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else { return }
        
        let qrCodeLink = features.reduce("") { $0 + ($1.messageString ?? "") }
        QRText = qrCodeLink
        ImgQR.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("Canceled.")
        
    }
    
    @IBAction func btnRetake_Click(_ sender: Any) {
        
        LoadImagePopUp()
    }
    
    @IBAction func btnConfrm_Click(_ sender: Any) {
        
        if(AvailableBookingViewController.SlotIDProperty != QRText)
        {
            self.ShowMessage(msg:"QR Code not Match with the Selected Slot.");
            return
        }
        
        
        if(AvailableBookingViewController.BtnTypeProperty == "Booking" )
        {
            let date = Date()
            let calendar = Calendar.current
            
            let hour = String(calendar.component(.hour, from: date))
            let minutes = String(calendar.component(.minute, from: date))
            
            var time : String = ""
            time = hour + " hr " + minutes + " min "
            
            let userID = Auth.auth().currentUser?.uid
            let docRef = self.db.collection("User").document(userID!)
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document {
                    _ = document.data().map(String.init(describing:)) ?? "nil"
                    let vNo : String = String(document.get("VehicalNo") as! String)
                    self.db.collection("Slots").document(self.QRText).setData([ "AssignUser": userID ?? "" , "SlotTime" : time , "VehicalNo" : vNo , "SlotStatus": "3" ], merge: true) { err in
                        if ( err == nil )
                        {
                            self.ShowMessage(msg:"Booking Successflly.");
                        }
                        else
                        {
                            self.ShowMessage(msg:"Failed.");
                        }
                    }
                    
                } else {
                    print("Document does not exist in cache")
                }
            }
            
        }
        else  if(AvailableBookingViewController.BtnTypeProperty == "Cancel" )
        {
            self.db.collection("Slots").document(self.QRText).setData([ "AssignUser": "" , "SlotTime" : "" , "VehicalNo" : "" , "SlotStatus": "1" ], merge: true) { err in
                if ( err == nil )
                {
                    self.ShowMessage(msg:"Canceled Successflly.");
                }
                else
                {
                    self.ShowMessage(msg:"Failed.");
                }
            }
            
        }
        
        
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "tbBarController") as! UITabBarController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    
    
    func ShowMessage(msg : String) -> Void {
        let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

