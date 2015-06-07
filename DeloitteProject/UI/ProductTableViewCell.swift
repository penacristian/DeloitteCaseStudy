//
//  ProductTableViewCell.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/6/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

@objc protocol ProductTableViewCellDelegate {
    optional func productTableViewCellDidStartUpdatingCart(cell:ProductTableViewCell)
    optional func productTableViewCellDidEndUpdatingCart(cell:ProductTableViewCell)
    optional func productTableViewCell(cell:ProductTableViewCell, didSendMessage message:String)
    optional func productTableViewCellDidUpdateWishlist(cell:ProductTableViewCell)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var oldPriceCrossedView: UIView!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var addToWithlistButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var delegate:ProductTableViewCellDelegate?
    
    private var _product:Product?
    var product:Product? {
        get {
            return _product
        } set (value) {
            _product = value
            if let newProduct = value {
                productNameLabel.text = newProduct.productName
                productImageView.image = UIImage(named: newProduct.productName)
                priceLabel.text = "£ \(newProduct.price)"
                if newProduct.oldPrice != 0 {
                    oldPriceLabel.text = "£ \(newProduct.oldPrice)"
                    oldPriceLabel.hidden = false
                    oldPriceCrossedView.hidden = false
                }
                stockLabel.text = "Stock \(newProduct.stock)"
                updateWishlistButton()
                updateShoppingCartButton()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        product = nil
        productNameLabel.text = ""
        priceLabel.text = ""
        oldPriceLabel.text = ""
        stockLabel.text = ""
        oldPriceLabel.hidden = true
        oldPriceCrossedView.hidden = true
        addToWithlistButton.selected = false
    }
    
    @IBAction func addToWishlistButtonPressed(sender: UIButton) {
        if let product = product {
            product.isWishlisted = NSNumber(bool: (!product.isWishlisted.boolValue))
            addToWithlistButton.selected = !addToWithlistButton.selected
            delegate?.productTableViewCellDidUpdateWishlist?(self)
            DataManager.save(nil)
        }
    }
    
    @IBAction func addToCartButtonPressed(sender: UIButton) {
        if ShoppingCart.activeCart.containsItem(product!) {
            delegate?.productTableViewCellDidStartUpdatingCart!(self)
            ShoppingCart.activeCart.removeItem(product!, completion: { (result, error) -> Void in
                self.handleCompletion(result, error: error)
                self.delegate?.productTableViewCellDidEndUpdatingCart?(self)
            })
        } else {
            if product?.stock.integerValue > 0 {
                delegate?.productTableViewCellDidStartUpdatingCart?(self)
                ShoppingCart.activeCart.addItem(product!, completion: { (result, error) -> Void in
                    self.handleCompletion(result, error: error)
                })
            } else {
                delegate?.productTableViewCell?(self, didSendMessage: "Ups, no products left")
            }
        }
    }
    
    func updateWishlistButton() {
        if let product = product {
            addToWithlistButton.selected = product.isWishlisted.boolValue
        }
    }
    
    func updateShoppingCartButton() {
        if let product = product {
            addToCartButton.selected = ShoppingCart.activeCart.containsItem(product)
        }
    }
    
    func handleCompletion(result:AnyObject?,error:NSError?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if error == nil {
                self.updateShoppingCartButton()
                self.updateWishlistButton()
                self.delegate?.productTableViewCellDidEndUpdatingCart?(self)
            } else {
                self.delegate?.productTableViewCell?(self, didSendMessage:result as! String)
            }
        })
    }
}
