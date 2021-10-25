//
//  AppDelegate.swift
//  UIModule
//
//  Created by Lanhaoo on 10/22/2021.
//  Copyright (c) 2021 Lanhaoo. All rights reserved.
//

import UIKit
import Alamofire
import UIModule
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetWorkManager.shared.headers = ["X-Access-Token":"prefix_user_token_app_eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MDQ1MzMsInVzZXJuYW1lIjoiMTgzMjQxMTQ4NTAifQ.uw4O6ER5HOKwG2b6TpKJtSnKjhmoeOqPvPOODFYbfAI"]
        let paramter = RequestInfo.requestInfo()
            .addParaValue(value: "order_type", forKey: "code")
        NetWorkManager.shared.sendGetRequest(url: "http://123.60.17.240:8099/smartyProperty/dcqtech/dict/getSecondDict", parameters: paramter.toDictionary()).done { json in
            ResponseAdapter.parseData(json: json).done { dt in
                
            }.catch { error in
                /*
                 服务器返回的 code 非“成功”的code的回调
                 比如约定好 正确的code是:200 这个时候服务器返回的code非 200 就会进入这里
                 */
                print(ResponseAdapter.errorMsg(error: error))
            }
        }.catch { error in
            /*
             网络不可用和服务器访问错误会进入这个回调
             */
            let code = ResponseAdapter.errorCode(error: error)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

