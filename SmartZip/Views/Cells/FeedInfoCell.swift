//
//  FeedInfoCell.swift
//  HolidayHappenings
//
//  Created by Pawan Kumar on 14/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

protocol FeedInfoDelegate: class {
    func heartClick()
}


class FeedInfoCell: UITableViewCell {
    
    var images = NSMutableArray()
    weak var delegate: FeedInfoDelegate?
    
    @IBOutlet weak var falcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var deal: UIImageView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var imagePager: AFImagePager!
    @IBOutlet weak var imageHighConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenRatio = (UIScreen.mainScreen().bounds.size.width / CGFloat(Constants.DEFAULT_SCREEN_RATIO))
        let imgHight = 233 * screenRatio
        self.imageHighConst.constant=imgHight
    }
    func arrayWithImageUrlStrings() -> [AnyObject] {
        return images as [AnyObject]

    }
    
    func contentModeForImage(image: Int) -> UIViewContentMode {
        return UIViewContentMode.ScaleToFill

    }
    
//    func contentModeForImage(image: Int, inPager pager: AFImagePager) -> UIViewContentMode {
//        return UIViewContentMode.ScaleToFill
//        
//    }
 
//    func arrayWithImages(pager: AFImagePager) -> [AnyObject] {
//        return images as [AnyObject]
//    }
    
     func placeHolderImageForImagePager() -> UIImage! {
        
        return UIImage(named: "img_shadow")
    }
    
    func updateCellValues(data : ED_Event? , cellType :String) {
        
        self.activityLoader.alpha = 0
        self.activityLoader.stopAnimating()

        self.title.text = data!.product_title
        self.subTitle.text = data!.business_title
        self.deal.hidden = true
        self.heart.selected = data!.is_favourite == "0" ? false : true
        for item in data!.images! {
            images.addObject(item.event_img!)
        }
        imagePager.reloadData()
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // MARK: Control Actions
    @IBAction private func heartClick(sender: UIButton) {
        if (self.delegate != nil) {
            self.activityLoader.alpha = 1
            self.activityLoader.startAnimating()
            self.delegate?.heartClick()
        }
    }
    
}

















/*
 
 //
 //        let pageControlFrame: CGRect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, imgHight)
 //        self.imagePager.pageControl = UIPageControl(frame: pageControlFrame)
 //        self.imagePager.pageControl.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, imgHight - 30)
 
 
 
 //    internal func arrayWithImages() -> [AnyObject]!
 //    {
 //        return images as [AnyObject]
 //
 //    }
 
 //    internal func contentModeForImage(image: UInt) -> UIViewContentMode{
 //
 //        return UIViewContentMode.ScaleToFill
 //    }
 
 //        imageView.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
 //        imageView.pageControl.pageIndicatorTintColor = UIColor.blackColor()
 //        imageView.pageControl.center = CGPointMake(CGRectGetWidth(imageView.frame) / 2, CGRectGetHeight(imageView.frame) - 42)
 //imageView.clipsToBounds=true
 */
