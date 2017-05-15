//
//  PlayerView.swift
//  Player
//
//  Created by Barray on 2017/5/3.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    deinit {
        print("PlayerView：快笑回我吧")
    }
    
    var isPlaying:Bool = false
    var isAutoPlay:Bool = false
    var isFullScreen = false
    
    
    lazy var player:Player = {
        return Player.player(URL(string:"http://baobab.wdjcdn.com/1455968234865481297704.mp4")!)
    }()
    var model:BARPlayerModel?
//    override var frame: CGRect{
//        didSet{
//            self.setPlayerLayerFrame(frame)
//        }
//    }
    static let shared = PlayerView.sharedPlayerView()
    
    static func sharedPlayerView()->PlayerView {
        let playerView = PlayerView()
        playerView.createGesture()
        playerView.player.delegate = playerView
        //        self.frame = frame;
        playerView.layer.addSublayer(playerView.player.playerLayer!)
        return playerView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.insertSublayer(self.player.playerLayer!, at: 0)
        self.setPlayerLayerFrame(self.bounds)
    }
    
    func setPlayerLayerFrame(_ frame:CGRect) {
        self.player.playerLayer?.frame = frame;
        
    }
    
    var controlView:PlayerView.View?
    
    func set(_ controlView:PlayerView.View) {
        self.addSubview(controlView)
        controlView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        self.controlView = controlView
        self.playTimeObserve()
        controlView.delegate = self
        controlView.makeSubViewsConstraints()
    }
    
    
    func playTimeObserve() {
        weak var weakSelf = self
        self.player.timeObserBlock = {
            (currentTime,totalTime,value) in
            weakSelf?.controlView?.play(currentTime: currentTime, totalTime: totalTime, value)
        }
    }
    
    func play() {
        print("\(self.controlView?.classForCoder)")
//        (self.controlView as! PlayerControlView).play(btnState: true)
        self.controlView?.play(btnState: true)
        self.player.play()
        self.isPlaying = true
    }
    
    func pause() {
        self.controlView?.play(btnState: false)
        self.player.pause()
        self.isPlaying = false
    }
    
    
    /// 控制播放基类
    class View:UIView{
        
        
        /// 播放事件触发代理
        weak var delegate:PlayActionDelegate?{
            get{
                return objc_getAssociatedObject(self, RuntimeKey.delegateKey) as? PlayActionDelegate
            }
            set{
                objc_setAssociatedObject(self, RuntimeKey.delegateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
        
        /// 播放按钮状态改变
        ///
        /// - Parameter btnState: 播放状态
        dynamic func play(btnState:Bool) {
            print("😄播放按钮改变")
        }
        
        /// 正常播放时间
        ///
        /// - Parameters:
        ///   - currentTime: 当前播放时长
        ///   - totalTime: 视频总时长
        ///   - sliderValue: slider的value(0.0~1.0)
        dynamic func play(currentTime:NSInteger,totalTime:NSInteger,_ sliderValue:CGFloat) {
            print("😄哈哈哈啊哈哈")
        }
        
        /// 重置ControlView
        dynamic func playerResetControlView(){
            
        }
        
        /// 控制View的显示或隐藏
        dynamic func playerControlViewShowOrHide() {
            
        }
        
        /// 显示
        dynamic func playerShowControlView() {
            
        }
        
        /// 隐藏
        dynamic func playerHideControlView() {

        }
        
        /// 自动隐藏
        dynamic func playerControlViewCancelAutoFadeOut() {
            print("😄自动隐藏")
        }
        
        /// 约束
        dynamic func makeSubViewsConstraints(){
            
        }
    }
}


// MARK: - 全屏或小屏播放
extension PlayerView{
    func _fullScreenAction() {
        if self.isFullScreen {
            self.isFullScreen = false
            self.interface(orientation: UIInterfaceOrientation.portrait)
            return
        } else {
            let orientation = UIDevice.current.orientation
            if orientation == UIDeviceOrientation.landscapeRight {
                self.interface(orientation: UIInterfaceOrientation.landscapeLeft)
            } else if orientation == UIDeviceOrientation.landscapeLeft{
                self.interface(orientation: UIInterfaceOrientation.landscapeRight)
            } else {
                self.interface(orientation: UIInterfaceOrientation.landscapeRight)
            }
            self.isFullScreen = true
        }
    }
    
    /// 屏幕旋转
    ///
    /// - Parameter orientation: 屏幕方向
    func interface(orientation:UIInterfaceOrientation) {
        if orientation == UIInterfaceOrientation.landscapeRight || orientation == UIInterfaceOrientation.landscapeLeft {
            self.setOrientationLandscapeConstraint(orientation)
        } else {
            self.setOrientationPortraitConstraint()
        }
    }
    
    func setOrientationLandscapeConstraint(_ orientation:UIInterfaceOrientation) {
        self.to(orientation: orientation)
        self.isFullScreen = true
    }
    
    func setOrientationPortraitConstraint() {
        self.to(orientation: UIInterfaceOrientation.portrait)
        self.snp.remakeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(300)
            make.centerX.equalTo(self.superview!.snp.centerX)
            make.top.equalTo(0)
        }
        self.isFullScreen = false
    }
    
    func to(orientation:UIInterfaceOrientation) {
        let currentStatusBarOrientation = UIApplication.shared.statusBarOrientation
        if currentStatusBarOrientation == orientation {
            return
        }
        
        if orientation != UIInterfaceOrientation.portrait {
            if currentStatusBarOrientation == UIInterfaceOrientation.portrait {
                self.snp.remakeConstraints({ (make) in
                    make.width.equalTo(SCREEN_HEIGHT)
                    make.height.equalTo(SCREEN_WIDTH)
                    make.center.equalTo(UIApplication.shared.keyWindow!)
                })
            }
        }
//        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = orientation
//        UIApplication.shared.setStatusBarOrientation(orientation, animated: false)
       
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.transform = CGAffineTransform.identity
        self.transform = self.getTransformRotationAngle()
        UIView.commitAnimations()
    }
    
    /// 获取变换的旋转角度
    ///
    /// - Returns: 角度
    ///废弃
//    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Explicit setting of the status bar orientation is more limited in iOS 6.0 and later")
    func getTransformRotationAngle() -> CGAffineTransform {
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .portrait:
            return CGAffineTransform.identity
        case .landscapeLeft:
            return CGAffineTransform(rotationAngle: -(CGFloat(M_PI_2)))
        case .landscapeRight:
            return CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        default:
            return CGAffineTransform.identity
        }
    }
    
    
}

