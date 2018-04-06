//
//  Extensions.swift
//  Student_GPA
//
//  Created by iOS Developer on 06/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import ObjectiveC

extension Reachability {
    public class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
public extension UITableView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
}
extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
//    convenience init(hex: Int) {
//        self.init(hex: hex, alpha: 1.0)
//    }
//     convenience init(hex: Int, alpha: Float) {
//        if (0x000000 ... 0xFFFFFF) ~= hex {
//            self.init(hex6: hex, alpha: alpha)
//        } else {
//            self.init()
//            return nil
//        }
//    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
}
extension UIViewController {
    
    func setNavigationBarItem() {
//        self.addLeftBarButtonWithImage(UIImage(named: "Notification")!) //ic_menu_black_24dp
//        self.addRightBarButtonWithImage(UIImage(named: "Notification")!)//ic_notifications_black_24dp
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
        let btNnewMessage = UIBarButtonItem(image: UIImage(named: "MessageTabIcon"), style: .plain, target: self, action: #selector(newMessagClick(_:)))// action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = btNnewMessage
    }
    @IBAction func newMessagClick(_ sender:UIBarButtonItem){
        self.performSegue(withIdentifier: "MessageVC", sender: nil)
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
}
extension UIImageView {
    
    func setRandomDownloadImage(_ width: Int, height: Int) {
        if self.image != nil {
            self.alpha = 1
            return
        }
        self.alpha = 0
        let url = URL(string: "http://lorempixel.com/\(width)/\(height)/")!
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode / 100 != 2 {
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.alpha = 1
                        }, completion: { (finished: Bool) -> Void in
                        })
                    })
                }
            }
        }
        task.resume()
    }
    
    func clipParallaxEffect(_ baseImage: UIImage?, screenSize: CGSize, displayHeight: CGFloat) {
        if let baseImage = baseImage {
            if displayHeight < 0 {
                return
            }
            let aspect: CGFloat = screenSize.width / screenSize.height
            let imageSize = baseImage.size
            let imageScale: CGFloat = imageSize.height / screenSize.height
            
            let cropWidth: CGFloat = floor(aspect < 1.0 ? imageSize.width * aspect : imageSize.width)
            let cropHeight: CGFloat = floor(displayHeight * imageScale)
            
            let left: CGFloat = (imageSize.width - cropWidth) / 2
            let top: CGFloat = (imageSize.height - cropHeight) / 2
            
            let trimRect : CGRect = CGRect(x: left, y: top, width: cropWidth, height: cropHeight)
            self.image = baseImage.trim(trimRect: trimRect)
            self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: displayHeight)
        }
    }
}
extension UIImage {
    func trim(trimRect :CGRect) -> UIImage {
        if CGRect(origin: CGPoint.zero, size: self.size).contains(trimRect) {
            if let imageRef = self.cgImage?.cropping(to: trimRect) {
                return UIImage(cgImage: imageRef)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.draw(in: CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
}


extension UIButton {
    
    /// show background as rounded rect, like mail addressees
    var rounded: Bool {
        get { return layer.cornerRadius > 0 }
        set { roundWithTitleSize(size: newValue ? titleSize : 0) }
    }
    
    /// removes other title attributes
    var titleSize: CGFloat {
        get {
            let titleFont = attributedTitle(for: .normal)?.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
            return titleFont?.pointSize ?? UIFont.buttonFontSize
        }
        set {
            // TODO: use current attributedTitleForState(.Normal) if defined
            if UIFont.buttonFontSize == newValue || 0 == newValue {
                setTitle(currentTitle, for: .normal)
            }
            else {
                let attrTitle = NSAttributedString(string: currentTitle ?? "", attributes:
                    [NSFontAttributeName: UIFont.systemFont(ofSize: newValue), NSForegroundColorAttributeName: currentTitleColor]
                )
                setAttributedTitle(attrTitle, for: .normal)
            }
            
            if rounded {
                roundWithTitleSize(size: newValue)
            }
        }
    }
    
    func roundWithTitleSize(size: CGFloat) {
        let padding = size / 4
        layer.cornerRadius = padding + size * 1.2 / 2
        let sidePadding = padding * 1.5
        contentEdgeInsets = UIEdgeInsets(top: padding, left: sidePadding, bottom: padding, right: sidePadding)
        
        if size.isZero {
            backgroundColor = UIColor.clear
            setTitleColor(tintColor, for: .normal)
        }
        else {
            backgroundColor = tintColor
            let currentTitleColor = titleColor(for: .normal)
            if currentTitleColor == nil || currentTitleColor == tintColor {
                setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        if rounded {
            backgroundColor = tintColor
        }
    }
    
}



extension CAShapeLayer {
    public func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}


extension String {
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return boundingBox.width
    }
    
    func calculateDynamicHeight(maxWidth:CGFloat, font:UIFont) -> CGRect
    {
        let textAttributes = [NSFontAttributeName:font]
        
        let iRectToReturn = self.boundingRect(with: CGSize(width:maxWidth,height: 9999), options: [.usesLineFragmentOrigin ,.usesFontLeading], attributes: textAttributes, context: nil)
        
        return iRectToReturn
    }
    
    /*func NSRangeFromRange(_ range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.lowerBound, within: utf16view)
        let to = String.UTF16View.Index(range.upperBound, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distance(to: from),from.distance(to: to))
        //return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    }*/
    
    mutating func dropTrailingNonAlphaNumericCharacters() {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        let characterArray = components(separatedBy: nonAlphaNumericCharacters)
        if let first = characterArray.first {
            self = first
        }
    }

}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}


extension UIBarButtonItem {
    convenience init(badge: String?, title: String, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        
        let badgeLabel = UILabel(badgeText: badge ?? "")
        button.addSubview(badgeLabel)
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0))
        if nil == badge {
            badgeLabel.isHidden = true
        }
        badgeLabel.tag = UIBarButtonItem.badgeTag
        
        self.init(customView: button)
    }
    
    var badgeLabel: UILabel? {
        return customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }
    
    var badgedButton: UIButton? {
        return customView as? UIButton
    }
    
    var badgeString: String? {
        get { return badgeLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)}
        set {
            if let badgeLabel = badgeLabel {
                badgeLabel.text = nil == newValue ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.isHidden = nil == newValue
            }
        }
    }
    
    var badgedTitle: String? {
        get { return badgedButton?.title(for: .normal) }
        set { badgedButton?.setTitle(newValue, for: .normal); badgedButton?.sizeToFit() }
    }
    
    private static let badgeTag = 7373
}


extension UIColor {
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red:r/255,green:g/255,blue:b/255,alpha:1)
    }
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) {
        self.init(red:r/255,green:g/255,blue:b/255,alpha:a)
    }
    
    
    public convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    fileprivate convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
    fileprivate convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    public convenience init?(hexString: String, alpha: Float) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
        }
        
        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }
        
        switch hex.characters.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }
    
    
}


