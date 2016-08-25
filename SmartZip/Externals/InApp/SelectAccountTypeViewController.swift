
//
//  File.swift
//  HolidayHappenings
//
//  Created by Gurkaran Singh on 10/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//



import UIKit
import AVFoundation
import StoreKit
/*

class SelectAccountTypeViewController: BaseViewController {
    var currentPageIndex = 0
    @IBOutlet weak var verticalConstraintScrollView: NSLayoutConstraint!
    @IBOutlet weak private var pageControl: UIPageControl!
    
     var products = [SKProduct]()
    
    override func viewDidLoad() {
        self.backButtonRequired = false
        self.title = "Select Account Type"
        super.viewDidLoad()
        
        self.pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "ic_pagination_off")!)
        self.pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "ic_pagination_on")!)
        
        if (UIDevice().screenType == UIDevice.ScreenType.iPhone5  ||
            UIDevice().screenType == UIDevice.ScreenType.iPhone4) {
            
            verticalConstraintScrollView.constant = 60;
        }
        
        // Do any additional setup after loading the view.
        
        // Fetch Product list
       // NSNotificationCenter.defaultCenter().postNotificationName(IAPHelper.IAPHelperPurchaseNotification, object: identifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SelectAccountTypeViewController.purchasedProduct(_:)), name: IAPHelper.IAPHelperPurchaseNotification, object: nil)

        products = []
        self.fetchInAppProducts()
        
    }
    
    @IBAction func btnGetNowAction(sender: UIButton) {
        
        // let loginView : UIViewController = AppDelegate.rootControllerForLoggenInUser()
        // AppDelegate.delegate().window?.rootViewController = loginView
        
        if sender.tag == 10 {
            // 3 months
            for tempSkProduct in self.products {
                if tempSkProduct.productIdentifier ==  "com.holidayhappenings.app.removeFullPageAds" {
                 print("PriceLOcal is \(tempSkProduct.priceLocale) and price is \(tempSkProduct.price)")
                 self.willPurchaseProduct(tempSkProduct)
                }
            }
        }
            
        else if sender.tag == 20 {
            // 12 months
            for tempSkProduct in self.products {
                if tempSkProduct.productIdentifier ==  "com.holidayhappenings.app.removeFullPageAds" {
                    self.willPurchaseProduct(tempSkProduct)
                }
            }
        }
    }
    
    func willPurchaseProduct (str:SKProduct) {
        if RageProducts.store.isProductPurchased(str.productIdentifier) {
            let alert = UIAlertController(title: "In-App Purchase", message: "You are already subscribed to this plan", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            print("product purchased")
        }
        else if IAPHelper.canMakePayments() {
            print("product can make payment")
            self.view.showLoader(mainTitle: NSLocalizedString("Purchasing \(str.localizedTitle)", comment: ""), subTitle: NSLocalizedString("Just a moment", comment: ""))
            RageProducts.store.buyProduct(str)
        }
        else {
            // TODO : Handle already buy
        }
    }
    
    func purchasedProduct(noti:NSNotification) {
        self.view.hideLoader()
        let loginView : UIViewController = AppDelegate.rootControllerForLoggenInUser()
        AppDelegate.delegate().window?.rootViewController = loginView
    }

    
    //MARK : In App (Request Product)
    func fetchInAppProducts () {
        self.view.showLoader(mainTitle: NSLocalizedString("Fetching subscription plans", comment: ""), subTitle: NSLocalizedString("Just a moment", comment: ""))
        
        RageProducts.store.requestProducts{success, products in
            
            self.view.hideLoader()
            if success {
                self.products = products!
            }
            else {
                //TODO: Handle product not found
            }
        }
    }
}


extension SelectAccountTypeViewController: UIScrollViewDelegate {
    
    // MARK: - ScrollViewDelegates
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pNumber = Int(roundf(Float(scrollView.contentOffset.x)/Float(scrollView.bounds.size.width)))
        self.pageControl.currentPage = pNumber
        self.pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "ic_pagination_on")!)
        self.currentPageIndex = pNumber
    }
}
 */