// MARK: - palyer通知代理事件
extension PlayerView:PlayerNotificationDelegate{
    func onDeviceOrientationChange() {
        print("PlayerNotificationDelegate:切换了")
    }
}

// MARK: - 控制视图点击事件代理方法
extension PlayerView:PlayActionDelegate{
    func playAction() {
        print("快点播放")
        if self.isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    func fullscreenAction() {
        self._fullScreenAction()
    }
}

extension PlayerView:UIGestureRecognizerDelegate{
    
    /// 创建手势
    func createGesture() {
        //单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
        singleTap.delegate = self
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        self.addGestureRecognizer(singleTap)
        
        //双击
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTap)
        
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        singleTap.require(toFail: doubleTap)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isAutoPlay {
            let touch = (touches as NSSet).anyObject() as! UITouch
            if touch.tapCount == 1 {
                self.perform(#selector(singleTapAction(_:)), with: false)
            } else if touch.tapCount == 2 {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleTapAction(_:)), object: nil)
                self.doubleTapAction((touch.gestureRecognizers?.last)!)
            }
        }
        
        
    }
    
    @objc func singleTapAction(_ gesture:UIGestureRecognizer) {
        
    }
    
    @objc func doubleTapAction(_ gesture:UIGestureRecognizer) {
        if self.isPlaying {
            self.pause()
        } else{
            self.play()
        }
    }
    
}






