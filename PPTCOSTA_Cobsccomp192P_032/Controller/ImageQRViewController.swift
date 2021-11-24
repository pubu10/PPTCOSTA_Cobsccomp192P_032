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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let type = UIImagePickerController.SourceType.photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = type
        //picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        self.present(picker, animated: true)
        
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "RegistrationID" : ""]
        
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
        
        
        self.db.collection("Slots").document(qrCodeLink).setData(dictionaryRepresentation) { err in
            if ( err == nil )
            {
                self.ShowMessage(msg:"Success.");
                picker.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.ShowMessage(msg:"Failed.");
            }
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("Canceled.")
        
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

