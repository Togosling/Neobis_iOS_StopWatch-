//
//  View.swift
//  Neobis_iOS_StopWatch
//
//  Created by Тагай Абдылдаев on 14/4/23.
//

import UIKit


class MainView: UIView {
    
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
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = UIColor(red: 254/255, green: 204/255, blue: 2/255, alpha: 1)
        setupViews()
    }
        
    fileprivate func setupViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(flexibleHeight(to: 92))
            make.width.equalTo(flexibleWidth(to: 150))
            make.height.equalTo(flexibleHeight(to: 150))
        }
        
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(flexibleHeight(to: 16))
            make.width.equalTo(flexibleWidth(to: 200))
            make.height.equalTo(flexibleHeight(to: 50))
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(flexibleHeight(to: 32))
        }
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(flexibleHeight(to: 32))
        }
        
        let buttonsStackView = UIStackView(arrangedSubviews: [stopButton,pauseButton,startButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 32
        
        addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(flexibleHeight(to: 150))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
