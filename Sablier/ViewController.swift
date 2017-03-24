//
//  ViewController.swift
//  Sablier
//
//  Created by etudiant-09 on 23/03/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var audioPlayer = AVAudioPlayer()
    var isPlaying = false
    
    var countdown = 4.0 {
        didSet {
            updateCountDownLabel()
        }
    }
    var currentCountdown = 50.0 {
        didSet {
            updateCurrentCountDownLabel()
        }
    }
    var timer : Timer = Timer()
    
    var startDate = Date()
    
    
    
    var isCountdowning = false {
        didSet {
            self.countdownSlider.isEnabled = !self.isCountdowning
            self.startButton.isEnabled = !self.isCountdowning
            self.pauseButton.isEnabled = self.isCountdowning
            self.stopButton.isEnabled = self.isCountdowning
        }
    }
    
    var isPaused = false {
        didSet {
            self.startButton.isEnabled = self.isPaused
        }
    }
    
    var hasadvertedForEndOfCountdown = false
    
    
    @IBOutlet weak var playBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var countDownlabel: UILabel!
    
    @IBOutlet weak var currentCountDownLabel: UILabel!
    
    @IBOutlet weak var countdownSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // self.navigationController?.isToolbarHidden = false
        
        
//        self.preferredStatusBarStyle = .lightContent
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        currentCountdown = countdown
        currentCountDownLabel.text = "\(currentCountdown)"
        
        self.countdownSlider.minimumValue = 0.0
        self.countdownSlider.maximumValue = 120.0
        self.countdownSlider.value = Float(self.countdown)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func playButtonTapped(_ sender: UIButton) {
//        if(!isPlaying) {
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//            self.isPlaying = true
//        }
//    }
//    
    
    /*
    func createNotification(){
        let notifContent = UNMutableNotificationContent()
        notifContent.title = "Titre"
        notifContent.badge = 15
        notifContent.body = "Un texte un peu plus long"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.currentCountdown, repeats: false)
        
        
        
        let request = UNNotificationRequest(identifier: "Hello", content: notifContent, trigger: trigger)
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.add(request, withCompletionHandler: nil)
        
        
    }
 */
    
    @IBAction func startCountDown(_ sender: UIButton) {
        if(!self.isPaused) {
            self.currentCountdown = self.countdown
            self.startDate = Date()
        } else {
            self.hasadvertedForEndOfCountdown = false
            self.startDate = Date().addingTimeInterval( currentCountdown - countdown  )
        }
        
       // Utilities.scheduleLocalNotification(delay: self.countdown, body: "Bonjour ça va bien ?", title: "Titre" , soundName: nil)//"gong.mp3")
        Utilities.createNotification(at: self.currentCountdown, title: "Hey !", body: "C'est fini", badgeNumber: 14, soundName: nil)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: updateCountDown(with: ))
        self.isCountdowning = true
        
    }
    
    func updateCountDown(with timer: Timer) {
       // let currentDate = Date()
       // let elapsedTime = self.startDate.timeIntervalSince(currentDate)
        self.currentCountdown = self.countdown + self.startDate.timeIntervalSinceNow //self.timer.timeInterval
       // print(self.currentCountdown)
        
        if(self.currentCountdown <= 10 && !self.hasadvertedForEndOfCountdown){
            self.play(music: "gong")
            self.hasadvertedForEndOfCountdown = true
            
        }
        
        if(self.currentCountdown <= 0){
            self.currentCountdown = 0.0
            self.timer.invalidate()
            //self.play(music: "Countdown", from: 117, during: 4)
            self.isCountdowning = false
        }
    }
    
    @IBAction func stopCountDown(_ sender: Any) {
        self.timer.invalidate()
        self.isCountdowning = false
        Utilities.removeNotifications()
        //Utilities.cancelLocalNotifications()
    }
    
    @IBAction func pauseCountDown(_ sender: UIButton) {
        self.timer.invalidate()
        self.isPaused = true
        Utilities.removeNotifications()
       // Utilities.cancelLocalNotifications()
    }
    
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.countdown = Double(self.countdownSlider.value).rounded()
    }
    
    
    func play(music: String, from startTime: TimeInterval = 0, during : Int = 0){
        
        loadMusic(for: music)
        audioPlayer.prepareToPlay()
        print(audioPlayer.settings)
        if(startTime > 0){
            audioPlayer.currentTime = startTime
        }
        DispatchQueue.global(qos: .background).async {
            
            self.audioPlayer.play()
            self.isPlaying = true
            if(during > 0) {
                sleep(UInt32(during))
                self.audioPlayer.stop()
            }
            self.isPlaying = false
        }

    }
    
    func loadMusic(for fileName: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Could not load audio file : \(fileName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let audioError {
            print("Could not load audio file : \(audioError.localizedDescription)")
        }
    }
    
    @IBAction func playTapped(_ sender: UIBarButtonItem) {
        if(!isPlaying) {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            self.isPlaying = true

//            self.playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(self.playTapped(_:)))
        } else {
            if (self.isPlaying) {
                self.audioPlayer.pause()
                self.isPlaying = false
                self.playBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.playTapped(_:)))
            }
        }
    }

//    @IBAction func pauseButtonTapped(_ sender: UIButton) {
//        if (self.isPlaying) {
//            self.audioPlayer.pause()
//            self.isPlaying = false
//        }
//        
//    }

    
    func updateView(){
        updateLabels()
    }
    
    func updateLabels(){
        updateCurrentCountDownLabel()
    }
    
    func updateCurrentCountDownLabel() {
        self.currentCountDownLabel.text = self.currentCountdown.toString(2)
    }
    
    func updateCountDownLabel() {
        self.countDownlabel.text = self.countdown.toString(0)
    }

}

