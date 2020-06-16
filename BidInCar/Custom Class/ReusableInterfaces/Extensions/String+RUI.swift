//
//  String+RUI.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

extension String {
    public func length() -> Int{
        return self.lengthOfBytes(using: String.Encoding.utf8)
    }
    
    func equalsIgnoreCase (str : String) -> Bool {
        return self.compare(str, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) == .orderedSame
    }
    
    func sizeOfString (width: CGFloat, font : UIFont) -> CGSize {
        return NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                   attributes: [NSAttributedString.Key.font: font],
        context: nil).size
    }
    
    func insert(string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
    
    var removeExcessiveSpaces: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespaces)
        let filtered = components.filter({!$0.isEmpty})
        return filtered.joined(separator: " ")
    }
    
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidUrl : Bool {
//        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
//        let urlRegEx = "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    var checkPasswordStrength: Int {
        var strength = 0
        
        if NSPredicate(format:"SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$").evaluate(with: self) {
            strength = 1 //Minimum 8 characters at least 1 Alphabet and 1 Number:
        }
        if NSPredicate(format:"SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$").evaluate(with: self) {
            strength = 2 //Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
        }
        if NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}").evaluate(with: self) {
            strength = 3 //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character
        }
        if NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{10,}").evaluate(with: self) {
            strength = 4 //Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character
        }
        return strength
    }
    
    var trimmed:String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    var encoded:String{
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let data: Data? = str.data(using: String.Encoding.nonLossyASCII)
        let Value = String(data: data!, encoding: String.Encoding.utf8)
        return Value ?? ""
    }
    var urlEncoded:String{
        let data: Data? = self.data(using: String.Encoding.nonLossyASCII)
        let Value = String(data: data!, encoding: String.Encoding.utf8)
        return Value ?? ""
    }
    var decoded: String {
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let data: Data? = str.data(using: String.Encoding.utf8)
        let Value = String(data: data!, encoding: String.Encoding.nonLossyASCII)
        return Value ?? ""
    }
    var html2AttributedString: NSAttributedString {
        return Data(utf8).html2AttributedString ?? NSAttributedString()
    }
    var html2String: String {
        return html2AttributedString.string
    }
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}
