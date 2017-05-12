//
//  PlayerControlView.swift
//  PlayerDemo
//
//  Created by Barray on 2017/5/5.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit
import SnapKit

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: a)
}

class PlayerControlView: PlayerView.View {
    
    var isDragged:Bool = false
    
    
    /// 标题
    lazy fileprivate var titleLabel:UILabel = {
       let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        return titleLabel
    }()
    var title:String?{
        get{
            return titleLabel.text
        }
        set{
            titleLabel.text = newValue
        }
    }
    
//    fileprivate var startBtn:UIButton
//    
//    fileprivate var currentTimeLabel:UILabel
//    fileprivate var totalTimeLabel:UILabel
//    fileprivate var progressView:UIProgressView
//    fileprivate var videoSlider:UISlider
//    fileprivate var fullScreenBtn:UIButton
    
    /// 锁定屏幕按钮
    lazy fileprivate var lockBtn:UIButton = {
        let lockBtn = UIButton(type: UIButtonType.custom)
        lockBtn.setImage(BARImage(file: "ZFPlayer_unlock-nor"), for: UIControlState.normal)
        lockBtn.setImage(BARImage(file: "ZFPlayer_lock-no"), for: UIControlState.selected)
        lockBtn.addTarget(self, action: #selector(lockScreenBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return lockBtn
    }()
    func lockScreenBtnClick(_ sender:Any) {
        
    }
    
//    fileprivate var backBtn:UIButton
    
    /// 关闭按钮
    lazy fileprivate var closeBtn:UIButton = {
        let closeBtn = UIButton(type: UIButtonType.custom)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: UIControlEvents.touchUpInside)
        closeBtn.setImage(BARImage(file: "ZFPlayer_close"), for: UIControlState.normal)
        closeBtn.isHidden = true
        return closeBtn
    }()
    func closeBtnClick(_ sender:Any) {
        
    }
    
    /// 重播按钮
    lazy fileprivate var repeatBtn:UIButton = {
        let repeatBtn = UIButton(type: UIButtonType.custom)
        repeatBtn.addTarget(self, action: #selector(repeatBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return repeatBtn
    }()
    func repeatBtnClick(_ sender:Any) {
        
    }
    
    /// 底部视图
    lazy fileprivate var bottomImageView:BottomImageView = {
        let bottomImageView = BottomImageView()
        bottomImageView.isUserInteractionEnabled = true
//        bottomImageView.alpha = 0
        bottomImageView.image = BARImage(file: "ZFPlayer_bottom_shadow")
        return bottomImageView
    }()
    
    /// 顶部视图
    lazy fileprivate var topImageView:TopImageView = {
        let topImageView = TopImageView()
        topImageView.isUserInteractionEnabled = true
//        topImageView.alpha = 0
        topImageView.image = BARImage(file: "ZFPlayer_top_shadow")
        return topImageView
    }()
    
//    fileprivate var downLoadBtn:UIButton
    
    
    /// 切换分辨率
//    fileprivate var resolutionBtn:UIButton
    fileprivate var resolutionView:UIView?
    
    /// 播放按钮
    lazy fileprivate var playBtn:UIButton = {
        let playBtn = UIButton(type: UIButtonType.custom)
        playBtn.addTarget(self, action: #selector(centerPlayBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return playBtn
    }()
    func centerPlayBtnClick(_ sender:Any) {
        
    }
    
    
    /// 播放失败按钮
    lazy fileprivate var failBtn:UIButton = {
        let failBtn = UIButton(type: UIButtonType.custom)
        failBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        failBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        failBtn.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.7)
        failBtn.addTarget(self, action: #selector(failBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return failBtn
    }()
    func failBtnClick(_ sender:Any) {
        
    }
    
    
    /// 快进快退视图
    lazy fileprivate var fastView:FastView = {
        let fastView = FastView()
        fastView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.8)
        fastView.layer.cornerRadius = 4
        fastView.layer.masksToBounds = true
        return fastView
    }()
    
    
//    fileprivate var
//    fileprivate var resoultionCurrentBtn:UIButton
    
    /// 占位图
    lazy fileprivate var placeholderImageView:UIImageView = {
        let placeholderImageView = UIImageView()
        placeholderImageView.isUserInteractionEnabled = true
        return placeholderImageView
    }()
    lazy fileprivate var bottomProgressView:UIProgressView = {
        let bottomProgressView = UIProgressView()
        bottomProgressView.progressTintColor = UIColor.white
        bottomProgressView.trackTintColor = UIColor.clear
        return bottomProgressView
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.placeholderImageView)
        self.addSubview(self.topImageView)
        self.addSubview(self.bottomProgressView)
        self.addSubview(self.lockBtn)
        self.addSubview(self.repeatBtn)
        self.addSubview(self.playBtn)
        self.addSubview(self.failBtn)
        self.addSubview(self.fastView)
        self.addSubview(self.closeBtn)
        self.addSubview(self.bottomImageView)
        self.bottomImageView.delegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeSubViewsConstraints() {
        self.placeholderImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        self.closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing).offset(7)
            make.top.equalTo(self.snp.top).offset(-7)
            make.width.height.equalTo(20)
        }
        self.topImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self.snp.top).offset(0)
            make.height.equalTo(50)
        }
        self.topImageView.makeSubViewsConstraints()
        self.bottomProgressView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            
        }
        self.lockBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(32)
        }
        self.repeatBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        self.playBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.center.equalTo(self)
        }
        self.failBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(130)
            make.height.equalTo(33)
        }
        self.fastView.snp.makeConstraints { (make) in
            make.width.equalTo(125)
            make.height.equalTo(80)
            make.center.equalTo(self)
        }
        self.fastView.makeSubViewsConstraints()
        self.bottomImageView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.height.equalTo(50)
        }
        self.bottomImageView.makeSubViewsConstraints()
    }
    deinit {
        print("快销毁我吧")
    }
    let myGroup = DispatchGroup()
    
