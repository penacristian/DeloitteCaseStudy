//
//  ProductsViewController.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/6/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class ProductsViewController: AnimatedViewController, UITableViewDataSource, UITableViewDelegate, ProductTableViewCellDelegate {

    @IBOutlet weak var productsTableView: UITableView!
    var progressHUD:ProgressHUD?
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Theme.setUpViewController(self)
        productsTableView.registerNib(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animateTableView(productsTableView)
    }
    
    // MARK: UITableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProductTableViewCell") as! ProductTableViewCell
        cell.product = products[indexPath.row]
        cell.delegate = self
        return cell
    }
   
    // MARK: UITableView Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
        
    // MARK: ProductTabeViewCell Delegate
    func productTableViewCellDidStartUpdatingCart(cell: ProductTableViewCell) {
        productsTableView.userInteractionEnabled = false
        progressHUD = ProgressHUD(text: "Updating Cart")
        view.addSubview(progressHUD!)
    }
    
    func productTableViewCellDidEndUpdatingCart(cell: ProductTableViewCell) {
        productsTableView.userInteractionEnabled = true
        if let progressHUD = progressHUD {
            progressHUD.removeFromSuperview()
        }
        progressHUD = nil
    }
    
    func productTableViewCell(cell: ProductTableViewCell, didSendMessage message: String) {
        let alertView = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
}
