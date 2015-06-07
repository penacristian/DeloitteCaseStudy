//
//  CategoryCollectionViewCell.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/5/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    private var _category:Category?
    var category:Category? {
        get {
            return _category
        } set (value) {
            _category = value
            if let value = value {
                categoryNameLabel.text = value.categoryName
                categoryImage.image = UIImage(named: value.categoryName)
                if value.categoryName.hasPrefix("Men") {
                    visualEffectView.backgroundColor = Theme.getMensTintWithAlpha(0.2)
                } else {
                    visualEffectView.backgroundColor = Theme.getWomensTintWithAlpha(0.2)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryNameLabel.text = ""
    }

}
