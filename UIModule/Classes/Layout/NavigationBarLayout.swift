//
//  NavigationBarLayout.swift
//  LHBaseLayout
//
//  Created by lanhao on 2021/10/15.
//

import Foundation
import TangramKit
public class NavigationBarLayout: TGRelativeLayout {
    public lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()

    public lazy var bottomLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hexString: "#EFEFEF")!
        return v
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel.init(font: UIFont.systemFont(ofSize: 16), color: UIColor(hexString: "#333333")!, alignment: .center)
        return label
    }()
    
    public var titleColor:UIColor?{
        didSet{
            guard let color = titleColor else { return }
            titleLabel.textColor = color
        }
    }
    ///是否显示左上角按钮
    public var topLeftBtnVisibility:TGVisibility = .gone{
        didSet{
            self.leftBtn.tg_visibility = topLeftBtnVisibility
        }
    }
    ///是否显示导航栏下面的横线
    public var bottomLineVisibility:TGVisibility = .gone{
        didSet{
            self.bottomLine.tg_visibility = bottomLineVisibility
        }
    }

    //所有的子视图 都加在它上面
    public lazy var navLayout:TGRelativeLayout = {
        let nav = TGRelativeLayout()
        nav.tg_height.equal(UIDevice.navigationBarHeight())
        nav.tg_top.equal(UIDevice.statusBarHight())
        nav.tg_width.equal(.fill)
        nav.tg_left.equal(0)
        return nav
    }()
    ///背景色
    public var navBarBackgroundColor:UIColor?{
        didSet{
            backgroundColor = navBarBackgroundColor
            navLayout.backgroundColor = navBarBackgroundColor
        }
    }
    
    public var handleTopLeftBtnEventCallBack:(()->())?
    
    convenience init(title:String?,bottomLineVisibility:Bool? = false) {
        self.init()
        self.tg_width.equal(.fill)
        self.tg_height.equal(CGFloat(UIDevice.navigationBarHeight())+UIDevice.statusBarHight())
        self.tg_top.equal(0)
        self.tg_left.equal(0)
        
        addSubview(navLayout)
        
        leftBtn.tg_size(CGSize.init(width: adaptW(width: 40), height: adaptW(width: 40)))
        leftBtn.tg_left.equal(0)
        leftBtn.tg_centerY.equal(0)
        leftBtn.addTapGesture { [weak self] (_) in
            guard let this = self else { return }
            this.handleTopLeftBtnEventCallBack?()
        }
        navLayout.addSubview(leftBtn)
        leftBtn.tg_visibility = .gone
        
        
        bottomLine.tg_width.equal(.fill)
        bottomLine.tg_height.equal(1)
        bottomLine.tg_bottom.equal(0)
        bottomLine.tg_left.equal(0)
        navLayout.addSubview(bottomLine)
        bottomLine.tg_visibility = bottomLineVisibility! ? .visible : .gone
        
        
        titleLabel.tg_centerX.equal(0)
        titleLabel.tg_centerY.equal(0)
        titleLabel.tg_height.equal(adaptW(width: 30))
        titleLabel.tg_width.equal(.wrap).max(adaptW(width: 200))
        navLayout.addSubview(titleLabel)
        
        guard let titleStr = title else {
            titleLabel.tg_visibility = .gone
            return
        }
        titleLabel.tg_visibility = .visible
        titleLabel.text = titleStr
        
        
        self.navBarBackgroundColor = .white
    }
}
