//
//  StandardDataSource.swift
//  Gather
//
//  Created by Sudhir Kumar on 22/11/18.
//  Copyright © 2018 Tilicho Labs. All rights reserved.
//

import Foundation
import UIKit

typealias Reusable_NibLoadableProtocol = ReuseIdentifier & NibLoadableView
typealias Reusable_NibLoadable_ViewProtocol = Reusable_NibLoadableProtocol & UIView

typealias Reusable_NibLoadable_TableViewCellProtocol = Reusable_NibLoadableProtocol & UITableViewCell
typealias Reusable_NibLoadable_TableViewHeader_Protocol = Reusable_NibLoadableProtocol & UITableViewHeaderFooterView
typealias Reusable_NibLoadable_CollectionViewCellProtocol = Reusable_NibLoadableProtocol & UICollectionViewCell
typealias TableViewCellProtocols = SetUpUserInterface & Reusable_NibLoadable_TableViewCellProtocol
typealias TableViewHeaderProtocols = SetUpUserInterface & Reusable_NibLoadable_TableViewHeader_Protocol

typealias CollectionViewCellProtocols = SetUpUserInterface & Reusable_NibLoadable_CollectionViewCellProtocol

public protocol ReuseIdentifier :class {
    
}
extension ReuseIdentifier where Self : UIView
{
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol NibLoadableView : class{
    
}
extension NibLoadableView where Self : UIView {
    static var nibName : String {
        return String(describing: self)
    }
    
}

public protocol ParentTableView where Self : UITableViewCell {
    var tableView : UITableView! {get set}
    var indexPath : IndexPath! {get set}
    
}

public protocol ClassName : class{
    
}
extension ClassName {
    var className : String {
        return String(describing: self)
    }
    static  var className : String {
        return String(describing: self)
    }
}


protocol ViewConfigurator   {
    func configure(view : UIView) -> Void
}
protocol CollectionTableConfigurator : ViewConfigurator {
    var reuseIdentifier: String {get}
}
protocol Section {
    var items:[CollectionTableConfigurator]{get set}
}
protocol SetUpUserInterface {
    associatedtype ModelDataType
    func setUpUserInterface(model : ModelDataType)-> Void
    
}


class BaseItemConfigurator<View :SetUpUserInterface & NibLoadableView & UIView, Model>: ViewConfigurator  where View.ModelDataType == Model  {
    let model : Model
    init(modelData : Model) {
        model = modelData
    }
    func configure(view: UIView) {
        guard let view_ = view as? View else {
            fatalError("\(type(of: view)) is confirming to Protocol \"SetUpUserInterface\" ")
        }
        view_.setUpUserInterface(model: model)
    }
}

class TableItemConfigurator<Cell : TableViewCellProtocols, Model>: BaseItemConfigurator<Cell , Model>,  CollectionTableConfigurator  where Cell.ModelDataType == Model  {
    var reuseIdentifier: String {
        return Cell.reuseIdentifier
    }
    override func configure(view: UIView) {
        guard let view_ = view as? Cell else {
            fatalError("\(type(of: view)) is confirming to Protocol \"TableViewCellProtocols\" ")
        }
        view_.setUpUserInterface(model: model)
    }
}
class TableHeaderItemConfigurator<Header : TableViewHeaderProtocols, Model>: BaseItemConfigurator<Header , Model>,  CollectionTableConfigurator  where Header.ModelDataType == Model  {
    var reuseIdentifier: String {
        return Header.reuseIdentifier
    }
    override func configure(view: UIView) {
        guard let view_ = view as? Header else {
            fatalError("\(type(of: view)) is confirming to Protocol \"TableViewCellProtocols\" ")
        }
        view_.setUpUserInterface(model: model)
    }
}


class BaseConfiguratorSection: Section {
    var items: [CollectionTableConfigurator] = [CollectionTableConfigurator]()
}

class DataSourceStandard <S:Section> {
    var sections:[S] = [S]()
    var headers:[CollectionTableConfigurator] = [CollectionTableConfigurator]()
    func numberOfRows(section : Int) -> Int {
        return sections[section].items.count
    }
    

    
    func getItem(indexPath:IndexPath) -> CollectionTableConfigurator?  {
        if let section = getSection(section: indexPath.section){
            return getItem(section: section, index: indexPath.item)
        }
        return nil
    }
    
    func removeSection(indexPath:IndexPath) -> Bool{
        if var section = getSection(section: indexPath.section){
            if section.items.count == 0 {
                sections.remove(at: indexPath.section)
                return true
            }
        }
        return false
    }
    func removeItem(indexPath:IndexPath) -> Bool {
        if var section = getSection(section: indexPath.section){
            if let _ = getItem(section: section, index: indexPath.item) {
                section.items.remove(at: indexPath.item)
                return true
            }
        }
        return false
    }
    func getSection(section : Int) -> S? {
        if sections.count > section {
            return sections[section]
        }
        return nil
    }
    func getHeader(section: Int) -> CollectionTableConfigurator? {
        if headers.count > section {
            return headers[section]
        }
        return nil
    }
    func getElementsCount() -> Int {
        var count = 0
        var index = 0
        for _ in sections {
            count = count + numberOfRows(section: index)
            index = index + 1
        }
        return count
        
    }
    private func getItem(section : S , index : Int) -> CollectionTableConfigurator? {
        if section.items.count > index {
            return section.items[index]
        }
        return nil
    }
}
