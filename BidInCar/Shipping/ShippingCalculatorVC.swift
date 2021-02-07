//
//  ShippingCalculatorVC.swift
//  BidInCar
//
//  Created by Keyur on 18/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

class ShippingCalculatorVC: UIViewController {

    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var flag1Img: UIImageView!
    @IBOutlet weak var country1Lbl: Label!
    @IBOutlet weak var flag2Img: UIImageView!
    @IBOutlet weak var country2Lbl: Label!
    
    var arrCountryData = getCountryData()
    var selectedCountry1 = CountryModel.init()
    var selectedCountry2 = CountryModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        priceLbl.text = "0"
        flag1Img.image = nil
        flag2Img.image = nil
        country1Lbl.text = getTranslate("select_country")
        country2Lbl.text = getTranslate("select_country")
    }
    
    @IBAction func clickToSelectFirstCountry(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCountryData {
            arrData.append(temp.country_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCountry1 = self.arrCountryData[index]
            self.country1Lbl.text = self.selectedCountry1.country_name
            setImageViewImage(self.flag1Img, self.selectedCountry1.flag, "")
            self.serviceCallToGetShippingPrice()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectSecondCountry(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCountryData {
            arrData.append(temp.country_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCountry2 = self.arrCountryData[index]
            self.country2Lbl.text = self.selectedCountry2.country_name
            setImageViewImage(self.flag2Img, self.selectedCountry2.flag, "")
            self.serviceCallToGetShippingPrice()
        }
        dropDown.show()
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    func serviceCallToGetShippingPrice()
    {
        if selectedCountry1.countryid != "" && selectedCountry2.countryid != "" {
            var param = [String : Any]()
            param["countryfrom"] = selectedCountry1.countryid
            param["countryto"] = selectedCountry2.countryid
            APIManager.shared.serviceCallToGetShippingPrice(param) { (data) in
                if let price = data["price"] as? String {
                    self.priceLbl.text = price
                }
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
