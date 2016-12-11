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
    var itemNames = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        unzipPath(zipFilePath)
    }
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        AppDelegate.presentRootViewController()
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    // MARK: UITableview method implementation
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellFile", for: indexPath)
        cell.textLabel?.text = itemNames[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
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
    
    fileprivate func playVideo(_ path:String) {
        
//        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        self.presentViewController(playerController, animated: true) {
//            player.play()
//        }
    }
    
    func playAudio(_ url:String) {
        
//        let coinSound = NSURL(fileURLWithPath: url)
//        do{
//            let audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }catch {
//            print("Error getting the audio file")
//        }
    }
    
    
    
    func unzipPath(_ zipPath:String) {
        
        guard let unzipPath = tempUnzipPath(zipPath) else {
            return
        }
        
        unZipFilePath = unzipPath
        
        let success = SSZipArchive.unzipFile(atPath: zipPath, toDestination: unzipPath)
        if !success {
            return
        }
        
        var items: [String]
        
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: unzipPath)
            itemNames = items
            tableView.reloadData()
        } catch {
            return
        }
        
        
    }
    
    func tempUnzipPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
    
    func tempUnzipPath(_ zipPath:String) -> String? {
        
        var folderName = ""
        
        if zipPath.contains("Images") {
            
            folderName = "Images-\(Timestamp)"
            resourceType = ResTypeImage
            
        }else if zipPath.contains("Videos") {
            
            folderName = "Videos-\(Timestamp)"
            resourceType = ResTypeVideo
            
        }else if zipPath.contains("Song") {
            
            folderName = "Song-\(Timestamp)"
            resourceType = ResTypeAudio
            
        }else{
            
            folderName = "Dock-\(Timestamp)"
            resourceType = ResTypeDoc
            
        }
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path += "/\(folderName)"
        let url = URL(fileURLWithPath: path)
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
}
