//
//  FeedCell.swift
//  SmartZip
//
//  Created by Pawan Kumar on 07/06/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit
import Kingfisher

protocol FeedCellDelegate1: class {
    func heartClick(_ index: NSInteger)
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
        
        let screenRatio = (UIScreen.main.bounds.size.width / CGFloat(Constants.DEFAULT_SCREEN_RATIO))
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
        
        let url:URL? = URL(string: "http://www.blueevents-agency.com/wp-content/uploads/2013/11/explore-events-food-and-wine-events.jpg")
        imageView!.kf_setImageWithURL(url!, placeholderImage: UIImage(named: "img_shadow"))

     }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: Control Actions
    @IBAction fileprivate func heartClick(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected;
        if (self.delegate != nil) {
            self.delegate?.heartClick(index)
        }
    }
    
    
}


 
