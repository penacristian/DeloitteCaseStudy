//
//  ViewController.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 5/6/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class CategoriesViewController: AnimatedViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var categories = [Category]()
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Theme.setUpViewController(self)
        getProducts()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animateCollectionView(categoriesCollectionView)
    }
    
    func getProducts() {
        Service.getProducts { (result, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil {
                    self.categories = DataManager.sharedInstance.getCategories()
                    self.categoriesCollectionView.reloadData()
                    self.categoriesCollectionView.layoutIfNeeded()
                    self.animateCollectionView(self.categoriesCollectionView)
                } else {
                    let alert = UIAlertView(title: result as? String, message: nil, delegate: nil, cancelButtonTitle: "Aceptar")
                    alert.show()
                }
            })
        }
    }
    
    // MARK: CollectionView DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCollectionViewCell", forIndexPath: indexPath) as! CategoryCollectionViewCell
        cell.category = categories[indexPath.item]
        return cell
    }
    
    // MARK: CollectionView Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return getItemSize()
    }

    func getItemSize() -> CGSize {
        let screenBounds = UIScreen.mainScreen().bounds
        return CGSize(width: screenBounds.size.width/2 - 15, height: (screenBounds.size.width/2 - 15)*4/3)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ProductsViewControllerSegue", sender: indexPath)
    }
    
    // MARK: Flow Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = sender as? NSIndexPath {
            let categoryViewController = segue.destinationViewController as! CategoryViewController
            categoryViewController.category = categories[indexPath.item]
        }
    }
}

