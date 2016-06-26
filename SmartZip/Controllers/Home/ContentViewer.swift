//
//  ContentViewer.swift
//  SmartZip
//
//  Created by Pawan Dhawan on 21/06/16.
//
//

import UIKit
import MediaPlayer
import AVKit

class ContentViewer: UIViewController {
    
    
    var resourceType = ""
    var resPath = ""
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if resourceType == ResTypeImage {
            
            imageView.image = UIImage(contentsOfFile: resPath)
            
        }else if resourceType == ResTypeVideo {
            
            playVideo(resPath)
            
        }else if resourceType == ResTypeAudio {
            
            
            
        }else{
            
        }
        
        
        
    }
    
    @IBAction func backBtnTapped(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    private func playVideo(path:String) {
        
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
    
}
