//
//  BaseTableLayout.swift
//  LHBaseLayout
//
//  Created by lanhao on 2021/10/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import TangramKit
import DZNEmptyDataSet
@objc public protocol BaseTableLayoutDataSource:NSObjectProtocol {
    
    @objc optional func tableLayoutNumberOfSections(tableLayout: BaseTableLayout) -> Int
    
    @objc optional func tableLayout(tableLayout: BaseTableLayout, numberOfRowsInSection section: Int) -> Int
    
    @objc optional func tableLayout(tableLayout: BaseTableLayout, heightForHeaderInSection section: Int) -> CGFloat
    
    @objc optional func tableLayout(tableLayout: BaseTableLayout, heightForFooterInSection section: Int) -> CGFloat
    
    @objc optional func tableLayout(tableLayout: BaseTableLayout, viewForHeaderInSection section: Int) -> UIView?
    
    @objc optional func tableLayout(tableLayout: BaseTableLayout, viewForFooterInSection section: Int) -> UIView?
    
    @objc optional func tableLayout(tableLayout: BaseTableLayout, cellForRowAt indexPath: IndexPath) -> UITableViewCell?

    @objc optional func tableLayoutSectionIndexTitle(tableLayout: BaseTableLayout) -> [String]?
    
    /// 自定义空视图
    /// - Returns: description
    @objc optional func tableLayoutEmptyDataView()->UIView?
}

@objc public protocol BaseTableLayoutDelegate:NSObjectProtocol {
    
    @objc optional func tableLayout(tableLayout: BaseTableLayout, didSelectRowAt indexPath: IndexPath)
    
}

open class BaseTableLayout: TGRelativeLayout {
    
   private  weak var tableView:UITableView!
 
    /// 空视图是否显示
    open var emptyDataSetShouldDisplay = false{
        didSet{
            self.tableView.reloadEmptyDataSet()
        }
    }
    
    /// 数据源
    open var dataList = [Any]()
    
    weak open var layoutDataSource:BaseTableLayoutDataSource?
    
    weak open var layoutDelegate:BaseTableLayoutDelegate?
    
    ///cell重用标识符
    open var cellReusIdentifier:String?{
        didSet{
            guard let str = cellReusIdentifier else { return }
            registerCell(for: str)
        }
    }
    ///背景颜色
    open var tableBackgroundColor: UIColor?{
        didSet{
            self.backgroundColor = tableBackgroundColor
            self.tableView.backgroundColor = tableBackgroundColor
        }
    }
    ///行高
    open var rowHeight:CGFloat = 40.0{
        didSet{
            self.tableView.rowHeight = rowHeight
        }
    }
    ///是否开启cell高度自适应
    open var isAutoHeightCell:Bool = true{
        didSet{
            if isAutoHeightCell {
                tableView.estimatedRowHeight = 150
                #if swift(>=4.2)
                tableView.rowHeight = UITableView.automaticDimension
                #else
                tableView.rowHeight = UITableViewAutomaticDimension
                #endif
            }
        }
    }
    
    public convenience init(style:UITableView.Style) {
        self.init(frame: CGRect.zero)
        let table = UITableView.init(frame: CGRect.zero, style: style)
        table.delegate = self
        table.dataSource = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.tg_width.equal(.fill)
        table.tg_height.equal(.fill)
        addSubview(table)
        tableView = table
//        configTable()
//        loadingView.tg_width.equal(.fill)
//        loadingView.tg_height.equal(.fill)
//        addSubview(loadingView)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
}
///定义常用的方法
extension BaseTableLayout{
    ///配置table
    open func configTable(){
        
    }
    ///添加下拉刷新
    open func addHeader(closure: @escaping () -> Void){
        tableView.addHeaderWithClosure {
            closure()
        }
    }
    ///添加上拉加载
    open func addFooter(closure: @escaping () -> Void){
        tableView.addFooterWithClosure {
            closure()
        }
    }
    ///开始刷新
    open func beginRefreshing(){
        tableView.beginRefreshing()
    }
    ///停止刷新
    open func endRefreshing(){
        tableView.endRefreshing()
    }
    ///提示没有更多的数据
    open func noMoreData(){
        tableView.noMoreData()
    }
    ///重置没有更多的数据
    open func resetMoreData(){
        tableView.resetMoreData()
    }
    ///刷新数据
    open func reloadData(){
        tableView.reloadData()
    }
    ///刷新空视图
    open func reloadEmptyData(){
        tableView.reloadEmptyDataSet()
    }
    /// 刷新指定的行
    /// - Parameter indexPaths: indexPaths description
    open func reloadRows(indexPaths:[IndexPath]?,animationed:UITableView.RowAnimation){
        guard let index = indexPaths else {
            return
        }
        tableView.reloadRows(at: index, with: animationed)
    }
    
