//
//  FloatingTextview.swift
//  BidInCar
//
//  Created by Keyur on 17/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class FloatingTextview: UIView, UITextViewDelegate {

    @IBOutlet weak var myLbl: Label!
    @IBOutlet weak var myTxt: TextView!
    
    static let shared = FloatingTextfiledView()
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        xibSetup()
    }
    
    var view: UIView!
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: FloatingTextview.self)
        let nib = UINib(nibName: "FloatingTextview", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func xibSetup() {
        let view = loadViewFromNib()
        view.backgroundColor = colorFromHex(hex: "FFFFFF")
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        if myTxt != nil {
            myLbl.isHidden = false
        }
    }
    
    @IBInspectable open var placeholder: String = "" {
        didSet {
            if myTxt != nil {
//                myTxt.placeholder = placeholder.decoded
                myLbl.text = getTranslate(placeholder.decoded)
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        myLbl.isHidden = false
//        myTxt.placeholder = ""
        myTxt.layer.borderColor = PurpleColor.cgColor
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        myLbl.isHidden = (textView.text == "")
//        myTxt.placeholder = (textView.text == "") ? placeholder : ""
        myTxt.layer.borderColor = (textView.text == "") ? LightGrayColor.cgColor : PurpleColor.cgColor
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
