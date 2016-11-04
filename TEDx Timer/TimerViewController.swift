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
    var timer = Timer()
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
    
    @IBAction func unwindToTimer(_ segue: UIStoryboardSegue) {
    }
    
    func tapTimer(_ gestureRecognizer: UIGestureRecognizer) {
        if timer.isValid {
            pauseTimer()
        }
        else {
            startTimer()
        }
    }
    
    func longPressTimer(_ gestureRecognizer: UIGestureRecognizer) {
        performSegue(withIdentifier: "setTimerSegue", sender: self)
    }
    
    func tickTock(_ timer: Timer) {
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
        if timer.isValid {
            timer.invalidate()
        }
        timeLabel.text = formattedCountdownTime
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                       target: self,
                                                       selector: #selector(TimerViewController.tickTock(_:)),
                                                       userInfo: "nil",
                                                       repeats: true)
    }
    
    func timerWasChanged(_ newTime: TimeInterval) {
        self.dismiss(animated: true) {
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
    
    fileprivate func stringFromTimeInterval(_ interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        //let hours = (interval / 3600)
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setTimerSegue" {
            let viewController = segue.destination as! SetTimerViewController
            viewController.delegate = self
        }
    }
}

