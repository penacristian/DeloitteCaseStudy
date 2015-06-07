//
//  CartTableViewFooter.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/7/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class CartTableViewFooter: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var price:Double? {
        didSet {
            if price > 0 {
                totalPriceLabel.text = "£ \(price!)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

}
