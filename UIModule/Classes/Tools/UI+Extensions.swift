
//  UI+Extensions.swift
//  BaseApp
//
//  Created by 刘远凌 on 2018/8/29.
//  Copyright © 2018年 刘远凌. All rights reserved.
//

import UIKit
import Kingfisher
import CommonCrypto
import FWPopupView
import Async
import MobileCoreServices
import MJRefresh
let lineSpaceKey = "lineSpaceKey"

enum RGButtonImagePosition {
    case top          //图片在上，文字在下，垂直居中对齐
    case bottom       //图片在下，文字在上，垂直居中对齐
    case left         //图片在左，文字在右，水平居中对齐
    case right        //图片在右，文字在左，水平居中对齐
}

public extension UIDevice {
    static func isX() -> CGFloat {
        return CGFloat(UIDevice.navigationBarHeight())+UIDevice.statusBarHight()
    }
    
    static func iPhone5() -> Bool {
        return ez.screenHeight == 568
    }
    
    static func iPhone6() -> Bool {
        return ez.screenHeight == 667
    }
    
    static func iPhone6_Plus() -> Bool {
        return ez.screenHeight == 736
    }
    
    static func IS_iPhoneX() -> Bool {
        return (ez.screenWidth == 375 && ez.screenHeight == 812)
    }
    
    static func IS_iPhoneXR() ->Bool{
        return (ez.screenWidth == 414 && ez.screenHeight == 896)
    }
    
    static func IS_iPhoneXBottomMargin() -> CGFloat {
        return UIDevice.isiPhoneXScreen() ? 34 : 0
    }
    
    static func IS_iPhoneXTopMargin()-> CGFloat{
        return UIDevice.isiPhoneXScreen() ? 24 : 0
    }
    static func Tabbar_Height()->CGFloat{
        return UIDevice.isiPhoneXScreen() ? 49 + 34 : 49
    }
    static func isiPhoneXScreen() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.windows[0].safeAreaInsets.bottom != 0
    }
    ///状态栏的高度
    static func statusBarHight() -> CGFloat {
        var statusBarHeight:CGFloat = 0
        if #available(iOS 13.0, *) {
            let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            statusBarHeight = statusBarManager?.statusBarFrame.size.height ?? 0
        }else{
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        }
        return statusBarHeight
    }
    
    static func navigationBarHeight()->Int{
        return 44
    }
    
    static func bottomPadding()->CGFloat{
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if #available(iOS 11.0, *) {
            let bottomPadding = window?.safeAreaInsets.bottom
            guard let padding = bottomPadding else { return 0.0 }
            return padding
        } else {
            // Fallback on earlier versions
            
            return 60.0
        }
        
    }
}

public func ZCtoStr(_ o : Any?)->String{
    guard let o = o else{
        return ""
    }
    guard "\(o)" != "null" else{return ""}
    return "\(o)"
}

public extension Error {
    var toString: String { return String(describing: self)}
}

public extension UITextField {
    func es_style(textFont:UIFont, textColor:UIColor) {
        self.font = textFont
        self.textColor = textColor
    }
    
}

public extension UIScrollView {
    func addHeaderWithClosure(closure: @escaping () -> Void,color : String) {
        let header = MJRefreshNormalHeader(refreshingBlock: closure)
        header.stateLabel?.textColor = UIColor(hexString: color)
        header.lastUpdatedTimeLabel?.textColor = UIColor(hexString: color)
        self.mj_header = header
    }
    func addHeaderWithClosure(closure: @escaping () -> Void) {
        self.mj_header = MJRefreshNormalHeader(refreshingBlock: closure)
    }
    func addFooterWithClosure(closure: @escaping () -> Void,color : String) {
        let footer = MJRefreshBackNormalFooter(refreshingBlock: closure)
        footer.stateLabel?.textColor = UIColor(hexString: color)
        self.mj_footer =  footer
    }
    func addFooterWithClosure(closure: @escaping () -> Void) {
        self.mj_footer =  MJRefreshBackNormalFooter(refreshingBlock: closure)
    }
    func beginRefreshing() {
        if let header = self.mj_header , !header.isRefreshing {
            header.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        if let header = self.mj_header , header.isRefreshing {
            header.endRefreshing()
        }
        if let footer = self.mj_footer , footer.isRefreshing {
            footer.endRefreshing()
        }
    }
    func noMoreData(){
        if let footer = self.mj_footer {
            footer.endRefreshingWithNoMoreData()
        }
        
    }
    func resetMoreData(){
        if let footer = self.mj_footer {
            footer.resetNoMoreData()
        }
    }
}

public class LLTextField: UITextField {
    
