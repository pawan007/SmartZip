//
//  TutorialVC.swift
//  SmartZip
//
//  Created by Narender Kumar on 17/07/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import Foundation
import UIKit

class TutorialVC: UIViewController, MYIntroductionDelegate {
    
    var introductionView:MYIntroductionView? = nil
    @IBOutlet weak var introView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showTutorial()
    }
    
    func showTutorial() {
        let panel: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tutorial_background_00.jpg")!, description: "Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!")
        
        let panel2: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tutorial_background_01.jpg")!, description: "Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!")
        
        let panel3: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tutorial_background_02.jpg")!, description: "Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!")
        
        let panel4: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tutorial_background_03.jpg")!, description: "Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!")
        
        let panel5: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tutorial_background_04.jpg")!, description: "Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!")

        if ( introductionView == nil) {
            introductionView = MYIntroductionView(frame: CGRectMake(0, 0, introView.frame.size.width, introView.frame.size.height), headerImage: UIImage(named: "SampleHeaderImage")!, panels: [panel, panel2, panel3, panel4, panel5])
            introductionView!.setHeaderText("Zip")
            
            introductionView!.HeaderImageView.autoresizingMask = .FlexibleWidth
            introductionView!.HeaderLabel.autoresizingMask = .FlexibleWidth
            introductionView!.HeaderView.autoresizingMask = .FlexibleWidth
            introductionView!.PageControl.autoresizingMask = .FlexibleWidth
            introductionView!.SkipButton.autoresizingMask = .FlexibleWidth
            introductionView!.SkipButton.hidden = true
            
            introductionView!.delegate = self
            introductionView!.showInView(introView, animateDuration: 0.1)
        }
    }
    
    func introductionDidFinishWithType(finishType: MYFinishType) {
        //
        if(introductionView != nil) {
            introductionView?.removeFromSuperview()
            introductionView = nil
            self.showTutorial()
        }
    }
    
    func introductionDidChangeToPanel(panel: MYIntroductionPanel!, withIndex panelIndex: Int) {
        //
    }
    
    
    @IBAction   func menuButtonAction(sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
}
