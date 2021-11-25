//
//  AvailableBookingViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-18.
//

import UIKit
import Firebase

//https://stevenpcurtis.medium.com/handle-button-presses-in-customuitableviewcells-without-tags-48941542447a
class AvailableBookingViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    public var db: Firestore?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtStringVehicalNo: UITextField!
    @IBOutlet weak var txtStringRegNo: UITextField!
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    static var SlotIDProperty = ""
    static var BtnTypeProperty = ""
    
    var SlotID = [String]()
    var SlotName = [String]()
    var SlotStatus = [String]()
     
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    
    
    func viewLoadSetup(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.db = Firestore .firestore()
        
        SlotID = [String]()
        SlotName = [String]()
        SlotStatus = [String]()
         
        let userID = Auth.auth().currentUser?.uid
        let docRef = self.db?.collection("User").document(userID!)
        docRef!.getDocument(source: .cache) { (document, error) in
          if let document = document {
            
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            
            self.txtStringVehicalNo.text = String(document.get("VehicalNo") as! String)
            self.txtStringRegNo.text =  "2"//String(document.get("RegistrationID") as! String)
            
          } else {
            print("Document does not exist in cache")
          }
        }

        
        self.db?.collection("Slots").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.SlotID.append(document.get("SlotID") as! String)
                    self.SlotName.append(document.get("SlotName") as! String)
                    self.SlotStatus.append(document.get("SlotStatus") as! String)
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SlotName.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // create a cell for each table view row  UITableViewCell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AvailableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AvailableCell
        
        cell.SlotName.text = self.SlotName[indexPath.row]
        cell.Status.text = self.SlotStatus[indexPath.row]
        
        cell.btnReserve.tag = Int(self.SlotID[indexPath.row])! ;
        cell.btnReserve.addTarget(self, action: #selector(btnReserveTapped), for: .touchUpInside)
        
        cell.btnBooking.tag = Int(self.SlotID[indexPath.row])!;
        cell.btnBooking.addTarget(self, action: #selector(btnBookingTapped), for: .touchUpInside)
        
        cell.btnCancel.tag = Int(self.SlotID[indexPath.row])!;
        cell.btnCancel.addTarget(self, action: #selector(btCancelTapped), for: .touchUpInside)
        
         if(self.SlotStatus[indexPath.row] == "1")
        {
            cell.btnReserve.isHidden = false
            cell.btnBooking.isHidden = false
            cell.btnCancel.isHidden = true
        }
        else if(self.SlotStatus[indexPath.row] == "2")
        {
            cell.btnReserve.isHidden = true
            cell.btnBooking.isHidden = false
            cell.btnCancel.isHidden = true
        }
        else if(self.SlotStatus[indexPath.row] == "3")
        {
            cell.btnReserve.isHidden = true
            cell.btnBooking.isHidden = true
            cell.btnCancel.isHidden = false
        }
        
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    @objc func btnReserveTapped(_sender: UIButton)
    {
        AvailableBookingViewController.SlotIDProperty = String(_sender.tag);
    }
    
    @objc func btnBookingTapped(_sender: UIButton)
    {
        AvailableBookingViewController.SlotIDProperty = String(_sender.tag);
        AvailableBookingViewController.BtnTypeProperty = "Booking";
    }
    
    @objc func btCancelTapped(_sender: UIButton)
    {
        AvailableBookingViewController.SlotIDProperty = String(_sender.tag);
        AvailableBookingViewController.BtnTypeProperty = "Cancel";
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}


