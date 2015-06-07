//
//  CategoryViewController.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/7/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class CategoryViewController: ProductsViewController {

    var category:Category? {
        didSet {
            if let category = category {
                products = category.getProducts()
            } else {
                products = [Product]()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = category?.categoryName

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
