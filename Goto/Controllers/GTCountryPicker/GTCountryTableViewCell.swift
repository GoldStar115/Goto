//
//  GTCountryTableViewCell.swift
//  Goto
//
//  Created by Adrian Rusin on 1/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class GTCountryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(country: GTCountry) {
        lblFlag.text = country.emojiFlag
        lblName.text = country.name
    }
}
