//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Тагай Абдылдаев on 4/4/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let mainView = MainView(frame: .zero)
    var chosenTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addTargets()
        mainView.pickerView.dataSource = self
        mainView.pickerView.delegate = self
    }
    
    //MARK: Targets
    
    fileprivate func addTargets() {
        mainView.segmentedControl.addTarget(self, action: #selector(handleSegmentedValueChange), for: .valueChanged)
        mainView.startButton.addTarget(self, action: #selector(startButtonsPressed), for: .touchUpInside)
        mainView.pauseButton.addTarget(self, action: #selector(pauseButtonsPressed), for: .touchUpInside)
        mainView.stopButton.addTarget(self, action: #selector(stopButtonsPressed), for: .touchUpInside)
    }
        
    //MARK: SegmentedControll
    
    @objc func handleSegmentedValueChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mainView.imageView.image = UIImage(named: "stopwatch")
            mainView.pickerView.selectRow(0, inComponent: 0, animated: true)
            mainView.pickerView.selectRow(0, inComponent: 1, animated: true)
            mainView.pickerView.selectRow(0, inComponent: 2, animated: true)
            mainView.pickerView.isHidden = true
            SetViewsToDefault()
            count = 0
            chosenTime = 0
        case 1:
            mainView.imageView.image = UIImage(named: "chronograph-watch")
            mainView.pickerView.isHidden = false
            SetViewsToDefault()
        default: break
        }
    }
    
    fileprivate func SetViewsToDefault() {
        mainView.startButton.setImage(UIImage(named: "video"), for: .normal)
        mainView.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        mainView.stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
        regularTimer.invalidate()
        backTimer.invalidate()
        mainView.timeLabel.text = "00:00:00"
    }
    
    //MARK: Logic of Buttons with Timers
    
    @objc func startButtonsPressed() {
        
        if mainView.segmentedControl.selectedSegmentIndex == 0 {
            if mainView.startButton.currentImage == UIImage(named: "video") {
                createRegularTimer()
                startButtonPressedFirst()
            } else {
                mainView.startButton.setImage(UIImage(named: "video"), for: .normal)
                regularTimer.invalidate()
            }
        } else {
            if mainView.startButton.currentImage == UIImage(named: "video") {
                mainView.pickerView.isHidden = true
                createBackTimer()
                startButtonPressedFirst()
            } else {
                mainView.startButton.setImage(UIImage(named: "video"), for: .normal)
                mainView.pickerView.isHidden = false
                backTimer.invalidate()
            }
            
        }
    }
    
    @objc func pauseButtonsPressed() {
        if mainView.segmentedControl.selectedSegmentIndex == 0 {
            if mainView.pauseButton.currentImage == UIImage(named: "pause") {
                regularTimer.invalidate()
                pauseButtonPressedFirst()
            } else {
                mainView.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        } else {
            if mainView.pauseButton.currentImage == UIImage(named: "pause") {
                backTimer.invalidate()
                mainView.pickerView.isHidden = false
                pauseButtonPressedFirst()
            } else {
                mainView.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
    }
    
    @objc func stopButtonsPressed() {
        
        if mainView.segmentedControl.selectedSegmentIndex == 0 {
            if mainView.stopButton.currentImage == UIImage(named: "stop-button") {
                regularTimer.invalidate()
                count = 0
                stopButtonPressedFirst()
            } else {
                mainView.stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            }
        } else {
            if mainView.stopButton.currentImage == UIImage(named: "stop-button") {
                mainView.pickerView.isHidden = false
                mainView.pickerView.selectRow(0, inComponent: 0, animated: true)
                mainView.pickerView.selectRow(0, inComponent: 1, animated: true)
                mainView.pickerView.selectRow(0, inComponent: 2, animated: true)
                backTimer.invalidate()
                chosenTime = 0
                stopButtonPressedFirst()
            } else {
                mainView.stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            }
        }
    }
    
    fileprivate func startButtonPressedFirst() {
        mainView.startButton.setImage(UIImage(named: "video-pressed"), for: .normal)
        mainView.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        mainView.stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
    }
    fileprivate func pauseButtonPressedFirst() {
        mainView.pauseButton.setImage(UIImage(named: "pause-pressed"), for: .normal)
        mainView.startButton.setImage(UIImage(named: "video"), for: .normal)
        mainView.stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
    }
    fileprivate func stopButtonPressedFirst() {
        mainView.stopButton.setImage(UIImage(named: "stop-button-pressed"), for: .normal)
        mainView.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        mainView.startButton.setImage(UIImage(named: "video"), for: .normal)
        mainView.timeLabel.text = "00:00:00"
    }
    
    //MARK: Timers
    
    var count = 0
    var regularTimer: Timer = Timer()
    var backTimer: Timer = Timer()
    
    func createRegularTimer() {
        regularTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleRegularTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleRegularTimer() {
        count += 1
        let time = secondToHoursMinutesToSeconds(seconds: count)
        mainView.timeLabel.text = "\(String(format:"%02d", time.0)):\(String(format:"%02d", time.1)):\(String(format: "%02d", time.2))"

    }
    
    func secondToHoursMinutesToSeconds(seconds: Int) -> (Int,Int,Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func createBackTimer() {
        if chosenTime != 0 {
            backTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleBackTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func handleBackTimer() {
        chosenTime -= 1
        let time = secondToHoursMinutesToSeconds(seconds: chosenTime)
        mainView.timeLabel.text = "\(String(format:"%02d", time.0)):\(String(format:"%02d", time.1)):\(String(format: "%02d", time.2))"
        if chosenTime == 0 {
            backTimer.invalidate()
            mainView.pickerView.isHidden = false
            mainView.pickerView.selectRow(0, inComponent: 0, animated: true)
            mainView.pickerView.selectRow(0, inComponent: 1, animated: true)
            mainView.pickerView.selectRow(0, inComponent: 2, animated: true)
            mainView.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            mainView.startButton.setImage(UIImage(named: "video"), for: .normal)
            mainView.stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
        }
    }
}

//MARK: PickerView

extension ViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 24
        case 1: return 60
        case 2: return 60
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        let hours = mainView.pickerView.selectedRow(inComponent: 0)
        let minutes =  mainView.pickerView.selectedRow(inComponent: 1)
        let seconds =  mainView.pickerView.selectedRow(inComponent: 2)
        chosenTime = hours * 3600 + minutes * 60 + seconds
        mainView.timeLabel.text = "\(String(format:"%02d", hours)):\(String(format:"%02d", minutes)):\(String(format: "%02d", seconds))"
    }
    
    fileprivate func setupView() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
}

