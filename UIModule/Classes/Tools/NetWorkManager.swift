//
//  NetWorkManager.swift
//  UIModule
//
//  Created by lanhao on 2021/10/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

public struct RequestError: Error {
    public var code: Int = 0
    public var message: String = ""
    public init(code:Int,message:String){
        self.code = code
        self.message = message
    }
}

public typealias ResponseIDWithMessage = (message:String,returnID:Int)

struct Logger {
    
    static func debug( message: @autoclosure () -> String? ) {
        print(message() ?? "")
    }
    
    static func error( message: @autoclosure () -> String? ) {
        print(message() ?? "")
    }
    
}

///网络不可用的错误码
public let NetWorkUnReachableCode = 1000110

open class NetWorkManager {
    
    public static let shared = NetWorkManager()
    
    /// 请求头
    open var headers:HTTPHeaders?
    ///网络是否可用
    open var netWorkisReachable = true
    ///网络不可用的通知
    public let NetWorkUnReachableNotification = Notification.Name(rawValue: "NetWorkUnReachableNotification")
    ///网络可用的通知
    public let NetWorkReachabledNotification = Notification.Name(rawValue: "NetWorkReachabledNotification")
    ///是否开启打印
    open var isDebugPrint = true
    init() {
        self.checkNetworkReachability()
    }
    /// 检测网络是否可用
    /// - Returns: description
    open func checkNetworkReachability(){
        let net = NetworkReachabilityManager()
        net!.startListening()
        net!.listener = { [weak self] status in
            guard let this = self else { return }
            this.netWorkisReachable = net!.isReachable
            if net!.isReachable {
                NotificationCenter.default.post(name: this.NetWorkReachabledNotification, object: nil)
            }else{
                NotificationCenter.default.post(name: this.NetWorkUnReachableNotification, object: nil)
            }
        }
    }
    
    
    /// 发送get请求
    /// - Parameters:
    ///   - url: 地址
    ///   - parameters: 参数
    ///   - encoding: 编码
    /// - Returns: description
    public func sendGetRequest(url:String,parameters:[String: Any]? = nil,encoding:ParameterEncoding = URLEncoding.default)->Promise<JSON>{
        return sendRequest(url: url, method: .get, parameters: parameters, encoding: encoding)
    }
    
    /// 发送post请求
    /// - Parameters:
    ///   - url: 地址
    ///   - parameters: 参数
    ///   - encoding: 编码
    /// - Returns: description
    public func sendPostRequest(url:String,parameters:[String: Any]? = nil,encoding:ParameterEncoding = JSONEncoding.default)->Promise<JSON>{
        return sendRequest(url: url, method: .post, parameters: parameters, encoding: encoding)
    }
    
    /// 发送网络请求
    /// - Parameters:
    ///   - url: 地址
    ///   - method: 方法
    ///   - parameters: 参数
    ///   - encoding: 编码
    /// - Returns: description
    public func sendRequest(url:String,method:HTTPMethod,parameters:[String: Any]? = nil,encoding:ParameterEncoding = URLEncoding.default)->Promise<JSON>{
        if !self.netWorkisReachable {
            return Promise(error: RequestError(code: NetWorkUnReachableCode, message: "网络不可用"))
        }else{
            if let pa = parameters,isDebugPrint {
                print("开始请求============\n接口地址:" + url + "\n" + "请求参数:\(pa)")
            }
            return Promise<JSON> { result in
                request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseSwiftyJSON { DataResponse in
                    if let error = DataResponse.error {
                        Logger.debug(message: error.toString)
                        result.reject(RequestError(code: DataResponse.response?.statusCode ?? -1, message: "网络错误,请稍后重试"))
                        return
                    }
                    guard DataResponse.value != JSON.null else {
                        return
                    }
                    if self.isDebugPrint {
                        print("接口地址:" + url + "\n" + "返回json:\(DataResponse.value!)")
                    }
                    result.fulfill(DataResponse.value!)
                }
            }
        }
    }
}
