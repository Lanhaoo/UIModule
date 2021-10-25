//
//  Regex.swift
//  RedEvelope
//
//  Created by 陈政宏 on 2018/9/14.
//  Copyright © 2018年 陈政宏. All rights reserved.
//

import Foundation

//手机
let IDCardTW = Regex("^[a-zA-Z][0-9]{9}$")
let IDCardMC = Regex("^[1|5|7][0-9]{6}\\(?[0-9A-Z]\\)?$")
let IDCardHK = Regex("^[A-Z]{1,2}[0-9]{6}\\(?[0-9A]\\)?$")
let MobileRegex = Regex("^1[3-9][0-9]\\d{8}$")
///18位身份证号码
let IDCard18 = Regex("^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])$")
///15位身份证号码
let IDCard15 = Regex("^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$")
//电子邮件
let EmailRegex = Regex("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
//中文
let ChineseRegex = Regex("[\\u4e00-\\u9fa5]")
//验证是否是6位纯数字
let PasswordNumSix = Regex("^\\d{6}$")
//密码(以字母开头，长度在6~18之间，只能包含字母、数字和下划线)/^(?=.*[a-zA-Z])(?=.*\d)(?=.*[~!@#$%^&*()_+`\-={}:";'<>?,./]).{8,}$/
let PasswordRegex = Regex("^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[~!@#$%^&*()_+`\\-={}:\";'<>?,./]).{8,}$")

//密码正则 8-16位，数字、字母、标点符号
let PasswRegex = Regex("(?!.*\\s)(?!^[\\u4e00-\\u9fa5]+$)(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{6,18}$")

//强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在8-18之间)
let StrongPasswordRegex = Regex("^[a-zA-Z0-9]{8,18}$")

let S =  Regex("^[a-zA-Z0-9_,.?]{8,18}$")//Regex("^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,18}$")
//邮编
let PostCodeRegex = Regex("[1-9]\\d{5}(?!\\d)")
//用户名 只能由数字、26个英文字母或下划线组成的字符串:
let UserNameRegex = Regex("^[a-zA-z][a-zA-Z0-9_]{2,9}$")
//座机号码
let PhoneRegex = Regex("\\d{2,5}-\\d{7,8}")

public class Regex {
    private let internalExpression:NSRegularExpression?
    private let pattern:String
    
    init(_ pattern:String) {
        self.pattern = pattern
        self.internalExpression = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
    }
    
    public func match(_ input:String) -> Bool {
        guard let internalExpression = self.internalExpression else { return false }
        let matches = internalExpression.matches(in: input, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, input.count))
        return matches.count > 0
    }
}
