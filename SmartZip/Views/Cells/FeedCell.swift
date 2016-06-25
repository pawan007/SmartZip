//
//  FeedCell.swift
//  SmartZip
//
//  Created by Pawan Kumar on 07/06/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit

protocol FeedCellDelegate1: class {
    func heartClick(index: NSInteger)
}

class FeedCell: UITableViewCell {
    
    weak var delegate: FeedCellDelegate?
    @IBOutlet weak var name: UILabel!
    var index: NSInteger! = 0
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var imageHighConst: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let screenRatio = (UIScreen.mainScreen().bounds.size.width / CGFloat(Constants.DEFAULT_SCREEN_RATIO))
        let imgHight = 200 * screenRatio
        self.imageHighConst.constant=imgHight
        
        
        /*
         let url:NSURL? = NSURL(string: "http://www.blueevents-agency.com/wp-content/uploads/2013/11/explore-events-food-and-wine-events.jpg")
         
         
         //        
         let progressiveImageView = CCBufferedImageView(frame: feedImage.bounds)
         
         if let urlP = NSURL(string: "http://www.pooyak.com/p/progjpeg/jpegload.cgi?o=1") {
         progressiveImageView.load(url!)
         feedImage.addSubview(progressiveImageView)
         }
         
         */
        
        let url:NSURL? = NSURL(string: "http://www.blueevents-agency.com/wp-content/uploads/2013/11/explore-events-food-and-wine-events.jpg")
        
        feedImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "img_shadow"))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: Control Actions
    @IBAction private func heartClick(sender: UIButton) {
        sender.selected  = !sender.selected;
        if (self.delegate != nil) {
            self.delegate?.heartClick(index)
        }
    }
    
    
}


 