//
//  BARPlayerView.swift
//  Player
//
//  Created by Barray on 2017/4/27.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
//import SnapKit

class BARPlayerModel: NSObject {
    var title:String?
    var videoURL:URL?
    var superView:UIView?
    
//    lazy var placeholderImage:UIImage? = {
////        let placeholderImage = BARImage(file: "ZFPlayer_loading_bgView")
////        return placeholderImage!
//    }()
    var placeholderImageURLString:String?
    
    var resolutionInfo:Dictionary = [String:String]()
    
    var seekTime:NSInteger = 0
    
    //cellPlay
    var scrollView:UIScrollView?
    var indexPath:NSIndexPath?
    var superViewTag:NSInteger?

}

@objc protocol BARPlayerViewDelegate:NSObjectProtocol {
    @objc optional func bar_playerView(_ palyerView:BARPlayerView,BackAction:UIButton?)
    @objc optional func bar_playerView(_ palyerView:BARPlayerView,DownloadUrl:String)
    @objc optional func bar_playerView(_ palyerView:BARPlayerView,willShowControlView controlView:UIView,isFullscreen:Bool)
    @objc optional func bar_playerView(_ palyerView:BARPlayerView,willHiddenControlView controlView:UIView,isFullscreen:Bool)
}

enum BARPlayerLayerGravity:NSInteger {
    case resize           //不等比满屏
    case resizeAspect     //全屏
    case resizeAspectFill //满屏
}

enum BARPlayerState:NSInteger{
    case failed      // 播放失败
    case buffering   // 缓冲中
    case playing     // 播放中
    case stopped     // 停止播放
    case pause       // 暂停播放
}

class BARPlayerView: UIView {
    
    var playerLayerGravity:BARPlayerLayerGravity = BARPlayerLayerGravity.resizeAspect
    var isCanDownLoad = false
    var isHasPreview:Bool?
    
    var isPauseByUser = false
    var state:BARPlayerState?
    var isMute = false
    var isStopSuperNotVisable = false
    var isPlayerOnCenter = true
    
    var playerPushOrPress:Bool?
    
    static let sharedPlayerView = BARPlayerView.init()
    
    
    var player:AVPlayer?
    fileprivate var playerItem:AVPlayerItem?
    var urlAsset:AVURLAsset?
    var imageGenerator:AVAssetImageGenerator?
    var playerLayer:AVPlayerLayer?
    
    var timeObserve:Any?
    
    lazy var videoGravity:String = {
        return AVLayerVideoGravityResizeAspect
    }()
    
    
    var isAutoPlay:Bool?
    
    /// 是否播放本地文件
    var isLocalVideo:Bool?
    
    /// 是否再次设置URL播放视频
    var repeatToPlay:Bool?
    
    
    /// 是否正在拖拽
    fileprivate var isDragged:Bool?
    /// 小窗口位置
    fileprivate var smallPoint:CGPoint?
    /// 小窗口移动手势
    fileprivate var smallPanGesture:UIPanGestureRecognizer?
    
    fileprivate var controlView:UIView?
    fileprivate var playerModel:BARPlayerModel?
    var seekTime:NSInteger = 0
    var videoURL:URL!
    var resolutionInfo:Dictionary = [String:String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeThePlayer()
    }
    
    init() {
        super.init(frame:CGRect.zero)
        self.initializeThePlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }
    
    func initializeThePlayer() {
        self.isPlayerOnCenter = true
    }
    
