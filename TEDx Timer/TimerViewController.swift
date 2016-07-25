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

        //add gesture recognizers for relevant interactions
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(TimerViewController.tapTimer(_:)))
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TimerViewController.longPressTimer(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    @IBAction func unwindToTimer(segue: UIStoryboardSegue) {
    }
    
    func tapTimer(gestureRecognizer: UIGestureRecognizer) {
        if timer.valid {
            pauseTimer()
        }
        else {
            startTimer()
        }
    }
    
    func longPressTimer(gestureRecognizer: UIGestureRecognizer) {
        performSegueWithIdentifier("setTimerSegue", sender: self)
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
        if countdownTime <= 0 {
            stopTimer()
            return
        }
        if timer.valid {
            timer.invalidate()
        }
        timeLabel.text = formattedCountdownTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                       target: self,
                                                       selector: #selector(TimerViewController.tickTock(_:)),
                                                       userInfo: "nil",
                                                       repeats: true)
    }
    
    func timerWasChanged(newTime: NSTimeInterval) {
        self.dismissViewControllerAnimated(true) {
            self.countdownTime = newTime
            self.startTimer()
        }
    }

    func stopTimer() {
        timer.invalidate()
        countdownTime = 0.0
        timeLabel.text = formattedCountdownTime
    }
    
    func pauseTimer() {
        timer.invalidate()
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

