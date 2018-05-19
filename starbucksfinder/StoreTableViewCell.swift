//
//  StoreTableViewCell.swift
//  starbucksfinder
//
//  Created by CHico on 5/14/18.
//  Copyright © 2018 CHico. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
