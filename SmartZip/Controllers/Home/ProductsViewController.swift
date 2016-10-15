//
//  ProductsViewController.swift
//
//  Created by Pawan Kumar on 31/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit
import StoreKit

class ProductsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [SKProduct]! = []
    let productCellIdentifier: String = "product_cell"
    let productDetailSegueIdentifier: String = "product_detail_segue"
    
    
    // MARK: View Life cycle
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = NSLocalizedString("Available Products", comment: "Available Products")
        self.tableView.tableFooterView = UIView()
        
        // Create a Restore Purchases button and hook it up to restoreTapped
        let restoreButton = UIBarButtonItem(title: "Restore", style: .Plain, target: self, action: #selector(self.restoreTapped(_:)))
        
        // Enable view controller to listen observers
        addObservers()
        
        let productIdentifiers = NSSet(array: ["com.Modi.test.free_product_1","com.Modi.test.free_product_2"])
        //        InAppPurchaseManager.sharedManager().requestProducts(productIdentifiers) { (error, products) -> () in
        //
        //            if (error == nil) {
        //                if (products?.count > 0) {
        //                    self.products = products!
        //                    self.navigationItem.rightBarButtonItem = restoreButton
        //                    self.tableView.reloadData()
        //                } else {
        //                    LogManager.logInfo("No products found for identifiers = \(productIdentifiers)")
        //                    self.navigationItem.rightBarButtonItem = nil
        //                }
        //            } else {
        //                LogManager.logError("error in requesting products = \(error)")
        //            }
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func addObservers() {
        // Subscribe to a notification that fires when a product is purchased.
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductsViewController.productPurchased(_:)), name: InAppPurchaseManager.Notifications.InAppProductPurchasedSuccessNotification, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductsViewController.purchaseFailed(_:)), name: InAppPurchaseManager.Notifications.InAppProductPurchasedFailedNotification, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductsViewController.productsRestored(_:)), name: InAppPurchaseManager.Notifications.InAppProductRestoreSuccessNotification, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductsViewController.restoreFailed(_:)), name: InAppPurchaseManager.Notifications.InAppProductRestoreFailedNotification, object: nil)
    }
    
    
    // MARK: Navigation Method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == productDetailSegueIdentifier {
            //            if let destination = segue.destinationViewController as? ProductDetailVC {
            //                let indexPath:NSIndexPath! = sender as? NSIndexPath
            //                destination.productName = self.products[indexPath.row] as String
            //                destination.delegate = self
            //            }
        }
    }
    
    
    // MARK: - Private Actions
    // MARK: Purchase
    internal func beginPurchase(index: NSInteger) {
        //        if let _: Bool! = InAppPurchaseManager.sharedManager().canMakePurchases() {
        //            let product = self.products[index]
        //            LogManager.logInfo("selected product is = \(product.localizedTitle)")
        //
        //            InAppPurchaseManager.sharedManager().buyProduct(product, result: { (error) in
        //
        //            })
        //        } else {
        //            self.showAlertViewWithMessage("Whoops!", message: "Your device is not eligible for this purchase.")
        //        }
    }
    
    func productPurchased(notification: NSNotification) {
        LogManager.logInfo("Success !! product purchased")
        
        // give user credits for the purchase
        // hit api to update server, if needed
    }
    
    func purchaseFailed(notification: NSNotification) {
        let error: NSError? = notification.object as! NSError?
        LogManager.logError("Failure !! purchase failed = \(error)")
    }
    
    // MARK: Restore
    func restoreTapped(sender: AnyObject?) {
        LogManager.logInfo("restore products...")
        // InAppPurchaseManager.sharedManager().restorePurchases()
    }
    
    func productsRestored(notification: NSNotification) {
        LogManager.logInfo("Success !! products restored")
    }
    
    func restoreFailed(notification: NSNotification) {
        let error: NSError? = notification.object as! NSError?
        LogManager.logError("Failure !! restore failed = \(error)")
    }
}

extension ProductsViewController: UITableViewDataSource {
    
    // MARK: TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FeedCell! = self.tableView.dequeueReusableCellWithIdentifier(productCellIdentifier, forIndexPath: indexPath) as! FeedCell
        //        cell.delegate = self
        //        cell.index = indexPath.row
        //        let product = self.products[indexPath.row]
        //        cell.name.text = "\(product.localizedTitle) :Rs. \(product.price)"
        return cell;
    }
}

//extension ProductsViewController {
//    
//    // MARK: TableView Delegates
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//}

