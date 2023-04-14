//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Тагай Абдылдаев on 4/4/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
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
    
    var chosenTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 254/255, green: 204/255, blue: 2/255, alpha: 1)
        
        setupContsraints()
        addTargets()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    //MARK: Targets
    
    fileprivate func addTargets() {
        segmentedControl.addTarget(self, action: #selector(handleSegmentedValueChange), for: .valueChanged)
        startButton.addTarget(self, action: #selector(startButtonsPressed), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonsPressed), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonsPressed), for: .touchUpInside)
    }
        
    //MARK: SegmentedControll
    
    @objc func handleSegmentedValueChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            imageView.image = UIImage(named: "stopwatch")
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.isHidden = true
            SetViewsToDefault()
            count = 0
            chosenTime = 0
        case 1:
            imageView.image = UIImage(named: "chronograph-watch")
            pickerView.isHidden = false
            SetViewsToDefault()
        default: break
        }
    }
    
    fileprivate func SetViewsToDefault() {
        startButton.setImage(UIImage(named: "video"), for: .normal)
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
        regularTimer.invalidate()
        backTimer.invalidate()
        timeLabel.text = "00:00:00"
    }
    
    //MARK: Logic of Buttons with Timers
    
    @objc func startButtonsPressed() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if startButton.currentImage == UIImage(named: "video") {
                createRegularTimer()
                startButtonPressedFirst()
            } else {
                startButton.setImage(UIImage(named: "video"), for: .normal)
                regularTimer.invalidate()
            }
        } else {
            if startButton.currentImage == UIImage(named: "video") {
                pickerView.isHidden = true
                createBackTimer()
                startButtonPressedFirst()
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
                pauseButtonPressedFirst()
            } else {
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            }
        } else {
            if pauseButton.currentImage == UIImage(named: "pause") {
                backTimer.invalidate()
                pickerView.isHidden = false
                pauseButtonPressedFirst()
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
                stopButtonPressedFirst()
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
                stopButtonPressedFirst()
            } else {
                stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
            }
        }
    }
    
    fileprivate func startButtonPressedFirst() {
        startButton.setImage(UIImage(named: "video-pressed"), for: .normal)
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
    }
    fileprivate func pauseButtonPressedFirst() {
        pauseButton.setImage(UIImage(named: "pause-pressed"), for: .normal)
        startButton.setImage(UIImage(named: "video"), for: .normal)
        stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
    }
    fileprivate func stopButtonPressedFirst() {
        stopButton.setImage(UIImage(named: "stop-button-pressed"), for: .normal)
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        startButton.setImage(UIImage(named: "video"), for: .normal)
        timeLabel.text = "00:00:00"
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
        timeLabel.text = "\(String(format:"%02d", time.0)):\(String(format:"%02d", time.1)):\(String(format: "%02d", time.2))"

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
        timeLabel.text = "\(String(format:"%02d", time.0)):\(String(format:"%02d", time.1)):\(String(format: "%02d", time.2))"
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
                
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(flexibleHeight(to: 92))
            make.width.equalTo(flexibleWidth(to: 150))
            make.height.equalTo(flexibleHeight(to: 150))
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(flexibleHeight(to: 16))
            make.width.equalTo(flexibleWidth(to: 200))
            make.height.equalTo(flexibleHeight(to: 50))
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(flexibleHeight(to: 32))
        }
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(flexibleHeight(to: 32))
        }
        
        let buttonsStackView = UIStackView(arrangedSubviews: [stopButton,pauseButton,startButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 32
        
        view.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(flexibleHeight(to: 150))
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
        let hours = pickerView.selectedRow(inComponent: 0)
        let minutes = pickerView.selectedRow(inComponent: 1)
        let seconds = pickerView.selectedRow(inComponent: 2)
        chosenTime = hours * 3600 + minutes * 60 + seconds
        timeLabel.text = "\(String(format:"%02d", hours)):\(String(format:"%02d", minutes)):\(String(format: "%02d", seconds))"
    }
    
}

