//
//  HomeViewController.swift
//  PPTCOSTA_Cobsccomp192P_032
//
//  Created by pubudu tharuka on 2021-11-17.
//

import UIKit
import Firebase

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    public var db: Firestore?
    
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
        
        let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell
        
        cell.SlotName.text = self.SlotName[indexPath.row]
        cell.SlotStatus.text = self.SlotStatus[indexPath.row]
        cell.VehicalNo.text = self.VehicalNo[indexPath.row]
        
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