//    weak var delegate:PlayActionDelegate?
}

// MARK: - 控制器扩展方法
extension PlayerControlView{
    
    override func play(btnState:Bool) {
        self.bottomImageView.startBtn.isSelected = !self.bottomImageView.startBtn.isSelected
    }
    
    override func play(currentTime: NSInteger, totalTime: NSInteger, _ sliderValue: CGFloat) {
        let proMin = currentTime / 60
        let proSec = currentTime % 60
        
        let durMin = totalTime / 60
        let durSec = totalTime % 60
        
        if !self.isDragged {
            __dispatch_group_notify(myGroup, DispatchQueue.main, { 
                __dispatch_group_async(self.myGroup, DispatchQueue.main, {
                    UIView.animate(withDuration: TimeInterval(self.bottomImageView.videoSlider.value-Float(sliderValue)), animations: {
                        self.bottomImageView.videoSlider.value = Float(sliderValue)
                        self.bottomProgressView.progress = Float(sliderValue)
                    })
                })
            })
            
            self.bottomImageView.currentTimeLabel.text = String(format: "%02zd:%02zd", arguments: [proMin,proSec])
        }
        self.bottomImageView.totalTimeLabel.text = String(format: "%02zd:%02zd", arguments: [durMin,durSec])
    }
}

// MARK: - 通知的代理事件
extension PlayerControlView:PlayerNotificationDelegate{
    func onDeviceOrientationChange() {
        print("PlayerControlView:转了")
//        self.lockBtn.isHidden = !self.
//        let orientation = UIDevice.current.orientation
        
        
    }
}

// MARK: - 控制视图子视图点击事件代理方法
extension PlayerControlView:PlayActionDelegate{
    
    func playAction() {
        delegate?.playAction?()
    }
    
    func fullscreenAction() {
        delegate?.fullscreenAction?()
    }
    
}

@objc protocol PlayActionDelegate:NSObjectProtocol {
    
    
    /// 返回按钮点击事件
    @objc optional func backAction()
    
    /// 关闭按钮点击事件
    @objc optional func closeAction()
    
    /// 播放按钮点击事件
    @objc optional func playAction()
    
    /// 全屏按钮点击事件
    @objc optional func fullscreenAction()
    
    /// 锁定按钮点击事件
    @objc optional func lockScreenAction()
    
    /// 重播按钮点击事件
    @objc optional func repeatPlayAction()
    
    /// 中间播放按钮点击事件
    @objc optional func cneterPlayAction()
    
    /// 加载失败按钮点击事件
    @objc optional func failAction()
    
    /// 下载按钮点击事件
    @objc optional func downLoadAction()
    
    /// 切换分辨路点击事件
    @objc optional func resolutionAction()
    
    /// slider点击事件
    ///
    /// - Parameter value: 跳转进度
    @objc optional func progressSliderTap(value:CGFloat)
    
    /// 开始触摸slider事件
    ///
    /// - Parameter slider: <#slider description#>
    @objc optional func progressSliderTouchBegan(_ slider:UISlider)
    
