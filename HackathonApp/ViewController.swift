//
//  ViewController.swift
//  HackathonApp
//
//  Created by Matthew Curtis on 8/3/15.
//  Copyright (c) 2015 Matthew Curtis. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"


class ViewController: UICollectionViewController{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    var Albums = Array<String>()
    
    
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


        
        Albums = ["Icon-Small-50.png",  "Icon-Small-50.png", "Icon-Small-50.png", "Icon-Small-50.png", "Icon-Small-50.png", "f.png", "g.png", "h.png", "i.png", "j.png", "k.png", "l.png", "m.png"]
    }
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        println()
    }
    
    
    // #pragma mark UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView?) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        return Albums.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        /*
        We can use multiple way to create a UICollectionViewCell.
        */
        
        
        //1.
        //We can use Reusablecell identifier with custom UICollectionViewCell
        
        /*
        let cell = collectionView!.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        var AlbumImage : UIImageView = cell.viewWithTag(100) as UIImageView
        AlbumImage.image = UIImage(named: Albums[indexPath.row])
        */
        
        
        
        //2.
        //You can create a Class file for UICollectionViewCell and Set the appropriate component and assign the value to that class
        
        let cell : CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.backgroundView = UIImageView(image: UIImage(named: "photo-frame.png")) as UIView
        cell.AlbumImage?.image = UIImage(named: Albums[indexPath.row])
        
        return cell
    }
    
    func deletePhoto(sender:UIButton) {
        let i : Int = (sender.layer.valueForKey("index")) as! Int
        Albums.removeAtIndex(i)
        self.collectionView!.reloadData()
    }
}



