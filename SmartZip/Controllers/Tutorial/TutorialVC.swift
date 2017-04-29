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
    
    @IBOutlet weak var btnSkip: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showTutorial()
    }
    
    func showTutorial() {
        let panel: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tut-1")!, description: "This is the home screen of SmartZip application. In this screen user has options to work with local files as well as cloud files. In local, user can explore, share, zip, unzip and delete files. In cloud, user user can download files and share with other devices.")
        
        let panel2: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tut-2")!, description: "With Photos and Videos option in home screen user can select multiple photos or multiple videos for the creation of zip file.")
        
        let panel3: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tut-3")!, description: "After selection, a zip will be created, having all selcted photos or videos. That zip can be unzipped, viewed or shared among other devices.")
        
        /*let panel4: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tut_4.png")!, description: "Like Photos and Videos option in home screen, user can select songs from their device with Music option. A zip file will be created from selected songs. That zip file will perform operations as it performs in Photos and Videos.")
         
         let panel5: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tut_5.png")!, description: "User can select their files from Dropbox. Selected files will download from Dropbox server. SmartZip will create zip file from downloaded file. Afterwords that zip file is ready to work")
         
         let panel6: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tut_6.png")!, description: "User can select their files from Google Drive also. Selected files will download from Google Drive server. SmartZip will create zip file from downloaded file. Afterwords that zip file is ready to work")
         
         let panel7: MYIntroductionPanel = MYIntroductionPanel(image: UIImage(named: "tut_8.png")!, description: "All other options are in left menu/drawer. If you want to go on home screen, tap on Home. If you want to see this tutorial again tap on Tutorial. Want to get ad free app tap on Buy Pro. If you have done payment before, tap on Restore. If you want to share SmartZip, rate SmartZip or want to email us, options are given respectievely.")*/
        
        if ( introductionView == nil) {
            introductionView = MYIntroductionView(frame: CGRect(x: 0, y: 0, width: introView.frame.size.width, height: introView.frame.size.height), headerImage: UIImage(named: "SampleHeaderImage")!, panels: [panel, panel2, panel3])
            
            introductionView!.setHeaderText("SmartZip")
            introductionView!.headerImageView.autoresizingMask = .flexibleWidth
            introductionView!.headerLabel.autoresizingMask = .flexibleWidth
            introductionView!.headerView.autoresizingMask = .flexibleWidth
            introductionView!.pageControl.autoresizingMask = .flexibleWidth
            introductionView!.skipButton.autoresizingMask = .flexibleWidth
            introductionView!.skipButton.isHidden = true
            
            introductionView!.delegate = self
            introductionView!.show(in: introView, animateDuration: 0.1)
        }
    }
    
    func introductionDidFinish(with finishType: MYFinishType) {
        //
        if(introductionView != nil) {
            introductionView?.removeFromSuperview()
            introductionView = nil
            self.showTutorial()
        }
    }
    
    func introductionDidChange(to panel: MYIntroductionPanel!, with panelIndex: Int) {
        //
        
        print(panelIndex)
        
        if panelIndex == 6 {
            
            btnSkip.title = "Done"
            
        }else{
            
            btnSkip.title = "Skip"
        }
        
    }
    
    
    @IBAction   func menuButtonAction(_ sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggle(.left, animated: true) { (val) -> Void in
                
            }
        }
    }
    
    
    @IBAction func btnSkipTapped(_ sender: AnyObject) {
        
//        if let container = SideMenuManager.sharedManager().container {
//            container.toggle(.left, animated: true) { (val) -> Void in
//                
//                let vc = container.leftDrawerViewController as! LeftMenuViewController
//                vc.tableView(vc.topTableView, didSelectRowAt: IndexPath(forRow: 0, inSection: 0))
//                
//            }
//        }
        
        
    }
    
    
}
