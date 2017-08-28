
//
//  WLCTutorialVC.swift
//  WorklifeCALENDAR
//
//  Copyright © 2016 WorklifeCALENDAR. All rights reserved.

import UIKit

class WLCTutorialVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var tutorialPageControl: UIPageControl!
    
    @IBOutlet weak var topHeightDescription: NSLayoutConstraint!
    
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIAction Method
    
    //This method work for both skip and done button
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        
        UIView.setAnimationsEnabled(false)
        
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
                let vc = container.leftDrawerViewController as! LeftMenuViewController
                vc.tableView(vc.topTableView, didSelectRowAtIndexPath:  NSIndexPath(forRow: 0, inSection: 0))
                
            }
        }
        
    }
    
    
    //MARK: CollectionView DataSource and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TutorialCollectionViewCell
        // Configure the cell
        if indexPath.row == 0 {
            cell.lblPageDescription.text = "This is the home screen of SmartZip app. In this screen user has options to work with local files as well as cloud files. In local, user can explore, share, zip, unzip and delete files. In cloud, user can download files and share with other devices."
            cell.lblPageTitle.text = "Select sharing"
            cell.lblPageDescription.isHidden = false
            cell.lblPageTitle.isHidden = false
            //            cell.topHeightDescription.constant = 42
            //            cell.btnDone.hidden = true
            cell.btnSkip.isHidden = false
            cell.btnSkip.setTitle("Skip", for: UIControlState())
            cell.imageViewTutorialCell.image = UIImage(named: "tut-1")
            
        }else if indexPath.row == 1 {
            cell.lblPageDescription.text = "Zip and share images, videos, slow-motion videos, songs, and other files in one click"
            cell.lblPageTitle.text = "Share anything"
            cell.lblPageDescription.isHidden = false
            cell.lblPageTitle.isHidden = false
            //            cell.topHeightDescription.constant = 42
            //            cell.btnDone.hidden = true
            cell.btnSkip.isHidden = false
            cell.btnSkip.setTitle("Skip", for: UIControlState())
            cell.imageViewTutorialCell.image = UIImage(named: "tut-2")
            
        }else {
            
            cell.lblPageDescription.text = "Zip files are shared with other device via Mail, Airdrop, Gmail, Facebook and other social apps."
            cell.lblPageTitle.text = "Share with anyone"
            cell.lblPageDescription.isHidden = false
            cell.lblPageTitle.isHidden = false
            //            cell.topHeightDescription.constant = 42
            //            cell.btnDone.hidden = false
            cell.btnSkip.isHidden = false
            cell.btnSkip.setTitle("Done", for: UIControlState())
            cell.imageViewTutorialCell.image = UIImage(named: "tut-3")
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: screenSize.height - 28)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = tutorialCollectionView.frame.size.width
        
        //get current page for page control
        let currentPage = tutorialCollectionView.contentOffset.x / pageWidth
        switch currentPage {
        case 0.0 : tutorialPageControl.currentPage = 0
        case 1.0 : tutorialPageControl.currentPage = 1
        case 2.0 : tutorialPageControl.currentPage = 2
        case 3.0 : tutorialPageControl.currentPage = 3
        default : break
        }
    }
    
}
