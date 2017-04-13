//
//  LNPlayerView.swift
//  LNCachePlayer
//
//  Created by lance017 on 2017/4/13.
//  Copyright © 2017年 lance017. All rights reserved.
//

import UIKit

import SnapKit

import AVFoundation


protocol LNPlayerViewDelegate : NSObjectProtocol{
    /// 进度条控制
    func lnplayer(playerView: LNPlayerView, sliderTouchUpOut slider: UISlider)
    /// 播放暂停
    func lnplayer(playerView: LNPlayerView, playAndPause playBtn: UIButton)
}

class LNPlayerView: UIView {
    
    weak var delegate:LNPlayerViewDelegate?
    
    var playerLayer:AVPlayerLayer?
    
    /// 显示时间
    lazy var timeLabel:UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        return timeLabel
    }()
    
    
    /// 进度条是否滑动
    var sliding: Bool = false
    
    /// 是否正在播放
    var playing: Bool = true
    

    /// 播放进度条
    lazy var slider:UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.minimumValue = 0
        /// 从最大值滑向最小值时杆的颜色
        slider.maximumTrackTintColor = UIColor.clear
        /// 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor(rgb: 0xF56C66)
        /// 滑块的图片
        slider.setThumbImage(UIImage(named:"slider_thumb"), for: .normal)
        slider.addTarget(self, action: #selector(sliderTouchDown(slider:)), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(slider:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(slider:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(slider:)), for: .touchCancel)
        return slider
    }()
    
    
    /// 缓冲进度条
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.backgroundColor = UIColor(rgb: 0x33302E)
        progressView.tintColor = UIColor.white
        progressView.progress = 0
        return progressView
    }()
    
    
    /// 播放暂停按钮
    lazy var playBtn:UIButton = {
        let playBtn = UIButton()
        playBtn.setImage(UIImage(named: "player_play"), for: .normal)
        playBtn.addTarget(self, action: #selector(playAndPause(button:)), for: .touchUpInside)
        return playBtn
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = self.bounds
        
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(50)
            make.bottom.equalTo(self).offset(-10)
        }
        
        self.addSubview(self.slider)
        self.slider.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.timeLabel)
            make.left.equalTo(self.timeLabel.snp.right).offset(5)
            make.right.equalTo(self).offset(-50)
        }
        
        self.insertSubview(self.progressView, belowSubview: self.slider)
        self.progressView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.slider)
            make.centerY.equalTo(self.slider).offset(0.5)
            make.height.equalTo(2)
        }
        
        self.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.slider)
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(30)
        }
    }
    
    /// 按下进度条
    @objc
    func sliderTouchDown(slider: UISlider) {
        self.sliding = true
    }
    
    
    /// 手离开进度条
    @objc
    func sliderTouchUpOut(slider: UISlider) {
        delegate?.lnplayer(playerView: self, sliderTouchUpOut: slider)
    }
    
    /// 播放暂停的事件
    @objc
    func playAndPause(button: UIButton) {
        self.playing = !self.playing
        
        if playing {
            playBtn.setImage(UIImage(named: "player_play"), for: .normal)
        }else {
            playBtn.setImage(UIImage(named: "player_pause"), for: .normal)
        }
        
        delegate?.lnplayer(playerView: self, playAndPause: button)
    }
    
}
