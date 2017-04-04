//
//  DealsCell.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/3/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit


protocol DealsCellDelegate : class {
    func dealSwitchChanged(val: Bool)
}

class DealsCell: UITableViewCell {

    weak var delegate: DealsCellDelegate?
    
    @IBAction func dealChanged(_ sender: Any) {
        self.delegate?.dealSwitchChanged(val: dealSwitch.isOn)
    }
    @IBOutlet weak var dealSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
