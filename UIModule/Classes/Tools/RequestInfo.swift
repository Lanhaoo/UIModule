//
//  RequestInfo.swift
//  RedEvelope
//
//  Created by 陈政宏 on 2018/9/14.
//  Copyright © 2018年 陈政宏. All rights reserved.
//

import Foundation

public class RequestInfo {
    private var requestDict:[String: Any] = [:]
    public static func requestInfo() -> RequestInfo {
        let requestInfo : RequestInfo = RequestInfo()
        return requestInfo
    }
    @discardableResult
    public func addParaValue(value:Any?,forKey key: String) -> RequestInfo {
        guard let value = value else{
            return self
        }
        if let value_str = value as? String{
            guard value_str != ""  else{
                return self
            }
        }
        self.requestDict[key] = value
        return self
    }
    public func toDictionary() -> [String:Any] {
        return self.requestDict
    }
}
