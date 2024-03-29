//
//  ContactUsVC.swift
//  BidInCar
//
//  Created by Keyur on 17/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown
import MapKit

class ContactUsVC: UploadImageVC {

    @IBOutlet weak var nameTxtView: FloatingTextfiledView!
    @IBOutlet weak var emailTxtView: FloatingTextfiledView!
    @IBOutlet weak var phoneTxtView: FloatingTextfiledView!
    @IBOutlet weak var interestedTxtView: FloatingTextfiledView!
    @IBOutlet weak var commentTxtView: FloatingTextview!
    @IBOutlet weak var attachBtn: Button!
    @IBOutlet weak var deleteBtn: Button!
    @IBOutlet var sucessView: UIView!
    @IBOutlet weak var addressMapView: MKMapView!
    @IBOutlet weak var fileAttachLbl: Label!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTxtView.myTxt.keyboardType = .emailAddress
        phoneTxtView.myTxt.keyboardType = .phonePad
        fileAttachLbl.isHidden = true
        if isUserLogin() {
            nameTxtView.myTxt.text = AppModel.shared.currentUser.user_name
            emailTxtView.myTxt.text = AppModel.shared.currentUser.user_email
            phoneTxtView.myTxt.text = AppModel.shared.currentUser.user_phonenumber
        }
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: 25.298063, longitude:55.392986)
        annotation.coordinate = centerCoordinate
        annotation.title = ""
        addressMapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        addressMapView.setRegion(addressMapView.regionThatFits(region), animated: true)
        
        fileAttachLbl.isHidden = true
        deleteBtn.isHidden = true
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }

    @IBAction func clickToSelectInterest(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = [getTranslate("interest_deposit"), getTranslate("interest_account"), getTranslate("interest_payment"), getTranslate("interest_billing"), getTranslate("interest_featured"), getTranslate("interest_document_featured"), getTranslate("interest_shipment"), getTranslate("interest_others")]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.interestedTxtView.myTxt.text = item
        }
        dropDown.show()
    }
    
    @IBAction func clickToAttach(_ sender: Any) {
        self.view.endEditing(true)
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        selectedImage = choosenImage
        fileAttachLbl.isHidden = false
        deleteBtn.isHidden = false
    }
    
    @IBAction func clickToRemoveImage(_ sender: Any) {
        selectedImage = nil
        fileAttachLbl.isHidden = true
        deleteBtn.isHidden = true
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
        if nameTxtView.myTxt.text?.trimmed == "" {
            displayToast("enter_name")
        }
        else if emailTxtView.myTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if !emailTxtView.myTxt.text!.isValidEmail {
            displayToast("invalid_email")
        }
        else if phoneTxtView.myTxt.text?.trimmed == "" {
            displayToast("enter_phone")
        }
        else if interestedTxtView.myTxt.text?.trimmed == "" {
            displayToast("select_interest")
        }
        else if commentTxtView.myTxt.text?.trimmed == "" {
            displayToast("add_comment")
        }
        else{
            addButtonEvent(EVENT.TITLE.CONTACT_ADMIN, EVENT.ACTION.CONTACT_ADMIN, String(describing: self))
            if selectedImage != nil {
                uploadContactFile()
            }else{
                serviceCallToContactUs("")
            }
        }
    }
    
    func uploadContactFile()
    {
        APIManager.shared.serviceCallToUploadContactUs(selectedImage!) { (path) in
            self.serviceCallToContactUs(path)
        }
    }
    
    func serviceCallToContactUs(_ path : String)
    {
        var param = [String : Any]()
        param["name"] = nameTxtView.myTxt.text
        param["email"] = emailTxtView.myTxt.text
        param["phonenumber"] = phoneTxtView.myTxt.text
        param["interestedin"] = interestedTxtView.myTxt.text
        param["comment"] = commentTxtView.myTxt.text
        if path != "" {
            param["contact_upload"] = path
        }
        
        APIManager.shared.serviceCallToContactUs(param) {
            displaySubViewtoParentView(self.view, subview: self.sucessView)
        }
    }
    
    @IBAction func clickToHome(_ sender: UIButton) {
        sucessView.removeFromSuperview()
        let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
    }
    
    @IBAction func clickToMyAuction(_ sender: UIButton) {
        sucessView.removeFromSuperview()
        let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "MyAuctionSellerVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
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
