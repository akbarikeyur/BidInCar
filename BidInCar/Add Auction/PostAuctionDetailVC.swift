//
//  PostAuctionDetailVC.swift
//  BidInCar
//
//  Created by Keyur on 22/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class PostAuctionDetailVC: UIViewController {

    @IBOutlet weak var milageLbl: Label!
    
    @IBOutlet weak var imgBtn1: Button!
    @IBOutlet weak var imgBtn2: Button!
    @IBOutlet weak var imgBtn3: Button!
    @IBOutlet weak var imgBtn4: Button!
    @IBOutlet weak var imgBtn5: Button!
    @IBOutlet weak var imgBtn6: Button!
    @IBOutlet weak var imgBtn7: Button!
    
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var minBidLbl: Label!
    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var makeLbl: Label!
    @IBOutlet weak var conditionLbl: Label!
    @IBOutlet weak var yearLbl: Label!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var startDateLbl: Label!
    @IBOutlet weak var endDateLbl: Label!
    @IBOutlet weak var transmissionView: UIView!
    @IBOutlet weak var transmissionLbl: Label!
    @IBOutlet weak var fuelTypeLbl: Label!
    @IBOutlet weak var vinView: UIView!
    @IBOutlet weak var vinLbl: Label!
    @IBOutlet weak var bodyTypeLbl: Label!
    @IBOutlet weak var countryLbl: Label!
    @IBOutlet weak var motorLbl: Label!
    @IBOutlet weak var colorLbl: Label!
    @IBOutlet weak var addressLbl: Label!
    @IBOutlet weak var latitudeLbl: Label!
    @IBOutlet weak var longitudeLbl: Label!
    @IBOutlet weak var descLbl: Label!
    @IBOutlet weak var termsLbl: Label!
    @IBOutlet weak var checkUploadView: UIView!
    @IBOutlet var packageView: UIView!
    
    @IBOutlet weak var bodyTypeView: UIView!
    @IBOutlet weak var motorView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var mechanicalView: UIView!
    @IBOutlet weak var mechanicalLbl: Label!
    @IBOutlet weak var wheelView: UIView!
    @IBOutlet weak var wheelLbl: Label!
    @IBOutlet weak var driveSystemView: UIView!
    @IBOutlet weak var driveSystemLbl: Label!
    @IBOutlet weak var engineSizeView: UIView!
    @IBOutlet weak var engineSizeLbl: Label!
    @IBOutlet weak var bodyConditionView: UIView!
    @IBOutlet weak var bodyConditionLbl: Label!
    
    @IBOutlet weak var boatLengthView: UIView!
    @IBOutlet weak var boatLengthLbl: Label!
    @IBOutlet weak var termsConditionLbl: Label!
    
    
    var myAuction = AuctionModel.init()
    var selectedAuctionType = AuctionTypeModel.init(dict: [String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateView.isHidden = true
        termsConditionLbl.attributedText = getAttributeStringWithColor(termsConditionLbl.text!, [termsConditionLbl.text!], color: UIColor.blue, font: termsConditionLbl.font, isUnderLine: true)
        setUIDesigning()
        delay(2.0) {
            self.serviceCallToGetAuctionDetail()
        }
    }
    
    func setUIDesigning() {
        
        if selectedAuctionType.id == -1 {
            selectedAuctionType.id = myAuction.cattype
        }
        
        titleLbl.text = ""
        priceLbl.text = ""
        minBidLbl.text = ""
        categoryLbl.text = ""
        makeLbl.text = ""
        conditionLbl.text = ""
        yearLbl.text = ""
        startDateLbl.text = ""
        endDateLbl.text = ""
        transmissionLbl.text = ""
        fuelTypeLbl.text = ""
        vinLbl.text = ""
        bodyTypeLbl.text = ""
        countryLbl.text = ""
        motorLbl.text = ""
        colorLbl.text = ""
        addressLbl.text = ""
        latitudeLbl.text = ""
        longitudeLbl.text = ""
        descLbl.text = ""
        mechanicalLbl.text = ""
        wheelLbl.text = ""
        driveSystemLbl.text = ""
        engineSizeLbl.text = ""
        bodyConditionLbl.text = ""
        boatLengthLbl.text = ""
        
        termsLbl.text = ""
        hideViewBasedOnAuctionType()
        setupData()
    }
    
    func hideViewBasedOnAuctionType()
    {
        transmissionView.isHidden = true
        vinView.isHidden = true
        bodyTypeView.isHidden = true
        motorView.isHidden = true
        colorView.isHidden = true
        mechanicalView.isHidden = true
        wheelView.isHidden = true
        driveSystemView.isHidden = true
        engineSizeView.isHidden = true
        boatLengthView.isHidden = true
        colorView.isHidden = true
        
        if selectedAuctionType.id == 1 {
            transmissionView.isHidden = false
            vinView.isHidden = false
            bodyTypeView.isHidden = false
//            motorView.isHidden = false
            colorView.isHidden = false
            mechanicalView.isHidden = false
        }else{
            mechanicalView.isHidden = false
            if selectedAuctionType.id == 2 {
                wheelView.isHidden = false
                driveSystemView.isHidden = false
                engineSizeView.isHidden = false
            }else if selectedAuctionType.id == 3 {
                boatLengthView.isHidden = false
            }
            else if selectedAuctionType.id == 4 {
                motorView.isHidden = false
            }
        }
    }
    
    func setupData()
    {
        titleLbl.text = myAuction.auction_title
        priceLbl.text = myAuction.auction_price
        minBidLbl.text = myAuction.auction_bidprice
        yearLbl.text = myAuction.year
        priceLbl.text = myAuction.auction_price
        categoryLbl.text = myAuction.category_name
        makeLbl.text = myAuction.catchild_name
        startDateLbl.text = myAuction.auction_start
        endDateLbl.text = myAuction.auction_end
        conditionLbl.text = myAuction.body_condition
        vinLbl.text = myAuction.auction_vin
        transmissionLbl.text = myAuction.auction_transmission
        fuelTypeLbl.text = myAuction.auction_fueltype
        bodyTypeLbl.text = myAuction.auction_bodytype
        motorLbl.text = myAuction.auction_motorno
        colorLbl.text = myAuction.auction_extcolour
        milageLbl.text = myAuction.auction_millage + " MI"
        milageLbl.attributedText = attributedStringWithColor(milageLbl.text!, ["MI"], color: PurpleColor)
        descLbl.text = myAuction.auction_desc
        latitudeLbl.text = myAuction.auction_lat
        longitudeLbl.text = myAuction.auction_long
        addressLbl.text = myAuction.auction_address
        countryLbl.text = myAuction.country_name
        mechanicalLbl.text = myAuction.mechanical
        wheelLbl.text = myAuction.wheels
        driveSystemLbl.text = myAuction.drive_system
        engineSizeLbl.text = myAuction.engine_size
        bodyConditionLbl.text = myAuction.body_condition
        boatLengthLbl.text = myAuction.boat_length
        
        checkUploadView.isHidden = true
        for temp in myAuction.pictures {
            if temp.type == "auto_check" {
                checkUploadView.isHidden = false
                break
            }
        }
        
        if myAuction.auctionid != "" && myAuction.auctionid != "0" {
            var pictureData : [PictureModel] = myAuction.pictures
            for temp in myAuction.removePicture {
                let index = pictureData.firstIndex(where: { (tempPic) -> Bool in
                    tempPic.apid == temp
                })
                if index != nil {
                    pictureData.remove(at: index!)
                }
            }
            
            for i in 0..<pictureData.count
            {
                if i == 0 {
                    setButtonBackgroundImage(imgBtn1, pictureData[i].path, IMAGE.AUCTION_PLACEHOLDER)
                }else if i == 1 {
                    setButtonBackgroundImage(imgBtn2, pictureData[i].path, IMAGE.AUCTION_PLACEHOLDER)
                }else if i == 2 {
                    setButtonBackgroundImage(imgBtn3, pictureData[i].path, IMAGE.AUCTION_PLACEHOLDER)
                }else if i == 3 {
                    setButtonBackgroundImage(imgBtn4, pictureData[i].path, IMAGE.AUCTION_PLACEHOLDER)
                }else if i == 4 {
                    setButtonBackgroundImage(imgBtn5, pictureData[i].path, IMAGE.AUCTION_PLACEHOLDER)
                }else if i == 5 {
                    setButtonBackgroundImage(imgBtn6, pictureData[i].path, IMAGE.AUCTION_PLACEHOLDER)
                }else if i == 6 {
                    setButtonBackgroundImage(imgBtn7, pictureData[i].path, IMAGE.AUCTION_PLACEHOLDER)
                }
            }
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        var isRedirect = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MyAuctionSellerVC.self) {
                isRedirect = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        if !isRedirect {
            AppDelegate().sharedDelegate().navigateToDashBoard()
        }
    }
    
    @IBAction func clickToViewReport(_ sender: Any) {
        self.view.endEditing(true)
        for temp in myAuction.pictures {
            if temp.type == "auto_check" && temp.path != ""{
                openUrlInSafari(strUrl: temp.path)
                break
            }
        }
    }
    
    @IBAction func clickToTermsConditions(_ sender: Any) {
        self.view.endEditing(true)
        screenType = 1
        let vc : PrivacyPolicyVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.isBackDisplay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToActionPackageView(_ sender: UIButton) {
        packageView.removeFromSuperview()
        if sender.tag == 101 {
            let vc : PackageVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PackageVC") as! PackageVC
            vc.isFromAuction = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func clickToConfirm(_ sender: Any) {
        let data = getSellreTopData()
        let auctionsleft = AppModel.shared.getIntValue(data, "auctionsleft")
        var isPackageAvailable = false
        if auctionsleft > 0 {
            isPackageAvailable = true
        }
        
        if isPackageAvailable {
            APIManager.shared.serviceCallToConfirmAuction(["auctionid" : myAuction.auctionid!, "userid" : AppModel.shared.currentUser.userid!]) {
                if AppModel.shared.AUCTION_DATA[String(self.myAuction.categorytype)] != nil {
                    AppModel.shared.AUCTION_DATA[String(self.myAuction.categorytype)] = [AuctionModel]()
                }
                AppDelegate().sharedDelegate().serviceCallToDecreseLeftAuction()
                self.clickToBack(self)
            }
        }
        else{
            displaySubViewtoParentView(self.view, subview: packageView)
        }
    }
    
    func serviceCallToGetAuctionDetail()
    {
        APIManager.shared.serviceCallToGetAuctionDetail(myAuction.auctionid, false) { (data) in
            if let tempData : [String : Any] = data["auction"] as? [String : Any] {
                self.myAuction = AuctionModel.init(dict: tempData)
            }
            if let tempData : [[String : Any]] = data["pictures"] as? [[String : Any]], tempData.count > 0 {
                self.myAuction.pictures = [PictureModel]()
                for temp in tempData {
                    self.myAuction.pictures.append(PictureModel.init(dict: temp))
                }
            }
            self.setUIDesigning()
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
