//
//  BaseVCLayout.swift
//  LHBaseLayout
//
//  Created by lanhao on 2021/10/14.
//

import Foundation
@_exported import TangramKit
open class BaseVCLayout: UIViewController {
    ///根视图
    open lazy var rootLayout: TGRelativeLayout = {
        let layout = TGRelativeLayout()
        layout.tg_width.equal(.fill)
        layout.tg_height.equal(.fill)
        layout.backgroundColor = .white
        return layout
    }()
    ///自定义导航栏
    open lazy var navBarLayout: NavigationBarLayout = {
        let layout = NavigationBarLayout.init(title: nil)
        return layout
    }()
    ///页面标题
    open var navBarTitleStr:String?{
        didSet{
            guard let title = self.navBarTitleStr else { return }
            navBarLayout.titleLabel.tg_visibility = .visible
            navBarLayout.titleLabel.text = title
        }
    }
    ///是否显示自定义导航栏
    open var navBarVisibility:TGVisibility = .visible{
        didSet{
            navBarLayout.tg_visibility = navBarVisibility
        }
    }
    open override func viewDidLoad() {
        
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge(rawValue:0)

        self.view.addSubview(rootLayout)
        
        if let nav = navigationController,nav.children.count > 1 {
            navBarLayout.topLeftBtnVisibility = .visible
            navBarLayout.handleTopLeftBtnEventCallBack = { [weak self] in
                guard let this = self else { return }
                this.popVC()
            }
        }else{
            navBarLayout.topLeftBtnVisibility = .gone
        }
        
        rootLayout.addSubview(navBarLayout)
        
        configNavBarLayout()
        
        initLayout()
    }
    ///配置导航栏
    open func configNavBarLayout(){
        
    }
    ///创建子视图
    open func initLayout(){
        
    }
}

extension BaseVCLayout:UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1{
            return false
        }
        return true
    }
}
