//
//  ViewController.swift
//  Neobis_iOS_StopWatch
//
//  Created by Тагай Абдылдаев on 4/4/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "stopwatch")
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sgm = UISegmentedControl(items: ["Timer","StopWatch"])
        return sgm
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "00:00:00"
        label.font = .boldSystemFont(ofSize: 64)
        return label
    }()
    
//    let pickerView: UIPickerView = {
//        let pv = UIPickerView()
//        pv.
//    }()
    
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
        
        startButton.addTarget(self, action: #selector(startButtonsPressed), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonsPressed), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonsPressed), for: .touchUpInside)
        
        setupContsraints()
        
    }
    
    var timer: Timer = Timer()
    var count = 0
    var timerCounting = false
    
    @objc func startButtonsPressed() {
                
        if startButton.currentImage == UIImage(named: "video") {
            createTimer()
            startButton.setImage(UIImage(named: "video-pressed"), for: .normal)
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
        } else {
            startButton.setImage(UIImage(named: "video"), for: .normal)
        }
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    @objc func startTimer() {
        count += 1
        let time = secondToHoursMinutesToSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timeLabel.text = timeString
    }
    
    func secondToHoursMinutesToSeconds(seconds: Int) -> (Int,Int,Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }

    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "0%2d", hours)
        timeString += " : "
        timeString += String(format: "0%2d", minutes)
        timeString += " : "
        timeString += String(format: "0%2d", seconds)
        return timeString
    }
    
    @objc func pauseButtonsPressed() {
        if pauseButton.currentImage == UIImage(named: "pause") {
            pauseButton.setImage(UIImage(named: "pause-pressed"), for: .normal)
            startButton.setImage(UIImage(named: "video"), for: .normal)
            stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    @objc func stopButtonsPressed() {
        if stopButton.currentImage == UIImage(named: "stop-button") {
            stopButton.setImage(UIImage(named: "stop-button-pressed"), for: .normal)
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            startButton.setImage(UIImage(named: "video"), for: .normal)
        } else {
            stopButton.setImage(UIImage(named: "stop-button"), for: .normal)
        }
    }
    
    fileprivate func setupContsraints() {
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(92)
            make.width.equalTo(150)
            make.height.equalTo(150)
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
            make.top.equalTo(segmentedControl.snp.bottom).offset(32)
        }
        
        let buttonsStackView = UIStackView(arrangedSubviews: [stopButton,pauseButton,startButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 32
        
        view.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(162)
        }

    }


}

