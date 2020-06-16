//
//  CarPaymentVC.swift
//  BidInCar
//
//  Created by Keyur on 23/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CarPaymentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var paymentCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var arrLogoImg = ["visa", "mastercard", "mestro"]
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        paymentCV.register(UINib.init(nibName: "CustomCardCVC", bundle: nil), forCellWithReuseIdentifier: "CustomCardCVC")
        pageControl.numberOfPages = arrLogoImg.count
    }
    
    //MARK:- Collectionview Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLogoImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomCardCVC = paymentCV.dequeueReusableCell(withReuseIdentifier: "CustomCardCVC", for: indexPath) as! CustomCardCVC
        cell.logoImg.image = UIImage.init(named: arrLogoImg[indexPath.row])
        if indexPath.row == selectedIndex {
            cell.yellowView.backgroundColor = YellowColor
            cell.grayView.isHidden = false
        }else{
            cell.yellowView.backgroundColor = LightBGColor
            cell.grayView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        pageControl.currentPage = selectedIndex
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToPayNow(_ sender: Any) {
        let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
        self.navigationController?.pushViewController(vc, animated: true)
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
