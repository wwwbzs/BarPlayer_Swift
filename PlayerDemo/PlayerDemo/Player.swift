//
//  Player.swift
//  Player
//
//  Created by Barray on 2017/5/3.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer




class Player: NSObject {
    var slider:UISlider?
    var timeObserve:Any?
    var totalTime:CMTime?{
        get{
            return self.playerItem?.duration
        }
    }
    var currtentTime:CMTime?{
        get{
            return self.playerItem?.currentTime()
        }
    }
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var playerLayer:AVPlayerLayer?
    var asset:AVURLAsset?
    weak var delegate:PlayerNotificationDelegate?
    
    typealias _TimeObserBlock = (NSInteger,NSInteger,CGFloat)->Void
    var timeObserBlock:_TimeObserBlock?
    
    static func player(_ url:URL) -> Player {
        let player = Player()
        player.asset = AVURLAsset(url: url)
    
        player.playerItem = AVPlayerItem(asset: player.asset!)
        player.player = AVPlayer(playerItem: player.playerItem)
        player.playerLayer = AVPlayerLayer(player: player.player)
        player.createTimer()
        player.addNotifications()
        return player
    }
    
    /// 播放
    func play() {
        self.player?.play()
    }
    
    /// 暂停
    func pause() {
        self.player?.pause()
    }
    
    /// 自动播放
    func autoPlayTheVideo() {
        
    }
    
    /// 重置Player
    func resetPlayer() {
        
    }
    
    /// 懒加载，文件
    ///
    /// - Parameters:
    ///   - forKeys: 文件属性
    ///   - completionHandler: 加载成功后处理
    func loadValuesAsynchronously(forKeys:[String], completionHandler:(()-> Void)?) -> Void {
        self.asset?.loadValuesAsynchronously(forKeys: forKeys, completionHandler: completionHandler)
    }
    
    func addObserver(to playerItem:AVPlayerItem) {
         //监控状态属性
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.status, options: NSKeyValueObservingOptions.new, context: nil)
        //监控网络加载情况属性
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.loadedTimeRanges, options: NSKeyValueObservingOptions.new, context: nil)
        //监听播放的区域缓存是否为空
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.playbackBufferEmpty, options: NSKeyValueObservingOptions.new, context: nil)
        //缓存可以播放的时候调用
        playerItem.addObserver(self, forKeyPath: ObserverKeyPath.playbackLikelyToKeepUp, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func removeObserver(from playerItem:AVPlayerItem) {
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.status)
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.loadedTimeRanges)
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.playbackBufferEmpty)
        playerItem.removeObserver(self, forKeyPath: ObserverKeyPath.playbackLikelyToKeepUp)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case ObserverKeyPath.status:
            let status = change?[NSKeyValueChangeKey.newKey] as! AVPlayerItemStatus
            if status == AVPlayerItemStatus.readyToPlay {
                
            }
        case ObserverKeyPath.loadedTimeRanges: break
            
        default: break
            
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        if self.timeObserve != nil {
            self.player?.removeTimeObserver(self.timeObserve!)
            self.timeObserve = nil
        }
        print("我被销毁了")
    }
}


// MARK: - Notification
extension Player{
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterPlayground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListenerCallback(_:)), name: Notification.Name.AVAudioSessionRouteChange, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStatusBarOrientationChange), name: Notification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    /// 应用将要退到后台
    func applicationWillResignActive(){
        print("应用将要退到后台")
    }
    
    /// 应用进入前台
    func appDidEnterPlayground(){
        
    }
    
    /// 耳机插入、拔出事件
    ///
    /// - Parameter notification: 通知
    func audioRouteChangeListenerCallback(_ notification:Notification) {
        let interuption = notification.userInfo
        let routeChangeReason = interuption![AVAudioSessionRouteChangeReasonKey] as! AVAudioSessionRouteChangeReason
        switch routeChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable:
            print("耳机插入")
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
            self.play()
            print("耳机拔掉")
        case AVAudioSessionRouteChangeReason.categoryChange:
            print("categoryChange")
        default:
            break
        }
    }
    
    /// 屏幕方向发生变化
    func onDeviceOrientationChange() {
        print("屏幕方向发生变化")
        if self.player == nil {
            return
        }
        
//        let orientation = UIDevice.current.orientation
//        switch orientation {
//        case .portraitUpsideDown:
//            break
//        case .portrait:
//            
//        default:
//            <#code#>
//        }
        self.delegate?.onDeviceOrientationChange?()
    }
    
    /// 状态条变化通知--在前台播放才去处理
    func onStatusBarOrientationChange() {
        
    }
}

@objc protocol PlayerNotificationDelegate:NSObjectProtocol {
    /// 应用将要退到后台
    @objc optional func applicationWillResignActive()
    
    /// 应用进入前台
    @objc optional func appDidEnterPlayground()
    
    /// 耳机插入、拔出事件
    ///
    /// - Parameter notification: 通知
    @objc optional func audioRouteChangeListenerCallback(_ notification:Notification)
    
    /// 屏幕方向发生变化
    @objc optional func onDeviceOrientationChange()
    
    /// 状态条变化通知--在前台播放才去处理
    @objc optional func onStatusBarOrientationChange()
}

extension Player{
    
    /// 添加播放进度计时器
    func createTimer() {
        weak var weakSelf = self
        print("createTimer")
        self.timeObserve = self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: nil, using: { (time) in
             let currentItem = weakSelf?.playerItem
            let loadedRanges = currentItem?.seekableTimeRanges
            if ((loadedRanges?.count)! > 0) && (currentItem?.duration.timescale != 0){
                let currentTime = NSInteger(CMTimeGetSeconds((currentItem?.currentTime())!))
                
                let totalTime = CGFloat(Int((currentItem?.duration.value)!) / Int((currentItem?.duration.timescale)!))
                let value = CGFloat(CMTimeGetSeconds((currentItem?.currentTime())!))/totalTime
                weakSelf?.timeObserBlock?(currentTime,NSInteger(totalTime),value)
            }
        })
    }
    
    /// 获取系统音量
    func configureVolume() {
        let volumeView = MPVolumeView()
        slider = nil
        for view in volumeView.subviews {
            //获取系统音量视图
            if view.classForCoder.description() == "MPVolumeSlider" {
                slider = view as? UISlider
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch  {
            print(error)
        }
    }
}



fileprivate struct ObserverKeyPath{
    static let status = "status"
    static let loadedTimeRanges = "loadedTimeRanges"
    static let playbackBufferEmpty = "playbackBufferEmpty"
    static let playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
}