    var lldelegate:LLTextFieldDelegate?
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width - 25, height: bounds.size.height)
        return inset
    }
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width - 25, height: bounds.size.height)
        return inset
    }
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.size.width - 25, height: bounds.size.height)
        return inset
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        self.lldelegate?.deleteClick(self)
    }
    
}

protocol LLTextFieldDelegate {
    func deleteClick(_ textField : LLTextField)
}


public extension UIImageView {
    func es_setAspectFill() {
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    func es_setImageWithURLString(_ string: String?, placeholderImage: UIImage?,completionHandler : CompletionHandler?=nil) {
        
        let modifier = AnyModifier { request in
            var r = request
            // replace "Access-Token" with the field name you need, it's just an example
            r.setValue("APP/iOS", forHTTPHeaderField: "User-Agent")
            return r
        }
        
        if let string = string, string.length > 0 {
            self.kf.setImage(with: URL(string: string), placeholder: placeholderImage, options: [.transition(.fade(1)),.requestModifier(modifier)], progressBlock: nil, completionHandler: completionHandler)
        } else {
            self.image = placeholderImage
        }
        
    }
}



public extension UIImage {
    static func imageWihtColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
    
    func compressImageOnlength(maxLength: Int) -> Data? {
        guard let vData = self.jpegData(compressionQuality: 1) else { return nil }
        print("压缩前kb: \( Double((vData.count)/1024))")
        if vData.count < maxLength {
            return vData
        }
        var compress:CGFloat = 0.9
        guard var data = self.jpegData(compressionQuality: compress) else { return nil }
        while data.count > maxLength && compress > 0.01 {
            print( "压缩比: \(compress)")
            compress -= 0.02
            data = self.jpegData(compressionQuality: compress)!
        }
        print("压缩后kb: \(Double((data.count)/1024))")
        return data
    }
    
    func compressQuality(_ maxLength:Int)->Data{
        var compression : CGFloat = 1
        var max : CGFloat = 1.0
        var min : CGFloat = 0.0
        var data : Data = self.compressImage(rate: compression)!
        if data.count < maxLength {
            
            return data
        }
        for _ in 1...10 {
            compression = CGFloat((max + min) / 2);
            data = self.compressImage(rate: compression)!;
            if data.count < (maxLength * 9/10) {
                min = compression;
            } else if data.count > maxLength{
                max = compression;
            } else {
                break;
            }
        }
        return data
    }
}

public extension UILabel {
    convenience init(font: UIFont, color: UIColor, alignment: NSTextAlignment,titleString:String) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.text = titleString
    }
    
    var lineSpace :CGFloat?{
        
        set{
            
            objc_setAssociatedObject(self, lineSpaceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
        
        get{
            
            return (objc_getAssociatedObject(self, lineSpaceKey) as? CGFloat)
            
        }
        
    }
    
    /// 设置行间距
    /// - Parameters:
    ///   - text: <#text description#>
    ///   - lineSpacing: <#lineSpacing description#>
    func setTextLineSpacing(text: String, lineSpacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
    
    //label 内容行数  这的size 是label 的宽和高  lineSpace 是行间距
    
    func textNumLinesWithHeight(size:CGSize) -> CGFloat {
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = self.lineBreakMode
        
        paragraphStyle.alignment = self.textAlignment
        
        
        
        if self.lineSpace == nil {
            
            self.lineSpace = 0
            
        }
        
        paragraphStyle.lineSpacing = self.lineSpace!
        
        let attributes = [NSAttributedString.Key.font : self.font,
                          
                          NSAttributedString.Key.paragraphStyle : paragraphStyle];
        
        let contentSize = self.text!.boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin] , attributes: attributes as [NSAttributedString.Key : Any], context: nil).size
        
        let labelNumber = contentSize.height / self.font.lineHeight
        
        return labelNumber
        
    }
    
    func zcAddMidLine(){
        guard let _ = text else{return}
        let attrStr : NSMutableAttributedString = NSMutableAttributedString(string: text ?? "")
        
        attrStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange.init(location:0, length: text!.count))
        attrStr.addAttribute(.strikethroughColor, value: UIColor(hexString: "#999999")!, range: NSRange.init(location:0, length: text!.count))
        self.attributedText = attrStr
    }
}