    /// 刷新指定的section
    /// - Parameters:
    ///   - sections: sections description
    ///   - animationed: animationed description
    open func reloadSections(sections:IndexSet,animationed:UITableView.RowAnimation){
        tableView.reloadSections(sections, with: animationed)
    }
    
    /// 注册cell
    /// - Parameter cellReuseIdentifier: cellReuseIdentifier description
    open func registerCell(for cellReuseIdentifier:String){
        tableView.register(loadClassFromClassNameString(cellReuseIdentifier), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    /// 注册头和尾
    /// - Parameter reuseIdentifier: reuseIdentifier description
    open func registerheaderFooterView(reuseIdentifier:String){
        tableView.register(loadClassFromClassNameString(reuseIdentifier), forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    /// 获取cell
    /// - Parameters:
    ///   - cellReuseIdentifierStr: cellReuseIdentifierStr description
    ///   - indexPath: indexPath description
    /// - Returns: description
    open func dequeueReusableCell(cellReuseIdentifierStr:String,indexPath:IndexPath)->UITableViewCell{
        return tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierStr, for: indexPath)
    }
    
    /// 获取头和尾
    /// - Parameter reuseIdentifier: reuseIdentifier description
    /// - Returns: description
    open func dequeueReusableHeaderFooterView(reuseIdentifier:String)->UIView{
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) ?? UIView()
    }
    
    /// 根据类名生成类
    /// - Parameter classString: 类名
    /// - Returns: description
    open func loadClassFromClassNameString(_ classString: String) -> AnyClass? {
        guard let bundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return nil
        }
        var anyClass: AnyClass? = NSClassFromString(bundleName + "." + classString)
        if (anyClass == nil) {
            anyClass = NSClassFromString(classString)
        }
        return anyClass
    }
}
///实现UITableViewDelegate,UITableViewDataSource
extension BaseTableLayout:UITableViewDelegate,UITableViewDataSource{
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return layoutDataSource?.tableLayoutNumberOfSections?(tableLayout: self) ?? 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layoutDataSource?.tableLayout?(tableLayout: self, numberOfRowsInSection: section) ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        cell = layoutDataSource?.tableLayout?(tableLayout: self, cellForRowAt: indexPath)
        if cell == nil {
            if let cellReusStr = cellReusIdentifier {
                cell = dequeueReusableCell(cellReuseIdentifierStr: cellReusStr, indexPath: indexPath)
            }
        }
        return cell!
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return layoutDataSource?.tableLayout?(tableLayout: self, heightForHeaderInSection: section) ?? 0.0
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return layoutDataSource?.tableLayout?(tableLayout: self, heightForFooterInSection: section) ?? 0.0
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return layoutDataSource?.tableLayout?(tableLayout: self, viewForFooterInSection: section)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return layoutDataSource?.tableLayout?(tableLayout: self, viewForFooterInSection: section)
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataList.count <= 0  {
            return
        }
        layoutDelegate?.tableLayout?(tableLayout: self, didSelectRowAt: indexPath)
    }
}
///实现DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
extension BaseTableLayout:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    
    open func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    open func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return emptyDataSetShouldDisplay
    }
    
    open func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return layoutDataSource?.tableLayoutEmptyDataView?()
    }
}
