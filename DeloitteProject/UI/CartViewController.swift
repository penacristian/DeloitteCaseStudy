//
//  CartViewController.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/7/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class CartViewController: ProductsViewController, ProductTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        updateCart()
        super.viewWillAppear(animated)
    }
    
    func updateCart() {
        products = ShoppingCart.activeCart.getProducts()
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if ShoppingCart.activeCart.getTotalPrice() > 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("CartTableViewFooter") as! CartTableViewFooter
            cell.price = ShoppingCart.activeCart.getTotalPrice()
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if ShoppingCart.activeCart.getTotalPrice() > 0 {
            return 60
        } else {
            return 0
        }
    }
    
    override func productTableViewCellDidEndUpdatingCart(cell: ProductTableViewCell) {
        updateCart()
        productsTableView.reloadData()
        super.productTableViewCellDidEndUpdatingCart(cell)
    }
}