public extension UIStoryboard{
    
    class func instantiate(vc:String,sb:String) -> UIViewController{
        let sb = UIStoryboard(name: sb, bundle: nil);
        return sb.instantiateViewController(withIdentifier: vc);
    }
    
}
extension UIViewController {
    
    public func setStatusBlack(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default;
    }
    
    public func setStatusWhite(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
    }
    
    public func popVCByLevel(level: Int, fail: () -> Void) {
        if let viewControllers = self.navigationController?.viewControllers , viewControllers.count > level {
            let lastIndex = viewControllers.count - 1
            let popVC = viewControllers[lastIndex - level]
            _ =    self.navigationController?.popToViewController(popVC, animated: true)
        } else {
            fail()
        }
    }
    
    public func popVCByClass(name: String, fail: () -> Void) {
        if let viewControllers = self.navigationController?.viewControllers , viewControllers.count > 0 {
            var vc : UIViewController = UIViewController()
            for item in viewControllers{
                if item.className == name {vc = item;break}
            }
            guard vc.className == name else{fail();return}
            _ =  self.navigationController?.popToViewController(vc, animated: true)
        } else {
            fail()
        }
    }
    public func pop2RootVC() {
        self.popToRootVC()
    }
    func push(vc:String,sb:String) -> UIViewController{
        let vcObject = UIStoryboard.instantiate(vc: vc, sb: sb)
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vcObject, animated: true)
        if self.navigationController != nil{
            if self.navigationController!.viewControllers.count > 2{
                self.hidesBottomBarWhenPushed = true
            }else{
                self.hidesBottomBarWhenPushed = false
            }
        }
        return vcObject
    }
    
    func push(vc:UIViewController){
        
        self.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true)
        if self.navigationController != nil{
            if self.navigationController!.viewControllers.count > 2{
                self.hidesBottomBarWhenPushed = true
            }else{
                self.hidesBottomBarWhenPushed = false
            }
        }
    }
    
    
    func pop()  {
        if self.navigationController?.viewControllers.count == 1{
            dismiss(animated: true) {
            }
        }else{
            popVC()
        }
    }
    
    
}

extension Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else{
            return false
        }
        if #available(iOS 10.2, *) {
            return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation || firstProperties.generalCategory == .otherSymbol)
        } else {
            return false
        }
    }
    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 1 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }
    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
//    var isEmoji:Bool{
//        return isSimpleEmoji || isCombinedIntoEmoji
//    }
}

extension String {
    
