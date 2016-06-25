//
//  ProductCell.swift
//
//  Created by Sourabh Bhardwaj on 31/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

protocol ProductCellDelegate: class {
    func beginPurchase(index: NSInteger)
}

class ProductCell: UITableViewCell {

    weak var delegate: ProductCellDelegate?

    @IBOutlet weak var name: UILabel!
    var index: NSInteger! = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Control Actions
    @IBAction private func buyProduct(sender: AnyObject?) {
        if (self.delegate != nil) {
            self.delegate?.beginPurchase(index)
        }
    }
    
}
