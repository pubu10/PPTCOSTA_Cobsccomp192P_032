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
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    var SlotName = [String]()
    var SlotStatus = [String]()
    var VehicalNo = [String]()
    
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.db = Firestore .firestore()
        
        self.db?.collection("Slots").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.SlotName.append(document.get("SlotName") as! String)
                    self.SlotStatus.append(document.get("SlotStatus") as! String)
                    self.VehicalNo.append(document.get("VehicalNo") as! String)
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
        cell.SlotStatus.text = self.SlotStatus[indexPath.row]
        //cell.VehicalNo.text = self.VehicalNo[indexPath.row]
        
        cell.btnReserve.tag = indexPath.row;
        cell.btnReserve.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        cell.btnBooking.tag = indexPath.row;
        cell.btnBooking.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    @objc func buttonTapped(_sender: UIButton)
    {
        let alrt = UIAlertController(title: "test", message: "test", preferredStyle: .alert)
        alrt.addAction(UIAlertAction(title: "ok",style: .cancel,handler: nil))
        self.present(alrt, animated: true)
        
    
        
    }
    
    @objc func buttonTapped2(_sender: UIButton)
    {
        let alrt = UIAlertController(title: "test2", message: "test2", preferredStyle: .alert)
        alrt.addAction(UIAlertAction(title: "ok",style: .cancel,handler: nil))
        self.present(alrt, animated: true)
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}