    /// 是否为单个emoji表情
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }
    
    /// 包含emoji表情
    var containsEmoji: Bool {
        return contains{ $0.isEmoji}
    }
    
    /// 只包含emoji表情
    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains{!$0.isEmoji}
    }
    
    /// 提取emoji表情字符串
    var emojiString: String {
        return emojis.map{String($0) }.reduce("",+)
    }
    
    /// 提取emoji表情数组
    var emojis: [Character] {
        return filter{ $0.isEmoji}
    }
    
    /// 提取单元编码标量
    var emojiScalars: [UnicodeScalar] {
        return filter{ $0.isEmoji}.flatMap{ $0.unicodeScalars}
    }
    
    /// 移除字符串中的表情符号，返回一个新的字符串
    public func removeEmoji() -> String {
        return self.reduce("") {
            if $1.isEmoji {
                return $0 + ""
            } else {
                return $0 + String($1)
            }
        }
    }
    
    func findFirst(_ sub : String)->Int{
        var pos = -1
        if let range = range(of: sub, options: .literal){
            if !range.isEmpty{
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
    
    func webContent()->String{
        
        let head = "<html><head><meta http-equiv=\'Content-Type\' content=\'text/html; charset=utf-8\'/><meta content=\'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;\' name=\'viewport\' /><meta name=\'apple-mobile-web-app-capable\' content=\'yes\'><meta name=\'apple-mobile-web-app-status-bar-style\' content=\'black\'><link rel=\'stylesheet\' type=\'text/css\' /><style>img{width:100%;height:auto;}html{font-size:14px;color:#666666}</style></head><body><div id=\'content\'>"
        let foot = "</div>"
        return  head + self + foot
    }
    
    func getAttributeStringWithString( lineSpace:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStye = NSMutableParagraphStyle()
        
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        let rang = NSMakeRange(0, CFStringGetLength(self as CFString?))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStye, range: rang)
        return attributedString
    }
    
    
    
    
    /// 字符串截取，从开始位置截取到第几位
    ///
    /// - Parameter index: 结束的位置
    /// - Returns: 返回截取后的字符串
    func substring(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 字符串截取，从第几位开始截取
    ///
    /// - Parameter index: 从第几位开始截取
    /// - Returns: 返回截取后的字符串
    func substring(form index:Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 字符串截取，从第几位到第几位开始截取
    ///
    /// - Parameters:
    ///   - startIndex: 开始截取的位置
    ///   - endIndex: 结束截取的位置
    /// - Returns: 返回截取后的字符串
    func substringWithStartforEnd(Start startIndex: Int, End endIndex:Int) -> String {
        if self.count > endIndex {
            let start = self.index(self.startIndex, offsetBy: startIndex)
            let end  = self.index(self.startIndex, offsetBy: endIndex)
            let subString = self[start..<end]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 字符串截取，从区间内截取
    ///
    /// - Parameters:
    ///   - startIndex: 开始截取的位置
    ///   - endIndex: 从字符串的尾数倒数回来的值
    /// - Returns: Returns: 返回截取后的字符串
    func substringWithRang(start startIndex : Int, end endIndex: Int) -> String {
        if self.count > endIndex {
            let start = self.index(self.startIndex, offsetBy: startIndex)
            let end  = self.index(self.endIndex, offsetBy: endIndex)
            let subString = self[start..<end]
            return String(subString)
        } else {
            return self
        }
    }
    
    //计算文字宽度
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - height  :高度
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    //计算文字高度
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - width   :宽度
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    //计算文字高度
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - width   :宽度
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat,lineSpacing:CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = .left
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle:paragraphStyle], context: nil)
        return ceil(rect.height)
    }
    func md5() -> String {
        
        let str = self.cString(using: String.Encoding.utf8)
        
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        
        
        CC_MD5(str!, strLen, result)
        
        
        
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            
            hash.appendFormat("%02x", result[i])
            
        }
        //lowercased
        return String(format: hash as String).lowercased()
        
    }
    public func md5(strs:String) ->String!{
        let str = strs.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(strs.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        // result.deinitialize()
        return String(format: hash as String)
    }
    func hexData() -> Data? {
        var data = Data(capacity: count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else { return nil }
        return data
    }
    func utf8Data()-> Data? {
        return self.data(using: .utf8)
    }
    
    func encryption(number : Int)->String{
        guard number < count else{return self}
        let conversion = (1...number).map { (_) -> String in
            return "*"
        }.joined(separator: "")
        let interval = (count - number) / 2
        let sub = substringWithStartforEnd(Start: interval, End: interval + number)
        return replacingOccurrences(of: sub, with: conversion)
    }
    
}

extension Data {
    ///Data转16进制字符串
    func hexString() -> String {
        return map { String(format: "%02x", $0) }.joined(separator: "").uppercased()
    }
}
extension DispatchQueue {
    static var background: DispatchQueue {
        return global(qos: .background)
    }
}
public enum ZHYShakeDirection: Int {
    case horizontal
    case vertical
}
extension UITextField {
    
    public convenience init(font: UIFont, color: UIColor, alignment: NSTextAlignment,placeholder:String,plaColor:UIColor,keyboardType:UIKeyboardType) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        es_setplaceholderColor(color: plaColor)
    }
    
    public func es_setplaceholderColor(color:UIColor){
        self.setValue(color, forKeyPath:"placeholderLabel.textColor")
    }
    
}
extension UIView {
    
    public convenience init(backgroundColor:UIColor,radius:CGFloat) {
        self.init()
        self.backgroundColor = backgroundColor
        self.setCornerRadius(radius: radius)
    }
    
    func addGradient(start_color:String,end_color : String,size : CGSize?=nil,cornerRadius : CGFloat?=0,locations:[NSNumber] = [0,1]){
        var bounds : CGRect = self.bounds
        if let size = size {
            bounds = CGRect(origin: .zero, size: size)
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(hexString: start_color)!.cgColor, UIColor(hexString: end_color)!.cgColor]
        bgLayer1.locations = locations
        bgLayer1.frame = bounds
        bgLayer1.startPoint = CGPoint(x: 1, y: 1)
        bgLayer1.endPoint = CGPoint(x: 0, y: 0)
        bgLayer1.cornerRadius = cornerRadius ?? 0
        self.layer.addSublayer(bgLayer1)
    }
    public func shake(direction: ZHYShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, offset: CGFloat = 2, completion: (() -> Void)? = nil) {
        
        //移动视图动画（一次）
        UIView.animate(withDuration: interval, animations: {
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: offset))
            }
            
        }) { (complete) in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) in
                    completion?()
                })
            }
            
            //如果当前不是最后一次，则继续动画，偏移位置相反
            else {
                self.shake(direction: direction, times: times - 1, interval: interval, offset: -offset, completion: completion)
            }
        }
    }
    
    func zcSetShadow(shadowColor : UIColor,shadowOpacity:Float,shadowRadius : CGFloat,shadowOffset : CGSize,bounds:CGRect){
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
    
    ///设置全圆角
    func zcSetCornerRadius(cornerRadius : CGFloat){
        layer.cornerRadius = cornerRadius
    }
    ///设置圆角,单个圆角
    func zcSetCorner(corner : [CornerDirection]=[.topLeft,.topRight,.bottomLeft,.bottomRight],radius:CGFloat){
        let cornerAry =  corner.map { (dic) -> UInt in
            switch dic {
            case .topLeft:
                return UIRectCorner.topLeft.rawValue
            case .topRight:
                return UIRectCorner.topRight.rawValue
            case .bottomLeft:
                return UIRectCorner.bottomLeft.rawValue
            case .bottomRight:
                return UIRectCorner.bottomRight.rawValue
            }
        }
        let rawValue = cornerAry.reduce(0){$0|$1}
        
        if #available(iOS 11.0, *) {
            let cornerMask = CACornerMask(rawValue: rawValue)
            layer.cornerRadius = radius
            layer.maskedCorners = cornerMask
        } else {
            let cornerDirection = UIRectCorner(rawValue: rawValue)
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornerDirection, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
    }
    
    func drawBoardDottedLine(lenth:Int = 5,space:Int = 5,cornerRadius:CGFloat,color:UIColor){
        self.layer.cornerRadius = cornerRadius
        let borderLayer =  CAShapeLayer()
        borderLayer.bounds = self.bounds
        
        borderLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY);
        borderLayer.path = UIBezierPath(roundedRect: borderLayer.bounds, cornerRadius: cornerRadius).cgPath
        borderLayer.lineWidth = 1
        
        //虚线边框---小边框的长度
        //前边是虚线的长度，后边是虚线之间空隙的长度
        borderLayer.lineDashPattern = [NSNumber(value: lenth), NSNumber(value: space)]
        //实线边框
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        self.layer.addSublayer(borderLayer)
    }
}
enum CornerDirection {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

extension Array {
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

extension UIView {
    
    func viewController() -> UIViewController? {
        var responseder = self as UIResponder
        while responseder.next != nil {
            responseder = responseder.next!
            if responseder.isKind(of: UIViewController.self) {
                return (responseder as! UIViewController)
            }
        }
        return nil
    }
}

extension Date {
    // 转成当前时区的日期
    /*
     BRDatePickerView 获取的date 比当前时间少8小时
     如果需要获取到正确的时间 用这个方法转一下
     */
    static func dateFromGMT(_ date: Date) -> Date {
        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        return date.addingTimeInterval(secondFromGMT)
    }
}

//根据不同设备的宽度进行缩放
public func adaptW(width:CGFloat)->CGFloat{
    return UIScreen.main.bounds.size.width * (width/375.0)
}
public func adaptH(height:CGFloat)->CGFloat{
    return UIScreen.main.bounds.size.height * (height/812.0)
}
