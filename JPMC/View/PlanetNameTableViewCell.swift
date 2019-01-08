//
//  PlanetNameTableViewCell.swift
//  JPMC Test
//
//  Created by Sudhir Kumar on 08/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//

import UIKit

protocol PlanetModelProtocol {
    var name :String {get set}
}

struct PlanetModel : PlanetModelProtocol {
    var name : String
}
class BaseTableViewCell : UITableViewCell ,  Reusable_NibLoadableProtocol{
    
}
class BaseHeaderFooterTableView: UITableViewHeaderFooterView , Reusable_NibLoadableProtocol {
    
}
class PlanetNameTableViewCell: BaseTableViewCell {

    @IBOutlet weak var lblName : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension PlanetNameTableViewCell : SetUpUserInterface {
    func setUpUserInterface(model: PlanetModelProtocol) {
        self.lblName.text = model.name
    }
    
}
