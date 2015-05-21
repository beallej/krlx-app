//
//  LiveStreamViewController.swift
//  KRLX
//
//  Created by Josie Bealle on 07/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class LiveStreamViewController: UIViewController, AVAudioPlayerDelegate {
    //"radio.krlx.org/mp3/high_quality.m3u"
    //var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIButton!
    
    var playBoolean = true
    
    var moviePlayer:MPMoviePlayerController!
    var player:AVPlayer = AVPlayer(URL: NSURL(string: "http://radio.krlx.org/mp3/high_quality"))
    
    //var player:AVPlayer = AVPlayer(URL: NSURL(string: "http://www.radiobrasov.ro/listen.m3u"))
    override func viewDidLoad() {
        
        //playButton.setTitle("Play", forState: UIControlState.Normal)
        //playButton.setBackgroundImage(UIIMage(contentsofFile "play"), forState: //)



        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        toggle()
    }
    
    func toggle() {
        if playBoolean {
            playRadio()
            playBoolean = false
        }else{
            pauseRadio()
            playBoolean = true

        }
    }
    
    func playRadio() {
        player.play()
        let image = UIImage(named: "pause") as UIImage?
        //playButton.setTitle("Pause", forState: UIControlState.Normal)
        playButton.setBackgroundImage(image, forState: UIControlState.Normal)
    }
    
    func pauseRadio() {
        player.pause()
        let image = UIImage(named: "play") as UIImage?
        playButton.setBackgroundImage(image, forState: UIControlState.Normal)
        //playButton.setTitle("Play", forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
