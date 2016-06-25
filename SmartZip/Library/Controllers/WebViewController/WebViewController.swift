//
//  WebViewController.swift
//
//  Created by Pawan Kumar on 28/05/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

class WebViewController: BaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.title == nil {
            self.title = self.navigationItem.title
        }
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: self.urlString)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


extension WebViewController : UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.activityView.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityView.stopAnimating()
    }
}
