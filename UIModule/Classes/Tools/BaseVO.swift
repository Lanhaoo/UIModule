//
//  BaseVO.swift
//  PengPengApp
//
//  Created by 陈政宏 on 2018/11/6.
//  Copyright © 2018年 陈政宏. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol BaseVO {
    associatedtype Element
    static func parseObject( json: JSON) -> Element
}

extension BaseVO {
    
   public static func parseList(jsonList: JSON) -> [Element] {
        var voList = [Element]()
        if let jsonList = jsonList.array {
            for json in jsonList {
                voList.append(parseObject(json: json))
            }
        }
        return voList
    }
    
    public static func parseList(jsonList: [JSON]) -> [Element] {
        var voList = [Element]()
        for json in jsonList {
            voList.append(parseObject(json: json))
        }
        return voList
    }
}

