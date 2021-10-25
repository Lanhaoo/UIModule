//
//  PermissionsHelper.swift
//  PengPengApp
//
//  Created by air on 2018/12/8.
//  Copyright © 2018年 陈政宏. All rights reserved.
//


import UIKit
import AVKit
import Photos
import CoreBluetooth

struct PermissionsHelper{

    static func cameraEnable(_ block : @escaping (Bool)->()){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if (authStatus == .authorized) { /****已授权，可以打开相机****/
            block(true)
        }
        else if (authStatus == .denied) {//禁用
            block(false)
        }
            
        else if (authStatus == .restricted) {//相机权限受限
            block(false)
        }
            
        else if (authStatus == .notDetermined) {//首次 使用
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    //用户首次允许
                    block(true)
                } else {
                    //用户首次拒接
                    block(false)
                }
            })
        }
    }
    
    static func photoEnable(_ block : @escaping (Bool)->()){
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if (authStatus == .authorized) { /****已授权，可以打开相机****/
            block(true)
        }
        else if (authStatus == .denied) {//禁用
            block(false)
        }
            
        else if (authStatus == .restricted) {//相册受限
            block(false)
        }
            
        else if (authStatus == .notDetermined) {//首次 使用
            PHPhotoLibrary.requestAuthorization({ (firstStatus) in
                let isTrue = (firstStatus == .authorized)
                if isTrue {
                    print("首次允许")
                    block(true)
                } else {
                    print("首次不允许")
                    block(false)
                }
            })
        }
    }
    ///位置权限
    static func positionEnable()->Bool{
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse { /****已授权，可以定位****/
            return true
        }
        else if (authStatus == .denied) {//禁用
            return false
        }
            
        else if (authStatus == .restricted) {//定位未知禁用受限
            return false
        }
            
        else if (authStatus == .notDetermined) {//首次 使用
            //LocationManager.beginAuth()
            return false
        }
        return false
    }
    ///蓝牙权限
    static func blueEnable()->Bool{
        if #available(iOS 13.1, *) {
            let authStatus = CBManager.authorization
            if (authStatus == .allowedAlways) { /****已授权，可以使用蓝牙****/
                return true
            }
            else if (authStatus == .denied) {//禁用
                return false
            }
            else if (authStatus == .restricted) {//蓝牙受限
               return false
            }
            else if (authStatus == .notDetermined) {//首次 使用
                return true
            }
        } else {
            return true
        }
        return false
    }
}

