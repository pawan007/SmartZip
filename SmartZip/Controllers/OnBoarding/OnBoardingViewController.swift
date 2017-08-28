//
//  OnBoardingViewController.swift
//
//  Created by Pawan Joshi on 05/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit
import AVFoundation

enum OnBoardingType {
    case scroll
    case video
    case parallax
}

class OnBoardingViewController: BaseViewController {
    
    var currentPageIndex = 0
    
    var onBoardingType: OnBoardingType = .scroll
    
    @IBOutlet weak var topVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak fileprivate var pageControl: UIPageControl!
    @IBOutlet weak fileprivate var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Change on boarding type (Scroll, Video, Parallax)
        self.onBoardingType = OnBoardingType.scroll
        setupInitialLayoutConstraintAndViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScreenUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.onBoardingType == OnBoardingType.parallax {
            runScreenAnimations()
        }
        else if self.onBoardingType == OnBoardingType.video {
            setupVideoOnBoarding()
        }
        else {
            runScreenAnimations()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
       // NSUserDefaults.setObject(true, forKey: TUTORIAL_VIEWED_KEY)
    }
    // MARK: - Helper Functions
    fileprivate func setupInitialLayoutConstraintAndViews() {
        
        self.pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "ic_pagination_off")!)
        self.pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "ic_pagination_on")!)
        
        
        if onBoardingType == OnBoardingType.video {
            
            self.pageControl.isHidden = true
            self.scrollView.isHidden = true
        }
        else {
            self.pageControl.isHidden = false
            self.scrollView.isHidden = false
            
            self.scrollView.alpha = 0
            self.pageControl.alpha = 0
        }
//        
//        if (UIDevice().screenType == UIDevice.HHScreenType.iPhone4) {
//            
//            topVerticalSpaceConstraint.constant = 50;
//            
//        }
        
    }
    
    @IBAction func getStartedPressed(_ sender: UIButton)
    {
        
    }
    
    fileprivate func setupScreenUI() {
        
    }
    
    fileprivate func runScreenAnimations()
    {
        // self.scrollView.contentSize = CGSize(width: view.bounds.size.width*2, height: view.bounds.size.height-20)
        //  self.scrollPageView2.frame = CGRectMake(scrollPageView1.bounds.size.width, scrollPageView1.frame.origin.y, scrollPageView1.bounds.size.width, scrollPageView1.bounds.size.height)
        self.performAnimation()
    }
    
    fileprivate func performAnimation() {
        UIView.animate(withDuration: 2.0, animations: {
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            if(finished) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.pageControl.alpha = 1
                    self.scrollView.alpha = 1
                    //self.logoIMG.alpha = 0
                })
                
            }
        }) 
    }
    
    fileprivate func setupVideoOnBoarding() {
        let onBoardingVideoName = "cocosvideo"
        assert(onBoardingVideoName != "", "Please provide a video name from resource folder")
        let onBoardingVideoExt = "mp4"
        assert(onBoardingVideoExt != "", "Please provide a video extension for video")
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    
    // MARK: - ScrollViewDelegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pNumber = Int(roundf(Float(scrollView.contentOffset.x)/Float(scrollView.bounds.size.width)))
        self.pageControl.currentPage = pNumber
        self.pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "ic_pagination_on")!)
        self.currentPageIndex = pNumber
    }
}
