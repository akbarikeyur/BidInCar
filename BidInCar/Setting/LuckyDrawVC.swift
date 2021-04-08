//
//  LuckyDrawVC.swift
//  BidInCar
//
//  Created by Keyur on 08/04/21.
//  Copyright © 2021 Amisha. All rights reserved.
//

import UIKit

class LuckyDrawVC: UIViewController {

    @IBOutlet weak var yearLbl: Label!
    @IBOutlet weak var quarterCV: UICollectionView!
    @IBOutlet weak var winnerLbl: Label!
    @IBOutlet weak var amountLbl: Label!
    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var quarterLbl: Label!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constraintHeightTblView: NSLayoutConstraint!
    
    var arrTab = ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4"]
    var selectedTab = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCollectionView()
        registerTableViewMethod()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToNextPrevious(_ sender: UIButton) {
        if sender.tag == 1 {
            
        }
        else if sender.tag == 2 {
            
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

}

//MARK:- CollectionView Method
extension LuckyDrawVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func registerCollectionView() {
        quarterCV.register(UINib.init(nibName: "QuarterTabCVC", bundle: nil), forCellWithReuseIdentifier: "QuarterTabCVC")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : QuarterTabCVC = quarterCV.dequeueReusableCell(withReuseIdentifier: "QuarterTabCVC", for: indexPath) as! QuarterTabCVC
        cell.titleLbl.text = arrTab[indexPath.row]
        cell.lineImg.isHidden = (selectedTab != indexPath.row)
        if selectedTab == indexPath.row {
            cell.titleLbl.alpha = 1.0
        }else{
            cell.titleLbl.alpha = 0.7
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTab = indexPath.row
        quarterCV.reloadData()
    }
}

//MARK:- Tableview Method
extension LuckyDrawVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: "LuckyDrawUserTVC", bundle: nil), forCellReuseIdentifier: "LuckyDrawUserTVC")
        updateTblHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LuckyDrawUserTVC = tblView.dequeueReusableCell(withIdentifier: "LuckyDrawUserTVC") as! LuckyDrawUserTVC
        cell.topView.isHidden = (indexPath.row > 0)
        cell.noLbl.text = getNumber(String(indexPath.row+1))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func getNumber(_ value : String) -> String {
        if value.count == 1 {
            return "00" + value
        }
        else if value.count == 2 {
            return "0" + value
        }
        else{
            return value
        }
    }
    
    func updateTblHeight() {
        constraintHeightTblView.constant = CGFloat.greatestFiniteMagnitude
        tblView.reloadData()
        tblView.layoutIfNeeded()
        constraintHeightTblView.constant = tblView.contentSize.height
    }
}

