//
//  ReusableTableView.swift
//  MVVMWithRXSWift
//
//  Created by Sudhir Kumar on 21/11/18.
//  Copyright © 2018 Sudhir Kumar. All rights reserved.
//

import UIKit

class RefreshableTableView : UITableView , PullableTableView{
    
}

class ReusableTableView <TableView : UITableView,T: Section,Cell : Reusable_NibLoadable_TableViewCellProtocol , Header : Reusable_NibLoadable_ViewProtocol> : NSObject, UITableViewDataSource , UITableViewDelegate {
    var  dataSourceTableView :DataSourceStandard<T>!
    
    weak var delegate : UITableViewDelegate?
    private var style : UITableView.Style = UITableView.Style.grouped
    lazy var tableView : TableView = {
        let tableView = TableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: style)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: CGFloat.leastNormalMagnitude))
        tableView.backgroundColor = UIColor.white
        tableView.sectionHeaderHeight =  UITableView.automaticDimension
        tableView.rowHeight =  UITableView.automaticDimension

        return tableView
    }()
    init(with style : UITableView.Style) {
        self.style = style
        super.init()
        
    }
    override init() {
        super.init()
    }
    init(dataSource : DataSourceStandard<T> ,arrRegisterCells : [Cell.Type] , arrRegisterHeader : [Header.Type]?) {
        super.init()
        
        setUp(dataSource: dataSource, arrRegisterCells: arrRegisterCells, arrRegisterHeader: arrRegisterHeader)
    }
    
    func setUp(dataSource : DataSourceStandard<T> ,arrRegisterCells : [Cell.Type] , arrRegisterHeader : [Header.Type]?) {
        self.register(cells: arrRegisterCells)
        self.register(headers: arrRegisterHeader)
        dataSourceTableView = dataSource
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.separatorStyle = .none
        self.tableView.reloadData()
    }
    
    func addOnSuperView(superView : UIView){
        superView.insertSubview(self.tableView, at: 0)
        let constraints = NSLayoutConstraint.getSameFrameConstraint(subView: self.tableView, superView: superView)
        NSLayoutConstraint.activate(constraints)
    }
    
    func register(cells : [Cell.Type]) {
        for tableViewCell in cells {
            self.tableView.register(cell: tableViewCell)
        }
    }
    
    func register(headers : [Header.Type]?) {
        if let headers = headers {
            for header in headers {
                self.tableView.register(header: header)
            }
        }
    }
    
    
    //Mark : UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let configurator = dataSourceTableView.getHeader(section: section) else {
            return nil
        }
        guard let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: configurator.reuseIdentifier) as? Header else {
            fatalError("\(type(of: self)) Could not dequeue Table HeaderView in Section: \(section) with identifier \(configurator.reuseIdentifier)")
            
        }
        configurator.configure(view: header)
        return header
    }
    //Mark : UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let configurator = dataSourceTableView.getItem(indexPath: indexPath) else {
            fatalError("property dataSourceTableView  have less number of cells")
        }
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: configurator.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("\(type(of: self)) Could not dequeue cell with identifier \(configurator.reuseIdentifier)")
        }
        if var cell = cell as? ParentTableView {
            cell.tableView = tableView
            cell.indexPath = indexPath
        }
        
        configurator.configure(view: cell)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceTableView.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSourceTableView.numberOfRows(section: section)
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}
