//
//  BaseTableLayoutAdapter.swift
//  LHBaseLayout
//
//  Created by lanhao on 2021/5/24.
//

import Foundation
@objc public protocol BaseTableLayoutAdapterDelegate:NSObjectProtocol {
    func tableLayout(tableLayout: BaseTableLayout, didSelectItemAt itemData: Any,indexPath: IndexPath)
}
open class BaseTableLayoutAdapter : NSObject {
    open var page = 0
    open var tableLayout:BaseTableLayout!
    let pageSize = 20
    open var dataList = [Any]()
    weak public var adpaterDelegate:BaseTableLayoutAdapterDelegate?
    open var cellReusIdentifier:String?{
        didSet{
            guard let cell = cellReusIdentifier else { return }
            tableLayout.cellReusIdentifier = cell
        }
    }
    open var isLoading:Bool = true{
        didSet{
//            tableLayout.isLoading = isLoading
        }
    }
    open var emptyDataSetShouldDisplay:Bool = false{
        didSet{
            tableLayout.emptyDataSetShouldDisplay = emptyDataSetShouldDisplay
        }
    }
    //cell高度自适应 配合 TangramKit 一起实现
    open var isAutoHeightCell:Bool = true{
        didSet{
            tableLayout.isAutoHeightCell = isAutoHeightCell
        }
    }
    
    open  var tableBackgroundColor:UIColor?{
        didSet{
            tableLayout.tableBackgroundColor = tableBackgroundColor
        }
    }
    open var rowHeight:CGFloat = 0{
        didSet{
            tableLayout.rowHeight = rowHeight
        }
    }
    public convenience init(layout:BaseTableLayout,delegate:BaseTableLayoutAdapterDelegate?) {
        self.init()
        tableLayout = layout
        tableLayout.layoutDataSource = self
        tableLayout.layoutDelegate = self
        adpaterDelegate = delegate
        configTableLayout()
    }
    open func configTableLayout(){
        
    }
    
    open func refresh(){
        self.page = 0
        self.dataList.removeAll()
        loadData()
    }
    open func loadData(){
        
    }
    //添加上下拉刷新
    open func addtableLayoutHeader(){
        tableLayout.addHeader {
            self.refresh()
        }
    }
    open func addtableLayoutFooter(){
        tableLayout.addFooter {
            self.loadData()
        }
    }
    //开始刷新
    open func beginRefreshing(){
        tableLayout.beginRefreshing()
    }
    //停止刷新
    open func endRefreshing(){
        tableLayout.endRefreshing()
    }
    /** 提示没有更多的数据 */
    open func noMoreData(){
        tableLayout.noMoreData()
    }
    /** 重置没有更多的数据（消除没有更多数据的状态） */
    open func resetMoreData(){
        tableLayout.resetMoreData()
    }
    //获取到数据之后 需要手动调用一下 更新tableLayout数据源
    open func reloadData(){
        tableLayout.dataList = self.dataList
        tableLayout.reloadData()
    }
    open func reloadEmptyData(){
        tableLayout.reloadEmptyData()
    }
    /// 注册cell
    /// - Parameter cellReuseIdentifier: 标识符
    open func tableRegisterCell(cellReuseIdentifier:String){
        tableLayout.registerCell(for: cellReuseIdentifier)
    }
    
    /// 注册header 或者footer
    /// - Parameter reuseIdentifier: 重用标识符
    open func tableRegisterHeaderOrFooter(reuseIdentifier:String){
        tableLayout.registerheaderFooterView(reuseIdentifier: reuseIdentifier)
    }
    
    /// 获取重用的头尾试图
    /// - Parameter reuseIdentifier: 重用标识符
    /// - Returns: description
    open func tableGetReuserHeaderOrFooterView(reuseIdentifier:String)->UIView{
        return tableLayout.dequeueReusableHeaderFooterView(reuseIdentifier: reuseIdentifier)
    }
    
    
    /// 获取cell
    /// - Parameters:
    ///   - cellReuseIdentifier: 重用符
    ///   - indexPath: 下标
    /// - Returns: description
    open func tableDequeueReusableCell(cellReuseIdentifier:String,indexPath:IndexPath)->UITableViewCell{
        return tableLayout.dequeueReusableCell(cellReuseIdentifierStr: cellReuseIdentifier, indexPath: indexPath)
    }
    
}
extension BaseTableLayoutAdapter:BaseTableLayoutDataSource,BaseTableLayoutDelegate{
    
    open func tableLayoutNumberOfSections(tableLayout: BaseTableLayout) -> Int {
        return 1
    }
    
    open func tableLayout(tableLayout: BaseTableLayout, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    open func tableLayout(tableLayout: BaseTableLayout, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return nil
    }
    
    open func tableLayout(tableLayout: BaseTableLayout, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    open func tableLayout(tableLayout: BaseTableLayout, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    open func tableLayout(tableLayout: BaseTableLayout, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableLayout(tableLayout: BaseTableLayout, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableLayout(tableLayout: BaseTableLayout, didSelectRowAt indexPath: IndexPath) {
        adpaterDelegate?.tableLayout(tableLayout: tableLayout, didSelectItemAt: dataList[indexPath.row], indexPath: indexPath)
    }
    
    open func tableLayoutSectionIndexTitle(tableLayout: BaseTableLayout) -> [String]? {
        return nil
    }
    
    open func tableLayoutEmptyDataView() -> UIView? {
        return nil
    }
    
}
