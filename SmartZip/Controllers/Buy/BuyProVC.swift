//
//  BuyProVC.swift
//  SmartZip
//
//  Created by Narender Kumar on 8/10/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import UIKit

// In-APP
import AVFoundation
import StoreKit

class BuyProVC: UIViewController {
    
    @IBOutlet weak var fullPageAdsBtn: UIButton!
    @IBOutlet weak var bannerAdsBtn: UIButton!
    @IBOutlet weak var restoreBtn: UIButton!
    
    var isShowRestoreBtn:Bool = false
    
    
    // In-App
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In-App
        self.fetchInAppProducts()
        self.registerNotificationForInApp()
        
        if (!isShowRestoreBtn) {
            restoreBtn.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // In-App
    func registerNotificationForInApp () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.purchasedProduct(_:)), name: IAPHelper.IAPHelperPurchaseNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.productPurchaseFailed(_:)), name: IAPHelper.IAPHelperPurchaseFailedNotification, object: nil)
        products = []
    }
    
    //MARK : In App (Request Product)
    func fetchInAppProducts () {
        self.view.showLoader(mainTitle: NSLocalizedString("Fetching subscription plans", comment: ""), subTitle: NSLocalizedString("Just a moment...", comment: ""))
        
        RageProducts.store.requestProducts{success, products in
            self.view.hideLoader()
            if success {
                self.products = products!
                self.setPriceStringOnButtons(self.products)
            }
            else {
                let alert = UIAlertController(title: "In-App Purchase", message: "Ooppss...we are unable to connect iTune Store please try after some time", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func localizedPrice(product:SKProduct) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = product.priceLocale
        return formatter.stringFromNumber(product.price)!
    }
    
    func setPriceStringOnButtons(products: [SKProduct]?) {
        for tempSkProduct in products! {
            let priceString = localizedPrice(tempSkProduct)
            if tempSkProduct.productIdentifier ==  RageProducts.removeFullPageAds {
                fullPageAdsBtn.setTitle("\(fullPageAdsBtn.currentTitle!) (\(priceString))", forState: UIControlState.Normal)
                if(RageProducts.store.isProductPurchased(tempSkProduct.productIdentifier)) {
                    self.setTextOnButton(tempSkProduct.productIdentifier)
                }
            }
            if tempSkProduct.productIdentifier ==  RageProducts.removeBannerAds {
                bannerAdsBtn.setTitle("\(bannerAdsBtn.currentTitle!) (\(priceString))", forState: UIControlState.Normal)
                if(RageProducts.store.isProductPurchased(tempSkProduct.productIdentifier)) {
                    self.setTextOnButton(tempSkProduct.productIdentifier)
                }
            }
        }
    }
    
    @IBAction func removeFullPageAdsAction(sender: AnyObject) {
        for tempSkProduct in self.products {
            if tempSkProduct.productIdentifier ==  RageProducts.removeFullPageAds {
                print("PriceLocal is: \(tempSkProduct.priceLocale) and price is: \(tempSkProduct.price)")
                self.willPurchaseProduct(tempSkProduct)
            }
        }
    }
    
    @IBAction func removeBannerAdsAction(sender: AnyObject) {
        for tempSkProduct in self.products {
            if tempSkProduct.productIdentifier ==  RageProducts.removeBannerAds {
                print("PriceLocal is: \(tempSkProduct.priceLocale) and price is: \(tempSkProduct.price)")
                self.willPurchaseProduct(tempSkProduct)
            }
        }
    }
    
    @IBAction func restorePurchasedAction(sender: AnyObject) {
        self.view.showLoader(mainTitle: NSLocalizedString("Restore Items", comment: ""), subTitle: NSLocalizedString("Just a moment", comment: ""))
        
        RageProducts.store.restorePurchases()
    }
    
    
    //MARK: In App Purchase Methods
    func willPurchaseProduct (product:SKProduct) {
        if RageProducts.store.isProductPurchased(product.productIdentifier) {
            let alert = UIAlertController(title: "In-App Purchase", message: "You are already subscribed to this plan", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            print("product purchased")
        }
        else if IAPHelper.canMakePayments() {
            print("product can make payment")
            self.view.showLoader(mainTitle: NSLocalizedString("Purchasing \(product.localizedTitle)", comment: ""), subTitle: NSLocalizedString("Just a moment", comment: ""))
            RageProducts.store.buyProduct(product)
            
            self.setTextOnButton(product.productIdentifier)
        }
        else {
            // TODO : Handle already buy
        }
    }
    
    func purchasedProduct(notification:NSNotification) {
        self.view.hideLoader()
        // The product has been purchase , go to rootViewController for the app.
        let identifier = notification.object as? String
        if(identifier ==  RageProducts.removeFullPageAds) {
            CommonFunctions.sharedInstance.setBOOLToUserDefaults(true, key:kIsRemovedFullPageAds)
        }
        else if(identifier ==  RageProducts.removeBannerAds) {
            CommonFunctions.sharedInstance.setBOOLToUserDefaults(true, key:kIsRemovedBannerAds)
        }
        self.setTextOnButton(identifier!)
    }
    
    func productPurchaseFailed(notification:NSNotification) {
        self.view.hideLoader()
    }
    
    func setTextOnButton (productIdentifierString:String) {
        if productIdentifierString == RageProducts.removeFullPageAds {
            fullPageAdsBtn.setTitle("Remove Full Page Ads Purchased", forState: UIControlState.Normal)
        }
        else if productIdentifierString ==  RageProducts.removeBannerAds {
            bannerAdsBtn.setTitle("Remove Footer Ads Purchased", forState: UIControlState.Normal)
        }
    }
    
    
    
    @IBAction func menuButtonAction(sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
    
}
