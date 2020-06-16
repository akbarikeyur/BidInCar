//
//  PrivacyPolicyVC.swift
//  BidInCar
//
//  Created by Keyur on 21/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var titleLbl: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if screenType == 0 {
            titleLbl.text = "Privacy Policy"
        }
        else if screenType == 1 {
            titleLbl.text = "Terms and Conditions"
        }
        
        tblView.register(UINib.init(nibName: "CustomPrivacyPolicyTVC", bundle: nil), forCellReuseIdentifier: "CustomPrivacyPolicyTVC")
    }
    
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    //MARK:- Tableview Methid
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomPrivacyPolicyTVC = tblView.dequeueReusableCell(withIdentifier: "CustomPrivacyPolicyTVC") as! CustomPrivacyPolicyTVC
        
        if indexPath.row == 0 {
            cell.titleLbl.text = "Where does it come from?"
        }else if indexPath.row == 1 {
            cell.titleLbl.text = titleLbl.text
        }else if indexPath.row == 2 {
            cell.titleLbl.text = "Where can I get some?"
        }
        cell.descLbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long."
        cell.contentView.backgroundColor = WhiteColor
        cell.selectionStyle = .none
        return cell
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
