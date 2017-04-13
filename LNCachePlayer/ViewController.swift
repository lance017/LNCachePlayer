//
//  ViewController.swift
//  LNCachePlayer
//
//  Created by lance017 on 2017/4/13.
//  Copyright © 2017年 lance017. All rights reserved.
//

import UIKit

import AVFoundation



class ViewController: UIViewController {
    
    var url = "http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"
    
    lazy var playerItem:AVPlayerItem = {
        let playerItem = AVPlayerItem(url: URL(string: self.url)!)
        return playerItem
    }()
    
    lazy var avplayer:AVPlayer = {
        let avplayer = AVPlayer(playerItem: self.playerItem)
        return avplayer
    }()
    
    lazy var playerLayer:AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: self.avplayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return playerLayer
    }()
    
    lazy var playerView:LNPlayerView = {
        let playerView = LNPlayerView(frame: CGRect(x: 0, y: 100, width: LNVideoWidth, height: LNVideoHeight))
        playerView.delegate = self
        playerView.playerLayer = self.playerLayer
        return playerView
    }()
    
    var link:CADisplayLink?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.view.addSubview(self.playerView)
        
        self.playerView.layer.insertSublayer(self.playerLayer, at: 0)
        self.link = CADisplayLink(target: self, selector: #selector(update))
        self.link!.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /// KVO 观察者
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loadedTimeRanges" {
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime/totalTime // 计算出比例
            // 改变进度条
            self.playerView.progressView.progress = Float(percent)
            return
        }
        if keyPath == "status" {
            if self.playerItem.status == .readyToPlay {
                self.avplayer.play()
            }else {
                DLog("加载异常")
            }
            return
        }
    }
    
    /// 将秒数转换为时间字符串
    ///
    /// - Parameter secound: 需要转换的秒数
    /// - Returns: 转换完成的字符串
    @objc
    func formatPlayTime(secound:TimeInterval) -> String {
        if secound.isNaN {
            return "00:00"
        }
        let min = Int(secound / 60)
        let sec = Int(secound.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
    
    @objc
    func avalableDurationWithplayerItem() -> TimeInterval{
        guard let loadedTimeRanges = avplayer.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    
    /// 更新播放时间及进度条控制
    @objc
    func update(){
        
        guard self.playerView.playing else {
            return
        }

        /// 当前播放到的时间
        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        /// 总时间    imescale 这里表示压缩比例
        let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        /// 拼接字符串
        let timeStr = "\(formatPlayTime(secound: currentTime))/\(formatPlayTime(secound: totalTime))"
        /// 赋值
        self.playerView.timeLabel.text = timeStr
        /// 进度条
        if !self.playerView.sliding{
            self.playerView.slider.value = Float(currentTime/totalTime)
        }
    }
    
    deinit {
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - ViewController-LNPlayerViewDelegate
extension ViewController: LNPlayerViewDelegate {
    
    func lnplayer(playerView: LNPlayerView, sliderTouchUpOut slider: UISlider) {
        if self.playerItem.status == .readyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds(self.avplayer.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            /// 指定视频位置
            self.avplayer.seek(to: seekTime, completionHandler: { (b) in
                /// 更改拖动状态
                playerView.sliding = false
            })
        }
    }
    
    func lnplayer(playerView: LNPlayerView, playAndPause playBtn: UIButton) {
        if !playerView.playing{
            self.avplayer.pause()
        }else{
            if self.avplayer.status == .readyToPlay{
                self.avplayer.play()
            }
        }
    }
}

