//
//  BaseViewController.swift
//
//  Created by Pawan Kumar on 20/05/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
import UIKit

public class BaseViewController: UIViewController {
    
    private var _tapGesture: UITapGestureRecognizer?
    var backButtonRequired: Bool = false
    // MARK: View Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBarFont = UIFont(name: Constants.Fonts.ProximaNovaRegular , size: 17.0) {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        self.navigationItem.hidesBackButton = true;
        
        if self.backButtonRequired
        {
            let backButton = UIButton.init(type:UIButtonType.Custom)
            backButton.setImage(UIImage(named: "Ic_Back.png"), forState: UIControlState.Normal)
            backButton.addTarget(self, action:#selector(self.backButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
            backButton.frame=CGRectMake(0, 0, 30, 30)
            let backBarButton = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = backBarButton
        }
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil);
    }
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeTapGesture()
        self.dismissKeyboard()
        
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Private Methods
    private func addTapGesture() -> Void {
        _tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        self.view.addGestureRecognizer(_tapGesture!)
    }
    
    private func removeTapGesture() -> Void {
        if let tapGesture = _tapGesture {
            self.view.removeGestureRecognizer(tapGesture)
            _tapGesture = nil
        }
    }
    
    private func dismissKeyboard() -> Void {
        self.view.endEditing(true)
    }
    
    
    // MARK: Control Actions
    func backButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK:- IBActions
    @IBAction func menuButtonAction(sender: AnyObject) {
        
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
    
    
    // MARK: Gesture Actions
    func handleGesture(sender: UITapGestureRecognizer) -> Void {
        self.dismissKeyboard()
    }
    
    // MARK: Keyboard Notification Observers
    func keyboardWillShow(sender: NSNotification) {
        self.addTapGesture()
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.removeTapGesture()
    }
}