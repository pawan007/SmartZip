
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIAction Method
    
    //This method work for both skip and done button
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
                let vc = container.leftDrawerViewController as! LeftMenuViewController
                vc.tableView(vc.topTableView, didSelectRowAtIndexPath:  NSIndexPath(forRow: 0, inSection: 0))
                
            }
        }
        
    }
    
    
    //MARK: CollectionView DataSource and Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! TutorialCollectionViewCell
        // Configure the cell
        if indexPath.row == 2 {
            
            cell.lblPageDescription.text = "See your shift and appointments in day, week or month view"
            cell.lblPageDescription.hidden = false
            cell.topHeightDescription.constant = 42
            cell.btnDone.hidden = false
            cell.btnSkip.hidden = true
            cell.imageViewTutorialCell.image = UIImage(named: "tut-3")
            
        }else if indexPath.row == 0 {
            cell.lblPageDescription.text = "Create a roster with unlimited shift combinations and then share it."
            cell.lblPageDescription.hidden = false
            cell.topHeightDescription.constant = 42
            cell.btnDone.hidden = true
            cell.btnSkip.hidden = false
            cell.imageViewTutorialCell.image = UIImage(named: "tut-1")
            
        }else if indexPath.row == 1 {
            cell.lblPageDescription.text = "Compare your roster with others, side by side"
            cell.lblPageDescription.hidden = false
            cell.topHeightDescription.constant = 42
            cell.btnDone.hidden = true
            cell.btnSkip.hidden = false
            cell.imageViewTutorialCell.image = UIImage(named: "tut-2")
        }
        else {
            
            cell.lblPageDescription.text = "See what events are on so you can plan a fun day off"
            cell.btnDone.hidden = false
            cell.topHeightDescription.constant = 10
            cell.btnDone.layer.cornerRadius = 3
            cell.btnDone.clipsToBounds = true
            //cell.lblPageDescription.hidden = true
            cell.btnSkip.hidden = true
            cell.imageViewTutorialCell.image = UIImage(named: "R7S2new")
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.width, screenSize.height - 28)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
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
