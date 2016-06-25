//
//  UIFont+Additions.swift
//
//  Created by Pawan Joshi on 12/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
// MARK: - UIFont Extension
extension UIFont {
    func helvaticaNewBold(size: CGFloat) -> UIFont {
        return UIFont(name: "helvetica", size: size)!
    }
    
    func proximaRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNovaA-Regular", size: size)!
    }
}