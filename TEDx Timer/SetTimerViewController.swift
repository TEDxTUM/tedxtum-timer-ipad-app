//
//  SetTimerViewController.swift
//  TEDx Timer
//
//  Created by Dora Dzvonyar on 25/07/16.
//  Copyright © 2016 Dora Dzvonyar. All rights reserved.
//

import UIKit

protocol SetTimerDelegate {
    func timerWasChanged(newTime: NSTimeInterval)
}

class SetTimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerData: [[String]] = [[String]]()
    var delegate: SetTimerDelegate?
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup pickerView
        pickerView.delegate = self
        pickerView.dataSource = self

        //fill pickerView with data
        pickerData = [createStringArray(0, toNumber: 99), createStringArray(0, toNumber: 59)]
        
        //scroll to TED time in pickerView
        pickerView.selectRow(15, inComponent: 0, animated: true)
    }
    
    private func createStringArray(fromNumber:Int, toNumber:Int) -> [String] {
        var array = [String]()
        if fromNumber <= toNumber {
            for index in fromNumber...toNumber {
                array.append("\(index)")
            }
        }
        return array
    }

    @IBAction func setTimer() {
        let newTime = convertPickerTimetoInterval()
        delegate?.timerWasChanged(newTime)
    }
    
    private func convertPickerTimetoInterval() -> NSTimeInterval {
        let minutes = (pickerData[0][pickerView.selectedRowInComponent(0)] as NSString).doubleValue
        let seconds = (pickerData[1][pickerView.selectedRowInComponent(1)] as NSString).doubleValue
        return minutes * 60.0 + seconds
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }

}
