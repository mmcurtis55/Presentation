//
//  ViewController.swift
//  HackathonApp
//
//  Created by Matthew Curtis on 8/3/15.
//  Copyright (c) 2015 Matthew Curtis. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
import QuickLook

let reuseIdentifier = "MenuIconCell"


class ViewController:  UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    
    // constants
    struct MenuConstants {
        static let NUMBER_OF_CELLS_PER_ROW = CGFloat(3)  // change this to be the number of cells you want on a row
        static let SIGNIN = "Sign In"
        static let SIGNOUT = "Sign Out"
        static let INTERCELL_SPACE = CGFloat(22)
        static let SIDE_MARGIN = CGFloat(22)
        static let TB_MARGIN = CGFloat(10)
    }
    
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else  {
            return nil
        }
        }()
    
    
    
    // TODO: lazy inst
    var bgView = UIView()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view, typically from a nib.
        self.revealViewController().rearViewRevealWidth = 120
        self.revealViewController().rearViewRevealOverdraw = 30

        
        //Collection view stuff
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 90, height: 90)
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        collectionView!.dataSource = self
//        collectionView!.delegate = self
//        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
//        collectionView!.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(collectionView!)
        
        
        
        
        
        //hidesBottomBarWhenPushed = true
        
        // add the image to
        if let bgImg = UIImage(named: "bgImage") {
            
            bgView = UIImageView(image: bgImg)
            bgView.contentMode = UIViewContentMode.ScaleAspectFill
            bgView.frame = self.view.frame
            
            
            
            self.collectionView?.backgroundView = bgView
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // this animation looks like the text in the cell is zooming in
        
        // scale to 10% in the x and y axes
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        cell.layer.opacity = 0
        
        // random from =.5 to 1.5 sec
        let randomDuration = Double(arc4random()) / Double(UINT32_MAX) + 0.5
        
        let delay :NSTimeInterval = 0.0
        let damping : CGFloat = 0.5
        let initialSpringVelocity : CGFloat = 0
        
        UIView.animateWithDuration(randomDuration,
            delay: delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: initialSpringVelocity,
            options: .CurveEaseInOut,
            animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
                cell.layer.opacity = 1
            },
            completion: {success in
        })
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let h = collectionView.layer.frame.height
            
            // by default assume 3 cells per row
            let numOfCells = MenuConstants.NUMBER_OF_CELLS_PER_ROW
            let marginBetweenCells = MenuConstants.INTERCELL_SPACE
            // this margin will govern the size of the width
            let margin = (numOfCells - 1) * marginBetweenCells
            let effectiveWidth = (collectionView.layer.frame.width - sectionInsets.left - sectionInsets.right - margin)
            let w = effectiveWidth/numOfCells
            
            return CGSize(width: w, height: w)
    }
    
    // private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let sectionInsets = UIEdgeInsets(top: MenuConstants.TB_MARGIN,
        left: MenuConstants.SIDE_MARGIN, bottom: MenuConstants.TB_MARGIN, right: MenuConstants.SIDE_MARGIN)
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let rect = CGRect(x: 0,y: 0, width: size.width, height: size.height)
        bgView.frame = rect
        //        blurEffectView.frame = rect
    }
}