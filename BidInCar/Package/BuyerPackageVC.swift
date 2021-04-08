//
//  BuyerPackageVC.swift
//  BidInCar
//
//  Created by Keyur on 08/04/21.
//  Copyright © 2021 Amisha. All rights reserved.
//

import UIKit

class BuyerPackageVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var headerView: UIView!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToCheckout(_ sender: Any) {
        
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

//MARK:- Tableview Method
extension BuyerPackageVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "BuyerPackageTVC", bundle: nil), forCellReuseIdentifier: "BuyerPackageTVC")
        tblView.tableHeaderView = headerView
        tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BuyerPackageTVC = tblView.dequeueReusableCell(withIdentifier: "BuyerPackageTVC") as! BuyerPackageTVC
        cell.topImg.isHidden = false
        cell.bottomImg.isHidden = false
        if indexPath.row == 0 {
            cell.topImg.isHidden = true
        }
        else if indexPath.row == 4 {
            cell.bottomImg.isHidden = true
        }
        if indexPath.row == selectedIndex {
            cell.selectView.backgroundColor = BlueColor
        }else{
            cell.selectView.backgroundColor = LightGrayColor
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tblView.reloadData()
    }
}

