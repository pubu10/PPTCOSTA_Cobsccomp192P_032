//
//  ReserveViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-25.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import Firebase

class ReserveViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var db = Firestore .firestore()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //My location
        let myLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        //My Next Destination
        let myNextDestination = CLLocation(latitude: 6.906762440116351, longitude: 79.87069437521194)
        //Finding my distance to my next destination (in km)
        let distance = myLocation.distance(from: myNextDestination) / 1000
        print("locations = \(distance)")
        locationManager.stopUpdatingLocation()
        
        if(distance > 1)
        {
            ShowMessage(msg: "You need 1km range to Reserve your Parking")
            return
        }
        else
        {
           
            var ID : String = AvailableBookingViewController.typeProperty;
            
            
            // Update one field, creating the document if it does not exist.
            self.db.collection("Slots").document(ID).setData([ "SlotStatus": "2" ], merge: true) { err in
                if ( err == nil )
                {
                    self.ShowMessage(msg:"Success.");
                }
                else
                {
                    self.ShowMessage(msg:"Failed.");
                }
            }
        }
        
        return
    }
    
    func ShowMessage(msg : String) -> Void {
        let alert = UIAlertController(title: "Info", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "SlotStatus" : "2"]
        
    }
    
    
}
