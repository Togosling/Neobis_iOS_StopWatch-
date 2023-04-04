//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Тагай Абдылдаев on 4/4/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: UIViews
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "stopwatch")
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sgm = UISegmentedControl(items: ["Timer","StopWatch"])
        sgm.selectedSegmentIndex = 0
        return sgm
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = .boldSystemFont(ofSize: 64)
        return label
    }()
    
    let pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.isHidden = true
        return pv
    }()
    
    let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "stop-button"), for: .normal)
        button.tintColor = .black
        button.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
        return button
        
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.tintColor = .black
        button.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
        return button
        
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "video"), for: .normal)
        button.tintColor = .black
        button.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
        return button
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 254/255, green: 204/255, blue: 2/255, alpha: 1)
        
        segmentedControl.addTarget(self, action: #selector(handleSegmentedValueChange), for: .valueChanged)
        
        startButton.addTarget(self, action: #selector(startButtonsPressed), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonsPressed), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonsPressed), for: .touchUpInside)
        
        
        setupContsraints()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    
    //MARK: PickerView
    
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
    
    var chosenTime = 0
    
    func updateTimeLabel() {
        let hours = pickerView.selectedRow(inComponent: 0)
        let minutes = pickerView.selectedRow(inComponent: 1)
        let seconds = pickerView.selectedRow(inComponent: 2)
        chosenTime = hours * 3600 + minutes * 60 + seconds
        var stringHours = ""
        var stringMinutes = ""
        var stringSeconds = ""
        if seconds < 10 {
            stringSeconds = String(format: "0%1d", seconds)
        } else {
            stringSeconds = String(seconds)
        }
        if minutes < 10 {
            stringMinutes = String(format: "0%1d", minutes)
        } else {
            stringMinutes = String(minutes)
        }
        if hours < 10 {
            stringHours = String(format: "0%1d", hours)
        } else {
            stringHours = String(hours)
        }
        timeLabel.text = "\(stringHours):\(stringMinutes):\(stringSeconds)"
    }
    
    
    //MARK: SegmentedControll
    
    @objc func handleSegmentedValueChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            imageView.image = UIImage(named: "stopwatch")
            startButton.setImage(UIImage(named: "video"), for: .normal)
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            regularTimer.invalidate()
            backTimer.invalidate()
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            timeLabel.text = "00:00:00"
            pickerView.isHidden = true
        case 1:
            imageView.image = UIImage(named: "chronograph-watch")
            startButton.setImage(UIImage(named: "video"), for: .normal)
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            regularTimer.invalidate()
            backTimer.invalidate()
            timeLabel.text = "00:00:00"
            pickerView.isHidden = false
        default: break
        }
    }
    
    //MARK: Logic of Buttons with Timerы
    
    @objc func startButtonsPressed() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if startButton.currentImage == UIImage(named: "video") {
                createRegularTimer()
                startButton.setImage(UIImage(named: "video-pressed"), for: .normal)
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
                stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            } else {
                startButton.setImage(UIImage(named: "video"), for: .normal)
                regularTimer.invalidate()
            }
        } else {
            if startButton.currentImage == UIImage(named: "video") {
                pickerView.isHidden = true
                createBackTimer()
                startButton.setImage(UIImage(named: "video-pressed"), for: .normal)
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
                stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            } else {
                startButton.setImage(UIImage(named: "video"), for: .normal)
                pickerView.isHidden = false
                backTimer.invalidate()
            }
            
        }
    }
    @objc func pauseButtonsPressed() {
        if segmentedControl.selectedSegmentIndex == 0 {
            if pauseButton.currentImage == UIImage(named: "pause") {
                regularTimer.invalidate()
                pauseButton.setImage(UIImage(named: "pause-pressed"), for: .normal)
                startButton.setImage(UIImage(named: "video"), for: .normal)
                stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            } else {
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        } else {
            if pauseButton.currentImage == UIImage(named: "pause") {
                backTimer.invalidate()
                pickerView.isHidden = false
                pauseButton.setImage(UIImage(named: "pause-pressed"), for: .normal)
                startButton.setImage(UIImage(named: "video"), for: .normal)
                stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            } else {
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
    }
    @objc func stopButtonsPressed() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if stopButton.currentImage == UIImage(named: "stop-button") {
                regularTimer.invalidate()
                count = 0
                timeLabel.text = "00:00:00"
                stopButton.setImage(UIImage(named: "stop-button-pressed"), for: .normal)
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
                startButton.setImage(UIImage(named: "video"), for: .normal)
            } else {
                stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            }
        } else {
            if stopButton.currentImage == UIImage(named: "stop-button") {
                pickerView.isHidden = false
                pickerView.selectRow(0, inComponent: 0, animated: true)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.selectRow(0, inComponent: 2, animated: true)
                backTimer.invalidate()
                chosenTime = 0
                timeLabel.text = "00:00:00"
                stopButton.setImage(UIImage(named: "stop-button-pressed"), for: .normal)
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
                startButton.setImage(UIImage(named: "video"), for: .normal)
            } else {
                stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            }
        }
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
        if count < 10 {
            timeLabel.text = "\(String(format:"0%1d", time.0)):\(String(format:"0%1d", time.1)):\(String(format:"0%1d", time.2))"
            
        } else  {
            timeLabel.text = "\(String(format:"0%1d", time.0)):\(String(format:"0%1d", time.1)):\(String(time.2))"
        }
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
        var stringHours = ""
        var stringMinutes = ""
        var stringSeconds = ""
        if time.2 < 10 {
            stringSeconds = String(format: "0%1d", time.2)
        } else {
            stringSeconds = String(time.2)
        }
        if time.1 < 10 {
            stringMinutes = String(format: "0%1d", time.1)
        } else {
            stringMinutes = String(time.1)
        }
        if time.0 < 10 {
            stringHours = String(format: "0%1d", time.0)
        } else {
            stringHours = String(time.0)
        }
        timeLabel.text = "\(stringHours):\(stringMinutes):\(stringSeconds)"
        if chosenTime == 0 {
            backTimer.invalidate()
            pickerView.isHidden = false
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            startButton.setImage(UIImage(named: "video"), for: .normal)
            stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
        }
    }
    

    
    //MARK: SettingUp View Constraints
    
    fileprivate func setupContsraints() {
        
        var customHeight = 150
        var customOffset = 32
        var imageTopOffset = 92
        
        if view.frame.height < 700 {
            customHeight = 50
            customOffset = 8
            imageTopOffset = 16
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(imageTopOffset)
            make.width.equalTo(customHeight)
            make.height.equalTo(customHeight)
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(customOffset)
        }
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(customOffset)
        }
        
        let buttonsStackView = UIStackView(arrangedSubviews: [stopButton,pauseButton,startButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 32
        
        view.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(customHeight)
        }

    }


}

