//
//  ViewController.swift
//  TEDx Timer
//
//  Created by Dora Dzvonyar on 24/07/16.
//  Copyright © 2016 Dora Dzvonyar. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, SetTimerDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    var timer = NSTimer()
    var countdownTime = 0.0
    var formattedCountdownTime:String {
        get {
            return stringFromTimeInterval(countdownTime)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()

        
    }
    
    func tickTock(timer: NSTimer) {
        countdownTime -= 1
        timeLabel.text = formattedCountdownTime
        if countdownTime == 0 {
            timer.invalidate()
        }
        //TODO add small "overtime" label
    }
    
    func startTimer() {
        timer.invalidate()
        timeLabel.text = formattedCountdownTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                       target: self,
                                                       selector: #selector(TimerViewController.tickTock(_:)),
                                                       userInfo: "nil",
                                                       repeats: true)
    }
    
    func timerWasChanged(newTime: NSTimeInterval) {
        self.dismissViewControllerAnimated(true) { 
            if(newTime == 0) {
                self.stopTimer()
                return
            }
            self.countdownTime = newTime
            self.startTimer()
        }
    }

    @IBAction func stopTimer() {
        timer.invalidate()
        countdownTime = 0.0
        timeLabel.text = formattedCountdownTime
    }
    
    @IBAction func pauseTimer() {
        //TODO
        timer.invalidate()
    }
    
    @IBAction func resumeTimer() {
        //TODO new timer etc. -> startTimer
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {
    }
    
    private func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        //let hours = (interval / 3600)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setTimerSegue" {
            let viewController = segue.destinationViewController as! SetTimerViewController
            viewController.delegate = self
        }
    }
}

