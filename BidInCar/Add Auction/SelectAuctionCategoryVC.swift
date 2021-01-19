//
//  SelectAuctionCategoryVC.swift
//  BidInCar
//
//  Created by Keyur on 06/04/20.
//  Copyright © 2020 Keyur. All rights reserved.
//

import UIKit

class SelectAuctionCategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoryCV: UICollectionView!
    
    var selectedType = AuctionTypeModel.init(dict: [String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryCV.register(UINib.init(nibName: "CustomCategoryCVC", bundle: nil), forCellWithReuseIdentifier: "CustomCategoryCVC")
        serviceCallToGetAuctionCategoryList()
    }
    
    //MARK: - Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    @IBAction func clickToNext(_ sender: Any) {
        if selectedType.id == 0 || selectedType.id == -1 {
            displayToast("select_auction_type")
        }else{
            let vc : PostCarAuctionVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostCarAuctionVC") as! PostCarAuctionVC
            vc.selectedAuctionType = selectedType
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppModel.shared.AUCTION_TYPE.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomCategoryCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "CustomCategoryCVC", for: indexPath) as! CustomCategoryCVC
        
        let dict = AppModel.shared.AUCTION_TYPE[indexPath.row]
        setButtonImage(cell.cateBtn, dict.img)
        cell.catLbl.text = dict.name
        if selectedType.id == dict.id {
            cell.cateBtn.tintColor = WhiteColor
            cell.catLbl.textColor = WhiteColor
            cell.outerView.backgroundColor = BlueColor
        }else{
            cell.cateBtn.tintColor = LightGrayColor
            cell.catLbl.textColor = LightGrayColor
            cell.outerView.backgroundColor = WhiteColor
        }
        cell.cateBtn.isUserInteractionEnabled = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedType = AppModel.shared.AUCTION_TYPE[indexPath.row]
        categoryCV.reloadData()
    }

    //MARK:- Service called
    func serviceCallToGetAuctionCategoryList()
    {
        if AppModel.shared.AUCTION_TYPE.count == 0 {
            APIManager.shared.serviceCallToGetAuctionCategoryList { (data) in
                AppModel.shared.AUCTION_TYPE = [AuctionTypeModel]()
                for temp in data {
                    AppModel.shared.AUCTION_TYPE.append(AuctionTypeModel.init(dict: temp))
                }
                self.categoryCV.reloadData()
            }
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
