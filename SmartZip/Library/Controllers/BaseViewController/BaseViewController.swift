//
//  BaseViewController.swift
//
//  Created by Pawan Kumar on 20/05/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {
    
    fileprivate var _tapGesture: UITapGestureRecognizer?
    var backButtonRequired: Bool = false
    // MARK: View Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBarFont = UIFont(name: Constants.Fonts.ProximaNovaRegular , size: 17.0) {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.darkGray,
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        self.navigationItem.hidesBackButton = true;
        
        if self.backButtonRequired
        {
            let backButton = UIButton.init(type:UIButtonType.custom)
            backButton.setImage(UIImage(named: "Ic_Back.png"), for: UIControlState())
            backButton.addTarget(self, action:#selector(self.backButtonPressed), for: UIControlEvents.touchUpInside)
            backButton.frame=CGRect(x: 0, y: 0, width: 30, height: 30)
            let backBarButton = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = backBarButton
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeTapGesture()
        self.dismissKeyboard()
        
        NotificationCenter.default.removeObserver(self);
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Private Methods
    fileprivate func addTapGesture() -> Void {
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        self.view.addGestureRecognizer(_tapGesture!)
    }
    
    fileprivate func removeTapGesture() -> Void {
        if let tapGesture = _tapGesture {
            self.view.removeGestureRecognizer(tapGesture)
            _tapGesture = nil
        }
    }
    
    fileprivate func dismissKeyboard() -> Void {
        self.view.endEditing(true)
    }
    
    
    // MARK: Control Actions
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- IBActions
    @IBAction func menuButtonAction(_ sender: AnyObject) {
        
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
    
    
    // MARK: Gesture Actions
    func handleGesture(_ sender: UITapGestureRecognizer) -> Void {
        self.dismissKeyboard()
    }
    
    // MARK: Keyboard Notification Observers
    func keyboardWillShow(_ sender: Notification) {
        self.addTapGesture()
    }
    
    func keyboardWillHide(_ sender: Notification) {
        self.removeTapGesture()
    }
}
