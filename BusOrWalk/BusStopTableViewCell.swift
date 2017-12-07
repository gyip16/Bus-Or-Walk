//
//  BusStopTableViewCell.swift
//  BusOrWalk
//
//  Created by Gabriel Yip on 2017-12-06.
//  Copyright © 2017 Gabriel Yip. All rights reserved.
//

import UIKit

class BusStopTableViewCell: UITableViewCell {

    @IBOutlet weak var BusStopNumber: UILabel!
    @IBOutlet weak var BusStopLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
