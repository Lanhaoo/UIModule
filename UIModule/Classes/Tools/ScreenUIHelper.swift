//
//  ScreenUIHelper.swift
//  RedEvelope
//
//  Created by 刘远凌 on 2018/9/12.
//  Copyright © 2018年 陈政宏. All rights reserved.
//

import UIKit
import SwiftyJSON
import FWPopupView
import SVProgressHUD

public class ScreenUIHelper: NSObject {
    
    static func topViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow!
        if window.windowLevel != .init(0){
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == .init(0){
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window.rootViewController
        return getTopVC(withCurrentVC: vc)
    }
    static func getTopVC(withCurrentVC VC:UIViewController?) -> UIViewController? {
        if VC == nil {
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getTopVC(withCurrentVC: presentVC)
        }else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        } else {
            // 返回顶控制器
            return VC
        }
    }
    static func showToast(message: String, inView view: UIView) {
        guard !message.isEmpty else{return}
        view.makeToast(message, duration: 1.5, position: .center)
    }
    
    static func sv_show() {
        SVProgressHUD.show()
    }
    
    static func sv_login(){
        sv_show(statusStr: "登录中")
    }
    static func sv_loading(){
        sv_show(statusStr: "加载中")
    }
    
    static func sv_show(statusStr:String){
        //hud在显示的时候，禁止用户交互
        /*
         hud在显示的时候，禁止用户交互
         SVProgressHUD.setDefaultMaskType(.clear)
         */
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: statusStr)
    }
    
    static func sv_showWithStatus(_ string: String) {
        SVProgressHUD.show(withStatus: string)
    }
    
    static func sv_dismiss() {
        SVProgressHUD.dismiss()
    }
}
