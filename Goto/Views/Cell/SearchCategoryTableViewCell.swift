//
//  SearchCategoryTableViewCell.swift
//  Goto
//
//  Created by Adrian Rusin on 1/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SearchCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
