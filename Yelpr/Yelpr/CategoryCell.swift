//
//  CategoryCell.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/3/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate: class {
    func category(cell: CategoryCell, didChangeValue value: Bool)
}

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    weak var delegate: CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func catgeoryChanged(_ sender: Any) {
        delegate?.category(cell: self, didChangeValue: categorySwitch.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
