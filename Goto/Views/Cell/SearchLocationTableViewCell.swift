//
//  SearchLocationTableViewCell.swift
//  Goto
//
//  Created by Adrian Rusin on 1/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SearchLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
