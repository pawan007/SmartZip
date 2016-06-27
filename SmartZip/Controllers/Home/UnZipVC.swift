//
//  UnZipVC.swift
//  SwiftExample
//
//  Created by Pawan Dhawan on 21/06/16.
//
//

import UIKit
import SSZipArchive
import AVKit

class UnZipVC: UIViewController {
    
    var zipFilePath = ""
    var unZipFilePath = ""
    var resourceType = ""
    var itemNames = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        unzipPath(zipFilePath)
    }
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    @IBAction func btnBackTapped(sender: AnyObject) {
        
        AppDelegate.presentRootViewController()
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    // MARK: UITableview method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellFile", forIndexPath: indexPath)
        cell.textLabel?.text = itemNames[indexPath.row] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if resourceType == ResTypeVideo {
            
            playVideo("\(unZipFilePath)/\(itemNames[indexPath.row])")
            
        }else if resourceType == ResTypeAudio {
            
            playVideo("\(unZipFilePath)/\(itemNames[indexPath.row])")
            
        }else if resourceType == ResTypeImage{
            
            let vc = UIStoryboard.contentViewer()
            vc?.resPath = "\(unZipFilePath)/\(itemNames[indexPath.row])"
            vc?.resourceType = resourceType
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }else{
            
            
        }
        
        
    }
    
    private func playVideo(path:String) {
        
//        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        self.presentViewController(playerController, animated: true) {
//            player.play()
//        }
    }
    
    func playAudio(url:String) {
        
//        let coinSound = NSURL(fileURLWithPath: url)
//        do{
//            let audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }catch {
//            print("Error getting the audio file")
//        }
    }
    
    
    
    func unzipPath(zipPath:String) {
        
        guard let unzipPath = tempUnzipPath(zipPath) else {
            return
        }
        
        unZipFilePath = unzipPath
        
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unzipPath)
        if !success {
            return
        }
        
        var items: [String]
        
        do {
            items = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(unzipPath)
            itemNames = items
            tableView.reloadData()
        } catch {
            return
        }
        
        
    }
    
    func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
    
    func tempUnzipPath(zipPath:String) -> String? {
        
        var folderName = ""
        
        if zipPath.containsString("Images") {
            
            folderName = "Images-\(Timestamp)"
            resourceType = ResTypeImage
            
        }else if zipPath.containsString("Videos") {
            
            folderName = "Videos-\(Timestamp)"
            resourceType = ResTypeVideo
            
        }else if zipPath.containsString("Song") {
            
            folderName = "Song-\(Timestamp)"
            resourceType = ResTypeAudio
            
        }else{
            
            folderName = "Dock-\(Timestamp)"
            resourceType = ResTypeDoc
            
        }
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        path += "/\(folderName)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
}