    deinit {
        self.setPlayerItem(nil)
//        BARBrightnessView.instance.isLockScreen = false
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        if self.timeObserve != nil {
            self.player?.removeTimeObserver(self.timeObserve!)
            self.timeObserve = nil
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}



///MARK: open------控制
extension BARPlayerView{
    
    func resetToPlayNewURL() {
        self.repeatToPlay = true
        self.resetToPlayNewURL()
    }
    
    /// 播放图层和model
    ///
    /// - Parameters:
    ///   - controlView: 视图
    ///   - model: model
    func player(controlView:UIView?,model:BARPlayerModel?){
        if controlView == nil {
            
        }
        self.setPlayerModel(model!)
//        self.setControlView(controlView!)
    }
    
    /// model自带视图
    ///
    /// - Parameter model: model
    func player(model:BARPlayerModel){
        self.player(controlView: nil, model: model)
    }
    
    func playerAutoTheVideo(){
        self.configBARPlayer()
    }
    
    func addPlayerToSuperView(_ view:UIView?) {
        if view != nil {
            self.removeFromSuperview()
            view?.addSubview(self)
//            self.snp.remakeConstraints({ (make) in
//                make.edges.equalTo(view!)
//            })
        }
    }
    
    func playerReset(){
        
    }
    
    func player(newModel:BARPlayerModel){
        
    }
    
    func play(){
        if self.state == BARPlayerState.pause{
            self.state = BARPlayerState.playing
        }
        self.isPauseByUser = false
        self.player?.play()
    }
//    func pla(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    func pause(){
    
    }
}

extension BARPlayerView{
    func configBARPlayer() {
        print(12344555)
        print(self.videoURL)
        
        print(12344555)
//        self.videoURL = URL(string: "http://ooovl6dwj.bkt.clouddn.com/69/20170502/994795cc7b1d53a5a19930df476bb309.mp4")
        let path = Bundle.main.path(forResource: "994795cc7b1d53a5a19930df476bb309", ofType: ".mp4")
        
        self.videoURL = URL(fileURLWithPath: path!)
        print(path!)
        self.urlAsset = AVURLAsset(url: self.videoURL)
        _ = AVAssetExportSession.exportPresets(compatibleWith: self.urlAsset!)
        
        self.setPlayerItem(AVPlayerItem(asset: self.urlAsset!))
        
        self.player = AVPlayer(playerItem: self.playerItem!)
        
        self.playerLayer = AVPlayerLayer(player: self.player!)
        self.backgroundColor = UIColor.black
        self.playerLayer?.videoGravity = self.videoGravity
        self.isAutoPlay = true
//        self.createTimer()
        self.configureVolume()
        if self.videoURL?.scheme == "file" {
            self.state = BARPlayerState.playing
            self.isLocalVideo = true
//            self.controlView.bar_pla
        } else {
            self.state = BARPlayerState.buffering
            self.isLocalVideo = false
            
        }
        self.play()
        self.isPauseByUser = false
    }
}

// MARK: - getandSet
extension BARPlayerView{
    func setPlayerModel(_ model:BARPlayerModel) {
        self.playerModel = model
        if playerModel?.seekTime != 0 {
            self.seekTime = (self.playerModel?.seekTime)!
        }
        self.addPlayerToSuperView(playerModel?.superView)
        self.videoURL = self.playerModel?.videoURL
    }
    
    func setControlView(_ controlView:UIView) {
        self.controlView = controlView
//        controlView.del
        self.addSubview(controlView)
        
    }
    
    func setPlayerItem(_ playerItem:AVPlayerItem?) {
        if self.playerItem == playerItem {
            return
        }
        if self.playerItem != nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
            self.playerItem?.removeObserver(self, forKeyPath: "status")
            self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
            self.playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            self.playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        }
        self.playerItem = playerItem
        if playerItem != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(moviePlayDidEnd(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            playerItem!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            playerItem!.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            playerItem!.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            playerItem!.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
        }
        
    }
}

extension BARPlayerView{
    
    /// 添加播放进度计时器
    func createTimer() {
        
    }
    
    /// 获取系统音量
    func configureVolume() {
        
    }
}

extension BARPlayerView{
    
    /// 播放完毕
    ///
    /// - Parameter notification: 通知
    func moviePlayDidEnd(_ notification:Notification) {
        self.state = BARPlayerState.stopped
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? AVPlayerItem == self.player?.currentItem {
            if keyPath == "status" {
                if self.player?.currentItem?.status == AVPlayerItemStatus.readyToPlay {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                    self.layer.insertSublayer(self.playerLayer!, at: 0)
                    self.state = BARPlayerState.playing
                    
                }
            }
        }
    }
    
    /// 应用将要推到后台
    func applicationWillResignActive(){
        
    }
    
    /// 应用进入前台
    func appDidEnterPlayground(){
        
    }
}
