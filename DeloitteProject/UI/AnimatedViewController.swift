//
//  AnimatedViewController.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/7/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import UIKit

class AnimatedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UITableView animations
    func animateTableView(tableView:UITableView) {
        tableView.reloadData()
        let cells = tableView.visibleCells()
        var tableWidth = tableView.bounds.size.width
        
        let offsetPoint = CGPointMake(tableView.frame.origin.x, 0)
        tableView.setContentOffset(offsetPoint, animated: false)
        
        var index:CGFloat = 0.0;
        for cell in cells {
            let currentCell = cell as! UITableViewCell;
            let delayOffset = Double(0.1 * index + 0.1);
            currentCell.frame.origin = CGPointMake(tableWidth, currentCell.frame.origin.y);
            UIView.animateWithDuration(0.5,
                delay: delayOffset,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.05,
                options:UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    currentCell.frame.origin = CGPointMake(0, currentCell.frame.origin.y);
                }, completion: { finished in
            });
            index += 1.0;
        }
    }

    func animateCollectionView(collectionView:UICollectionView) {
        if let cells = collectionView.visibleCells().sorted({$0.indexPath?.item < $1.indexPath?.item}) as? [CategoryCollectionViewCell] {
            var index:CGFloat = 0.0
            for cell in cells {
                let currentCell = cell
                currentCell.transform = CGAffineTransformMakeScale(0.0, 0.0)
                let delayOffset = Double(0.05 * index)
                UIView.animateWithDuration(1.0, delay: delayOffset, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    currentCell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    }, completion: nil)
                index += 1.0
            }
        }
    }

}
