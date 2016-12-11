//
//  UIStoryboard+Additions.swift
//
//  Created by Pawan Joshi on 31/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIStoryboard Extension
extension UIStoryboard {

    /**
     Convenience Initializers to initialize storyboard.

     - parameter storyboard: String of storyboard name
     - parameter bundle:     NSBundle object
     
     - returns: A Storyboard object
     */
    convenience init(storyboard: String, bundle: Bundle? = nil) {
        self.init(name: storyboard, bundle: bundle)
    }
    
    
    /**
     Initiate view controller with view controller name.
    
     - returns: A UIView controller object
     */
    func instantiateViewController<T: UIViewController>() -> T {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = fullName.substring(from: range.upperBound)
        }
        
        guard let viewController = self.instantiateViewController(withIdentifier: fullName) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(fullName) ")
        }
        
        return viewController
    }
    
    class func dashboardStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Dashboard", bundle: nil)
    }
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    class func signUpStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "SignUp", bundle: nil)
    }
}
