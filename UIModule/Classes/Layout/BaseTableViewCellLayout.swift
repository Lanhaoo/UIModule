//
//  BaseTableViewCellLayout.swift
//  LHBaseLayout
//
//  Created by lanhao on 2021/5/24.
//

import Foundation
import UIKit
@_exported import TangramKit
open class BaseTableViewCellLayout: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initLayout()
    }
    ///开始布局
    open func initLayout(){
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
