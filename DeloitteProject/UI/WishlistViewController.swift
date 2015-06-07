//
//  WishlistViewController.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/7/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class WishlistViewController: ProductsViewController, ProductTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        updateWishlist()
        super.viewWillAppear(animated)
    }
    
    func updateWishlist() {
        products = DataManager.sharedInstance.getWishlist()
    }
    
    // MARK: ProductTableViewCell Delegate
    func productTableViewCellDidUpdateWishlist(cell: ProductTableViewCell) {
        updateCell(cell)
    }

    override func productTableViewCellDidEndUpdatingCart(cell: ProductTableViewCell) {
        super.productTableViewCellDidEndUpdatingCart(cell)
        updateCell(cell)
    }
    
    func updateCell(cell:ProductTableViewCell) {
        updateWishlist()
        productsTableView.deleteRowsAtIndexPaths([productsTableView.indexPathForCell(cell)!], withRowAnimation: UITableViewRowAnimation.Left)
    }
}
