//
//  NotificationVC.swift
//  BidInCar
//
//  Created by Keyur on 16/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    
    var arrData = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.register(UINib.init(nibName: "CustomNotificationTVC", bundle: nil), forCellReuseIdentifier: "CustomNotificationTVC")
        serviceCallToGetNotification()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tablewview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomNotificationTVC = tblView.dequeueReusableCell(withIdentifier: "CustomNotificationTVC") as! CustomNotificationTVC
        let dict = arrData[indexPath.row]
        cell.titleLbl.text = dict.auction_title
        cell.messageLbl.text = dict.message
        cell.timeLbl.text = dict.createdon
        if let date = getDateFromDateString(strDate: dict.createdon, format: "YYYY-MM-dd") {
            if let strDate : String = getDateStringFromDate(date: date, format: "d MMM, yyyy") {
                cell.timeLbl.text = strDate
            }
        }
        cell.newBtn.isHidden = (dict.status == "read")
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

extension NotificationVC {
    func serviceCallToGetNotification() {
        APIManager.shared.serviceCallToGetNotification { (dict) in
            self.arrData = [NotificationModel]()
            if let data = dict["data"] as? [[String : Any]] {
                for temp in data {
                    self.arrData.append(NotificationModel.init(dict: temp))
                }
            }
            self.tblView.reloadData()
        }
    }
}
