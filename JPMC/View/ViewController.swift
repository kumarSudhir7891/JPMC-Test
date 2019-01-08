//
//  ViewController.swift
//  JPMC Test
//
//  Created by Sudhir Kumar on 07/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    @IBOutlet weak var tableViewBase : UIView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!

    var tableView : ReusableTableView <RefreshableTableView,BaseConfiguratorSection , BaseTableViewCell , BaseHeaderFooterTableView> = {
        let tableView = ReusableTableView<RefreshableTableView,BaseConfiguratorSection , BaseTableViewCell, BaseHeaderFooterTableView>()
        return tableView
    }()
    let viewModel = ViewControllerViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addOnSuperView(superView: self.tableViewBase)
        self.setUpViewModelBinding()
        self.fetchPlanetDetails(showIndicator: true)
        self.tableView.tableView.addRefreshControl().addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchPlanetDetails(showIndicator : Bool) {
        if showIndicator {
            activityIndicator.startAnimating()
        }
        self.viewModel.getPlanetDetails {[unowned self] (serviceError) in
            if showIndicator {
                self.activityIndicator.stopAnimating()
            }else {
                self.tableView.tableView.endRefreshing()
            }
        }
    }
    func setUpViewModelBinding()  {
        self.viewModel.fetchData = {[unowned self](datasource) in
           
            self.tableView.setUp(dataSource: datasource, arrRegisterCells: [PlanetNameTableViewCell.self], arrRegisterHeader: nil)
        }
    }
    @objc func pullToRefresh() {
        self.viewModel.resetDataSource()
        self.fetchPlanetDetails(showIndicator : false)
    }

}

