//
//  ResponseAdapter.swift
//  UIModule_Example
//
//  Created by lanhao on 2021/10/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import UIModule
struct ResponseAdapter {
    
    /// 解析服务器返回的json数据
    /// - Parameter json: json description
    /// - Returns: description
    static func parseData(json:JSON)->Promise<JSON>{
        if isSuccess(json: json) {
            //如果成功 返回json数据
            return Promise<JSON>{ result in
                let dic = json["result"]
                if dic != JSON.null{
                    result.fulfill(dic)
                }
                result.reject(RequestError(code: -1, message: "服务器返回的数据错误"))
            }
        }
        //抛出异常
       return parseError(json: json)
    }
    
    ///得到到错误消息
    static func errorMsg(error:Error)->String{
        return (error as! RequestError).message
    }
    ///得到错误码
    static func errorCode(error:Error)->Int{
        return (error as! RequestError).code
    }
    /// 判断服务器返回的code 是否正确
    /// - Parameter json: json description
    /// - Returns: description
    private static func isSuccess(json:JSON)->Bool{
        return ZCtoStr(json["code"]) == "200" || ZCtoStr(json["code"]) == "204"
    }
    
    private static func parseError<T : Any>(json: JSON) -> Promise<T> {
        return Promise(error: RequestError(code: json["code"].int ?? 0, message: json["message"].string ?? ""))        
    }
    
    static func parseResponseObject<T : BaseVO>(json: JSON) -> Promise<T> {
        return Promise<T> { result in
            if isSuccess(json: json) {
                let dict = json["body"]
                if let object = T.parseObject(json: dict) as? T {
                    result.fulfill(object)
                    return
                }
            }
            result.reject(RequestError(code: -1, message: json["message"].string ?? ""))
        }
    }
    
    
    
    static func parseReturnIDWithMessage(json: JSON) -> Promise<ResponseIDWithMessage> {
        if isSuccess(json: json) {
            return Promise.value( (message:json["message"].stringValue,returnID:json["code"].intValue))
        }
        return parseError(json: json)
    }
    
    static func parseResponseList<T : BaseVO>(json: JSON) -> Promise<[T]> {
        return Promise<[T]> { result in
            if isSuccess(json: json) {
                let list = json["body"]["Data"]
                let eList = T.parseList(jsonList: list)
                let resultList = eList.map({ (e) -> T in
                    return e as! T
                })
                result.fulfill(resultList)
                return
            }
            result.reject(RequestError(code: -1, message: json["message"].string ?? ""))
        }
    }
}