    /// 拖动slider事件
    ///
    /// - Parameter slider: <#slider description#>
    @objc optional func progressSliderValueChanged(_ slider:UISlider)
    
    /// 结束触摸slider事件
    ///
    /// - Parameter slider: <#slider description#>
    @objc optional func progressSliderTouchEnded(_ slider:UISlider)
    
}

/// 头部视图
private class TopImageView:UIImageView{
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        return titleLabel
    }()
    
    /// 下载按钮
    lazy var downLoadBtn: UIButton = {
        let downLoadBtn = UIButton(type: UIButtonType.custom)
        
        return downLoadBtn
    }()
    
    /// 返回按钮
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.setImage(BARImage(file: "ZFPlayer_back_full"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return backBtn
    }()
    func backBtnClick(_ sender:Any) {
        print("返回")
    }
    
    /// 切换分辨率按钮
    lazy var resolutionBtn: UIButton = {
        let resolutionBtn = UIButton(type: UIButtonType.custom)
        resolutionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return resolutionBtn
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(backBtn)
        self.addSubview(downLoadBtn)
        self.addSubview(resolutionBtn)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate  func makeSubViewsConstraints() {
        self.backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(10)
            make.top.equalTo(self.snp.top).offset(3)
            make.width.height.equalTo(40)
        }
        self.downLoadBtn.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(49)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        self.resolutionBtn.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(25)
            make.trailing.equalTo(self.downLoadBtn.snp.leading).offset(-10)
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.backBtn.snp.trailing).offset(5)
            make.centerY.equalTo(self.backBtn.snp.centerY)
            make.trailing.equalTo(self.resolutionBtn.snp.leading).offset(-10)
        }
    }
}

/// 底部视图
private class BottomImageView:UIImageView,UIGestureRecognizerDelegate{
    weak var delegate:PlayActionDelegate?
    
