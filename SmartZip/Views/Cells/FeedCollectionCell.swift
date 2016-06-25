//
//  FeedCollectionCell.swift
//  HolidayHappenings
//
//  Created by Pawan Kumar on 16/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Kingfisher

protocol FeedCellDelegate: class {
    func heartClick(index: NSInteger)
}

class FeedCollectionCell: UICollectionViewCell {
    
    weak var delegate: FeedCellDelegate?
    var index: NSInteger! = 0
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var deal: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpUIWithData (eventObj : Event!) {
        
        self.title1.text = eventObj.product_title
        self.title2.text = eventObj.business_title
        self.title3.text = eventObj.location_name
        self.distance.text = String(format: "%.2f KM(s)", Double(eventObj.distance!)! )
        self.heart.selected = eventObj.is_favourite == "0" ? false : true
        self.activityLoader.alpha = 0
        self.activityLoader.stopAnimating()
        self.deal.hidden = true
        //let url:NSURL? = NSURL(string: eventObj.event_img!)
        //feedImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "img_shadow"))
        feedImage.kf_setImageWithURL(NSURL(string: eventObj.event_img!)!, placeholderImage: UIImage(named: "img_shadow"))
        
        
    }
    // MARK: Control Actions
    @IBAction private func heartClick(sender: UIButton) {
        // sender.selected  = !sender.selected;
        if (self.delegate != nil) {
            self.activityLoader.alpha = 1
            self.activityLoader.startAnimating()
            self.delegate?.heartClick(index)
        }
    }
    
    
}
