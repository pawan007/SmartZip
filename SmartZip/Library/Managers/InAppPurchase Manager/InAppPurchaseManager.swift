//
//  InAppPurchaseManager.swift
//
//  Created by Pawan Kumar on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit
import Foundation
import StoreKit

class InAppPurchaseManager: NSObject {
    
    // MARK: - Constants
    struct Notifications {
        static let InAppProductPurchasedSuccessNotification = "InAppProductPurchasedSuccessNotification"
        static let InAppProductPurchasedFailedNotification = "InAppProductPurchasedFailedNotification"
        
        static let InAppProductRestoreSuccessNotification = "InAppProductRestoreSuccessNotification"
        static let InAppProductRestoreFailedNotification = "InAppProductRestoreFailedNotification"
    }
    
    private var productsRequest: SKProductsRequest?
    private var productIdentifiers: NSSet?
    typealias RequestProductsCompletionHandler = (error: NSError?, products: [SKProduct]?) -> ()
    typealias BuyProductsCompletionHandler = (error: NSError?) -> ()
    private var resultHandler: RequestProductsCompletionHandler?
    private var buyHandler: BuyProductsCompletionHandler?

    
    // MARK: - Singleton Instance
    private static let _sharedManager = InAppPurchaseManager()
    
    class func sharedManager() -> InAppPurchaseManager {
        return _sharedManager
    }
    
    private override init() {
        // customize initialization
        super.init()
    }
    
    
    // MARK: - Request Products
    func requestProducts(identifiers: NSSet, result: RequestProductsCompletionHandler) {
        
        guard let _:NSSet? = identifiers where identifiers.count > 0 else {
            return // do not proceed if no identifiers are provided
        }
        
        LogManager.logInfo("Checking products with iTunes Store")
        
        self.productIdentifiers = identifiers
        self.resultHandler = result
        
        self.productsRequest = SKProductsRequest.init(productIdentifiers: identifiers as! Set<String>)
        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }
    
    func buyProduct(product: SKProduct, quantity: NSInteger = 1, result: BuyProductsCompletionHandler) {
        self.buyHandler = result
        LogManager.logInfo("Purchase started..")
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector.init(), name: Constants.InAppProductPurchasedSuccessNotification, object: product)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector.init(), name: Constants.InAppProductPurchasedFailedNotification, object: product)

        let payment: SKMutablePayment! = SKMutablePayment(product: product)
        payment.quantity = quantity
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    /**
     Can make payment using device
     
     - returns: NO if this device is not able or allowed to make payments
     */
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments();
    }

    
    // MARK: - Request Restore
    func restorePurchases() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
}

extension InAppPurchaseManager: SKProductsRequestDelegate {
    
    // MARK: - Product Request Delegates
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        LogManager.logInfo("Loaded list of products...")
        LogManager.logInfo("Products = \(response.products)")
        LogManager.logInfo("Invalid products = \(response.invalidProductIdentifiers)")
        
        self.productsRequest = nil;
        
        let skProducts = response.products;
        if (self.resultHandler != nil) {
            self.resultHandler!(error: nil, products: skProducts)
        }
//        self.arrProducts = skProducts;
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
//        Logger.logError("Failed to load list of products = \(error)");
        self.productsRequest = nil
//        self.arrProducts = nil
        if (self.resultHandler != nil) {
            self.resultHandler!(error: error, products: nil)
        }
    }
    
    /*
    func requestDidFinish(request: SKRequest) {
        <#code#>
    }*/
}

extension InAppPurchaseManager: SKPaymentTransactionObserver {

    // MARK: - Product Payment Delegates
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: SKPaymentTransaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                transactionCompleted(transaction)
                break;
            case .Restored:
                transactionCompleted(transaction)
                break;
            case .Failed:
                transactionFailed(transaction)
                break;
            default: // Purchasing
                LogManager.logInfo("Purchasing product in progress..")
                break
            }
        }
    }
    
    private func transactionCompleted(transaction: SKPaymentTransaction) {
        self.buyHandler!(error: nil)
        LogManager.logInfo("transaction completed with \(transaction.transactionIdentifier)")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    private func transactionFailed(transaction: SKPaymentTransaction) {
        if transaction.error != nil {
            
            self.buyHandler!(error: NSError(domain: "InApp Purchase Failure", code: 408, userInfo: [NSLocalizedDescriptionKey: transaction.error!.localizedDescription]))
            SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        } else {
            self.buyHandler!(error: NSError(domain: "InApp Purchase Failure", code: 408, userInfo: [NSLocalizedDescriptionKey: "transaction failed."]))
        }

        LogManager.logInfo("transaction failed with error \(transaction.error)")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        LogManager.logInfo("Payment queue restore completed for transactions = \(queue.transactions)");
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        LogManager.logError("Payment queue restore failed = \(error)");
    }
}