    /// 开始播放按钮
    lazy var startBtn:UIButton = {
        let startBtn = UIButton(type: UIButtonType.custom)
        startBtn.setImage(BARImage(file: "ZFPlayer_play"), for: UIControlState.normal)
        startBtn.setImage(BARImage(file: "ZFPlayer_pause"), for: UIControlState.selected)
        startBtn.addTarget(self, action: #selector(startBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return startBtn
    }()
    func startBtnClick(_ sender:Any) {
        self.startBtn.isSelected = !self.startBtn.isSelected
        self.delegate?.playAction?()
        print("开始播放")
    }
    
    lazy var currentTimeLabel:UILabel = {
        let currentTimeLabel = UILabel()
        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        currentTimeLabel.textAlignment = NSTextAlignment.center
        return currentTimeLabel
    }()
    
    lazy var progressView:UIProgressView = {
       let progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progressView.progressTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()
    
    
    /// slider控制
    lazy var videoSlider: PlayerSlider = {
        let videoSlider = PlayerSlider()
        videoSlider.setThumbImage(BARImage(file: "ZFPlayer_slider"), for: UIControlState.normal)
        videoSlider.maximumValue = 1
        videoSlider.minimumTrackTintColor = UIColor.white
        videoSlider.maximumTrackTintColor = RGBA(r: 0.5, g: 0.5, b: 0.5, a: 0.5)
        //slider事件
        videoSlider.addTarget(self, action: #selector(progressSliderTouchBegan(_:)), for: UIControlEvents.touchDown)
        videoSlider.addTarget(self, action: #selector(progressSliderValueChanged(_:)), for: UIControlEvents.valueChanged)
        videoSlider.addTarget(self, action: #selector(progressSliderTouchEnded(_:)), for: [UIControlEvents.touchUpInside, UIControlEvents.touchCancel,  UIControlEvents.touchUpOutside])
        let sliderTap = UITapGestureRecognizer(target: self, action: #selector(tapSliderAction(_:)))
        videoSlider.addGestureRecognizer(sliderTap)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer(_:)))
        panRecognizer.maximumNumberOfTouches = 1;
        panRecognizer.delaysTouchesBegan = true
        panRecognizer.delaysTouchesEnded = true
        panRecognizer.cancelsTouchesInView = true
        panRecognizer.delegate = self
        videoSlider.addGestureRecognizer(panRecognizer)
        return videoSlider
    }()
    func progressSliderTouchBegan(_ slider:UISlider) {
        self.delegate?.progressSliderTouchBegan?(slider)
    }
    func progressSliderValueChanged(_ slider:UISlider) {
        self.delegate?.progressSliderValueChanged?(slider)
    }
    func progressSliderTouchEnded(_ slider:UISlider) {
        self.delegate?.progressSliderTouchEnded?(slider)
    }
    func tapSliderAction(_ gesture:UIGestureRecognizer) {
        if gesture.view!.isKind(of: UISlider.classForCoder()) {
            let slider = gesture.view as! UISlider
            let point = gesture.location(in: slider)
            let length = slider.frame.size.width
            let tapValue = point.x / length
            self.delegate?.progressSliderTap?(value: tapValue)
        }
        
    }
    func panRecognizer(_ recognizer:UIGestureRecognizer) {
        
    }
    fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let rect = self.thumbRect()
        let point = touch.location(in: self.videoSlider)
        if touch.view!.isKind(of: UISlider.classForCoder()) {
            if (point.x <= rect.origin.x + rect.size.width)&&(point.x >= rect.origin.x) {
                return false
            }
        }
        return true
    }
    
    func thumbRect() -> CGRect {
        return self.videoSlider.thumbRect(forBounds: self.videoSlider.bounds, trackRect: self.videoSlider.trackRect(forBounds: self.videoSlider.bounds), value: self.videoSlider.value)
    }
    
    /// 全屏按钮
    lazy var fullScreenBtn:UIButton = {
        let fullScreenBtn = UIButton(type: UIButtonType.custom)
        fullScreenBtn.setImage(BARImage(file: "ZFPlayer_fullscreen"), for: UIControlState.normal)
        fullScreenBtn.setImage(BARImage(file: "ZFPlayer_shrinkscreen"), for: UIControlState.selected)
        fullScreenBtn.addTarget(self, action: #selector(fullScreenBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return fullScreenBtn
    }()
    func fullScreenBtnClick(_ sender:Any) {
        self.fullScreenBtn.isSelected = !self.fullScreenBtn.isSelected
        self.delegate?.fullscreenAction?()
        print("全屏")
    }
    
    lazy var totalTimeLabel: UILabel = {
        let totalTimeLabel = UILabel()
        totalTimeLabel.textColor = UIColor.white
        totalTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        totalTimeLabel.textAlignment = NSTextAlignment.center
        return totalTimeLabel
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(startBtn)
        self.addSubview(currentTimeLabel)
        self.addSubview(fullScreenBtn)
        self.addSubview(totalTimeLabel)
        self.addSubview(progressView)
        self.addSubview(videoSlider)
        //        self.makeSubViewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeSubViewsConstraints() {
        self.startBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
            make.width.height.equalTo(30)
        }
        self.currentTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.startBtn.snp.trailing).offset(-3)
            make.centerY.equalTo(self.startBtn.snp.centerY)
            make.width.equalTo(43)
        }
        self.fullScreenBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.trailing.equalTo(self.snp.trailing).offset(-5)
            make.centerY.equalTo(self.startBtn.snp.centerY)
        }
        self.totalTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.fullScreenBtn.snp.leading).offset(3)
            make.centerY.equalTo(self.startBtn.snp.centerY)
            make.width.equalTo(43)
        }
        self.progressView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.currentTimeLabel.snp.trailing).offset(4)
            make.trailing.equalTo(self.totalTimeLabel.snp.leading).offset(-4)
            make.centerY.equalTo(self.startBtn.snp.centerY)
        }
        self.videoSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(self.currentTimeLabel.snp.trailing).offset(4)
            make.trailing.equalTo(self.totalTimeLabel.snp.leading).offset(-4)
            make.centerY.equalTo(self.currentTimeLabel.snp.centerY).offset(-1)
            make.height.equalTo(30)
        }
    }
    
}

/// 快进视图
private class FastView:PlayerView.View{
    lazy var progressView:UIProgressView = {
       let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.white
        progressView.trackTintColor = UIColor.lightGray.withAlphaComponent(0.4)
        return progressView
    }()
    lazy var timeLabel:UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.font = UIFont.systemFont(ofSize: 14.0)
        return timeLabel
    }()
    lazy var symolImageView:UIImageView = {
        let symolImageView = UIImageView()
        return symolImageView
    }()
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(progressView)
        self.addSubview(self.timeLabel)
        self.addSubview(self.symolImageView)
//        self.makeSubViewsConstraints()
    }
    
    override func makeSubViewsConstraints() {
        self.symolImageView.snp.makeConstraints { (make) in
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.top.equalTo(5)
            make.centerX.equalToSuperview()
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.leading.leading.equalTo(0)
            make.top.equalTo(self.symolImageView.snp.bottom).offset(2)
        }
        self.progressView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}














