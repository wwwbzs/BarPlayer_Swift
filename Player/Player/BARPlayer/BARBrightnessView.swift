//
//  BARBrightnessView.swift
//  Player
//
//  Created by Barray on 2017/4/27.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit
import Foundation

class BARBrightnessView: UIView {
    
    //MARK: MARK:attribute
    /// 是否锁屏
    var isLockScreen = false
    
    /// 是否能转屏
    private var isTurnScreen = false
    /// 是否是横屏状态
    private var isLandScape = false
    
    func isLandscape(_ isLandScape:Bool){
       self.isLandScape = isLandScape
        APP_WINDOW.bar_currentViewController()?.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    private var isStatusBarHidden = false
    
    func setIsStatusBarHidden(_ isStatusBarHidden:Bool){
        self.isStatusBarHidden = isStatusBarHidden
        APP_WINDOW.bar_currentViewController()?.setNeedsStatusBarAppearanceUpdate()
    }
    
    func getIsStatusBarHidden() -> Bool {
        return isStatusBarHidden
    }
    
    fileprivate var backImage:UIImageView?
    fileprivate var title:UILabel?
    fileprivate var longView:UIView?
    fileprivate var tipArray:NSMutableArray?
    fileprivate var orientationDidChange:Bool?
    
    
    
    static let instance = BARBrightnessView.init()
    
    private init(){
        super.init(frame:  CGRect(x: SCREEN_WIDTH*0.5, y: SCREEN_HEIGHT*0.5, width: 155, height: 155))
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        if #available(iOS 8.0, *) {
            let effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let effectView = UIVisualEffectView(effect: effect)
            effectView.frame = self.bounds
            self.addSubview(effectView)
        } else {
            let toolbar = UIToolbar.init(frame: self.bounds)
            toolbar.alpha = 0.97
            toolbar.barStyle = UIBarStyle.default
            self.addSubview(toolbar)
        }
        self.backImage = ({
            ()->UIImageView?in
            let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 79, height: 76))
            imgView.image = BARImage(file: "ZFPlayer_brightness")
            self.addSubview(imgView)
            return imgView
        }())
        self.title = ({
            ()->UILabel?in
            let title = UILabel(frame: CGRect(x: 0, y: 5, width: self.bounds.size.width, height: 30))
            title.font = UIFont.boldSystemFont(ofSize: 16)
            title.textColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1.00)
            title.textAlignment = NSTextAlignment.center
            title.text = "亮度"
            self.addSubview(title)
            return title
        }())
        self.longView = ({
            ()->UIView?in
            let longView = UIView(frame: CGRect(x: 13, y: 132, width: self.bounds.size.width, height: 7))
            longView.backgroundColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1.00)
            self.addSubview(longView)
            return longView
        }())
        self.createTips()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ---- deinit
    deinit {
        UIScreen.main.removeObserver(self, forKeyPath: "brightness")
        NotificationCenter.default.removeObserver(self)
    }
}


extension BARBrightnessView{
    
    /// tips
     fileprivate func createTips() {
        self.tipArray = NSMutableArray(capacity: 16)
        let tipW = ((self.longView?.bounds.size.width)! - 17)/16
        let tipH:CGFloat = 5
        let tipY:CGFloat = 1
        
        for i in 0..<16 {
            let tipX = CGFloat(i) * (tipW + 1) + 1
            let image = UIImageView.init()
            image.backgroundColor = UIColor.white
            image.frame = CGRect(x: tipX, y: tipY, width: tipW, height: tipH)
            self.longView?.addSubview(image)
            self.tipArray?.add(image)
        }
        self.updateLongView(UIScreen.main.brightness)
        self.addNotification()
        
        self.alpha = 0.0
    }
    //MARK: ------ Notification kvo
    fileprivate func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayer(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    fileprivate func addObserver() {
        UIScreen.main.addObserver(self, forKeyPath: "brightness", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let sound = change?[NSKeyValueChangeKey.newKey] as? CGFloat
        self.appearSoundView()
        self.updateLongView(sound!)
        
    }
    
    @objc fileprivate func updateLayer(_ notify:Notification){
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    fileprivate func updateLongView(_ sound:CGFloat) {
        let stage:CGFloat = 1/15.0
        let level:NSInteger = NSInteger(sound/stage)
        
        for i in 0..<self.tipArray!.count {
            let img:UIImageView = self.tipArray?[i] as! UIImageView
            if i <= level {
                img.isHidden = false
            } else {
                img.isHidden = true
            }
        }
    }
}

//MARK:---- Methond

extension BARBrightnessView{
    
    fileprivate func appearSoundView(){
        if self.alpha == 0.0 {
            self.orientationDidChange = false
            self.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
                self.disAppearSoundView()
            })
        }
    }
    
    fileprivate func disAppearSoundView(){
        if self.alpha == 1.0 {
            UIView.animate(withDuration: 0.8, animations: { 
                self.alpha = 0.0;
            })
        }
    }
}



extension BARBrightnessView{
    
    
}