extension UILabel
{
    func addBorderToBottomOfTextfield(borderColor:UIColor)
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = borderColor.cgColor
        print(self.frame.size.width)
        border.frame = CGRect(x: 0, y:self.frame.size.height+0, width:270.0, height: 1.0)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false,beforeText:String,afterText:String)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: 0.0, y: self.font.descender, width: attachment.image!.size.width, height: attachment.image!.size.height)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: beforeText + " ")
            strLabelText.append(attachmentString)
            strLabelText.append(NSAttributedString(string:" " + afterText))
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
    
    convenience init(badgeText: String, color: UIColor = UIColor.red, fontSize: CGFloat = UIFont.smallSystemFontSize) {
        self.init()
        text = " \(badgeText) "
        textColor = UIColor.white
        backgroundColor = color
        
        font = UIFont.systemFont(ofSize: fontSize)
        layer.cornerRadius = fontSize * CGFloat(0.6)
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0))
    }
    
}

extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self
        let iArrKeys = Array(dict.keys)
        let keysToRemove = iArrKeys.filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        return dict
    }
    
}


extension UITextField {
    func addBorderToBottomOfTextfield(borderColor:UIColor)
    {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = borderColor.cgColor
        print(self.frame.size.width)
        border.frame = CGRect(x: 0, y:self.frame.size.height+0, width:self.frame.width, height: 1.0)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    func setLeftViewIcon(_ icon: UIImage) {
        
        let padding = 5
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: size) )
        let iconView  = UIImageView(frame: CGRect(x:padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
    
    func placeHolderCustomized(_ strPlaceHolderText:String,strHexColor:String) {
        self.attributedPlaceholder = NSAttributedString(string: strPlaceHolderText,
                                                        attributes: [NSForegroundColorAttributeName: UIColor(hexString:strHexColor)!])
    }
    
    
}

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension UITextView {
    func addBorderOfTextfield(borderColor:UIColor)
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = borderColor.cgColor
        
        border.frame = CGRect(x: 0, y: 0, width:self.frame.width, height: self.frame.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    func addBorderToBottomOfTextfield(borderColor:UIColor)
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = borderColor.cgColor
        
        border.frame = CGRect(x: 0, y: self.frame.size.height + 2, width:  UIScreen.main.bounds.size.width  -  40, height: 1.0)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
    }
    
    public func resolveHashTags(_ possibleUserDisplayNames:[String]? = nil) {
        
        
        let schemeMap = [
            "#":"hash",
            "@":"mention"
        ]
        
        // Separate the string into individual words.
        // Whitespace is used as the word boundary.
        // You might see word boundaries at special characters, like before a period.
        // But we need to be careful to retain the # or @ characters.
        let words = self.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        let attributedString = attributedText.mutableCopy() as! NSMutableAttributedString
        
        // keep track of where we are as we interate through the string.
        // otherwise, a string like "#test #test" will only highlight the first one.
        var bookmark = text.startIndex
        
        // Iterate over each word.
        // So far each word will look like:
        // - I
        // - visited
        // - #123abc.go!
        // The last word is a hashtag of #123abc
        // Use the following hashtag rules:
        // - Include the hashtag # in the URL
        // - Only include alphanumeric characters.  Special chars and anything after are chopped off.
        // - Hashtags can start with numbers.  But the whole thing can't be a number (#123abc is ok, #123 is not)
        for word in words {
            
            var scheme:String? = nil
            
            if word.hasPrefix("#") {
                scheme = schemeMap["#"]
            } else if word.hasPrefix("@") {
                scheme = schemeMap["@"]
            }
            
            // Drop the # or @
            var wordWithTagRemoved = String(word.characters.dropFirst())
            
            // Drop any trailing punctuation
            wordWithTagRemoved.dropTrailingNonAlphaNumericCharacters()
            
            // Make sure we still have a valid word (i.e. not just '#' or '@' by itself, not #100)
            guard let schemeMatch = scheme, Int(wordWithTagRemoved) == nil && !wordWithTagRemoved.isEmpty
                else { continue }
            let remainingRange = Range(bookmark..<text.endIndex)
            //let remainingRange = Range(text.indices.suffix(from: bookmark))
            
            // URL syntax is http://123abc
            
            // Replace custom scheme with something like hash://123abc
            // URLs actually don't need the forward slashes, so it becomes hash:123abc
            // Custom scheme for @mentions looks like mention:123abc
            // As with any URL, the string will have a blue color and is clickable
            
//            if let matchRange = text.range(of: word, options: .literal, range:remainingRange),
//                let escapedString = wordWithTagRemoved.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
//                attributedString.addAttribute(NSLinkAttributeName, value: "\(schemeMatch):\(escapedString)", range: text.NSRangeFromRange(matchRange))
//            }
            
            // just cycled through a word. Move the bookmark forward by the length of the word plus a space  myString.index(myString.startIndex, offsetBy: 2)
            //bookmark = bookmark.index(bookmark.startIndex,offsetBy:word.characters.count)
            //bookmark = bookmark.advancedBy(word.characters.count)
            bookmark = text.index(bookmark, offsetBy: word.characters.count)
        }
        
        self.attributedText = attributedString
        //attributedString.removeAttribute(NSStrikethroughStyleAttributeName, range: NSMakeRange(0, attributedString.length))
    }

}


public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}

extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}

extension UIImageView {
    public func setCircleView(width:CGFloat) {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = width/2
        self.clipsToBounds = true
        
    }
}
/*
 
 extension String {
  }
 
 extension UITextView {
 
  }

 
 */
