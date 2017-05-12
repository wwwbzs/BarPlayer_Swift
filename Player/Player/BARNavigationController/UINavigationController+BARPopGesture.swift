//
//  UINavigationController+BARPopGesture.swift
//  Player
//
//  Created by Barray on 2017/4/26.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation
import UIKit



let MAX_PAN_DISTANCE = 150
let PAN_ENABEL_DISTANCe = SCREEN_WIDTH

class BARScreenShotView: UIView {
    var imageView:UIImageView?
    var _maskView: UIView?

    init() {
        super.init(frame: CGRect.zero)
        imageView = UIImageView.init(frame: SCREEN_BOUNDS)
        self.addSubview(imageView!)
        _maskView = UIView.init(frame: SCREEN_BOUNDS)
        _maskView?.backgroundColor = UIColor.clear
        self.addSubview(_maskView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIViewController{
    
    var bar_prefersNavigationBarHidden:Bool{
        get {
            return objc_getAssociatedObject(self, RuntimeKey.bar_prefersNavigationBarHiddenKey) as? Bool == nil ? false : (objc_getAssociatedObject(self, RuntimeKey.bar_prefersNavigationBarHiddenKey) as? Bool)!
        }
        set{
            objc_setAssociatedObject(self, RuntimeKey.bar_prefersNavigationBarHiddenKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    var bar_interactivePopDisabled:Bool{
        get {
            return objc_getAssociatedObject(self, RuntimeKey.bar_interactivePopDisabledKey) as? Bool == nil ? false : (objc_getAssociatedObject(self, RuntimeKey.bar_interactivePopDisabledKey) as? Bool)!
        }
        set{
            objc_setAssociatedObject(self, RuntimeKey.bar_interactivePopDisabledKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    var bar_recognizeSimultaneouslyEnable:Bool{
        get {
            return objc_getAssociatedObject(self, RuntimeKey.bar_interactivePopDisabledKey) as? Bool == nil ? false : (objc_getAssociatedObject(self, RuntimeKey.bar_recognizeSimultaneouslyEnableKey) as? Bool)!
        }
        set{
            objc_setAssociatedObject(self, RuntimeKey.bar_recognizeSimultaneouslyEnableKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

typealias _BARViewControllerWillAppearInjectBlock = (UIViewController,Bool)->Void
typealias _BARPopToMovieViewContollerBlock = (UIViewController,Bool)->Void
class BlockWrapper: NSObject {
    var value:_BARViewControllerWillAppearInjectBlock?
    var popBlock:_BARPopToMovieViewContollerBlock?
    
    init(value:@escaping _BARViewControllerWillAppearInjectBlock) {
        self.value = value
    }
    init(popBlock:@escaping _BARPopToMovieViewContollerBlock) {
        self.popBlock = popBlock
    }
    
}

extension UIViewController{
    
    override open class func initialize(){
        struct Static {
            static let _onceToken = NSUUID().uuidString+"0"
        }
        
        // 确保不是子类
        if self !== UIViewController.self {
            return
        }
        
        DispatchQueue.once(token: Static._onceToken) {
            let originalSelector = #selector(viewWillAppear(_:))
            let swizzledSelector = #selector(bar_viewWillAppear(_:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)!
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let success = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if success{
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else{
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    func bar_viewWillAppear(_ animated:Bool) {
        self.bar_viewWillAppear(animated)
        self.bar_willAppearInjectBlock?(self,animated)
    }
    
    //动态单独加入闭包setter会出现变异错误，通过BlockWrapper作为通道模糊进行处理 把闭包封装入object
    var bar_willAppearInjectBlock:_BARViewControllerWillAppearInjectBlock?{
        get{
            let wrapper:BlockWrapper? = objc_getAssociatedObject(self, RuntimeKey._BARViewControllerWillAppearInjectBlockKey) as? BlockWrapper
            let block = wrapper?.value
            return block
            
        }
        set{
            let wrapper = BlockWrapper(value: newValue!)
            
           objc_setAssociatedObject(self, RuntimeKey._BARViewControllerWillAppearInjectBlockKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bar_popToMovieViewControllerBlock:_BARPopToMovieViewContollerBlock?{
        get{
            let wrapper:BlockWrapper? = objc_getAssociatedObject(self, RuntimeKey._BARPopToMovieViewContollerBlockKey) as? BlockWrapper
            let block = wrapper?.popBlock
            return block
        }
        set{
            let wrapper = BlockWrapper(popBlock: newValue!)
            objc_setAssociatedObject(self, RuntimeKey._BARPopToMovieViewContollerBlockKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

enum BARFullscreenPopGestureStyle:Int {
    case BARFullscreenPopGestureGradientStyle = 0
    case BARFullscreenPopGestureShadowStyle
}

extension UINavigationController{
    func bar_setupViewControllerBasedNavigationBar(_ appearingViewController:UIViewController) {
        if !self.bar_viewControllerBasedNavigationBarAppearanceEnabled {
            return
        }
        
        let block = {
            (viewController:UIViewController,animated:Bool) in
            self.setNavigationBarHidden(viewController.bar_prefersNavigationBarHidden, animated: animated)
        }
        appearingViewController.bar_willAppearInjectBlock = block
        let disappearingViewController = self.viewControllers.last
        if disappearingViewController != nil && disappearingViewController?.bar_willAppearInjectBlock == nil {
            disappearingViewController?.bar_willAppearInjectBlock = block
        }
    }
}

//TODO: Getter and Setter
extension UINavigationController{
    
    var childVCImages:Array<UIImage>{
        get{
            var images = objc_getAssociatedObject(self, RuntimeKey.childVCImagesKey)
            if images == nil {
                images = Array<UIImage>.init()
                objc_setAssociatedObject(self, RuntimeKey.childVCImagesKey, images, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return images as! Array<UIImage>
        }
        set{
            objc_setAssociatedObject(self, RuntimeKey.childVCImagesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func screenShotView() -> BARScreenShotView {
        var shotView:BARScreenShotView? = objc_getAssociatedObject(self, RuntimeKey.screenShotViewKey) as? BARScreenShotView
        if (shotView == nil) {
            shotView = BARScreenShotView.init()
            shotView!.isHidden = true
            APP_WINDOW.insertSubview(shotView!, at: 0)
            objc_setAssociatedObject(self, RuntimeKey.screenShotViewKey, shotView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
        return shotView!
        
    }
    
    var bar_viewControllerBasedNavigationBarAppearanceEnabled:Bool{
        get {
            return objc_getAssociatedObject(self, RuntimeKey.bar_viewControllerBasedNavigationBarAppearanceEnabledKey) as? Bool == nil ? false : (objc_getAssociatedObject(self, RuntimeKey.bar_viewControllerBasedNavigationBarAppearanceEnabledKey) as? Bool)!
        }
        set{
            objc_setAssociatedObject(self, RuntimeKey.bar_viewControllerBasedNavigationBarAppearanceEnabledKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var viewOffset:CGFloat!{
        get{
            return objc_getAssociatedObject(self, RuntimeKey.viewOffsetKey) as! CGFloat?
        }
        set{
            objc_setAssociatedObject(self, RuntimeKey.viewOffsetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var viewOffsetScale:CGFloat{
        get{
            return objc_getAssociatedObject(self, RuntimeKey.viewOffsetScaleKey) as? CGFloat == nil ? 0 : (objc_getAssociatedObject(self, RuntimeKey.viewOffsetScaleKey) as? CGFloat)!
        }
        set{
             print(newValue)
            objc_setAssociatedObject(self, RuntimeKey.viewOffsetScaleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var popGestureStyle:BARFullscreenPopGestureStyle{
        get{
            return objc_getAssociatedObject(self, RuntimeKey.popGestureStyleKey) as? BARFullscreenPopGestureStyle == nil ? .BARFullscreenPopGestureGradientStyle : (objc_getAssociatedObject(self, RuntimeKey.popGestureStyleKey) as? BARFullscreenPopGestureStyle)!
        }
        set{
            objc_setAssociatedObject(self, RuntimeKey.popGestureStyleKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue == .BARFullscreenPopGestureGradientStyle {
                self.screenShotView()._maskView?.isHidden = false
            } else if newValue == .BARFullscreenPopGestureShadowStyle{
                self.screenShotView()._maskView?.isHidden = true
                self.view.layer.shadowColor = UIColor.gray.cgColor
                self.view.layer.shadowOpacity = 0.7
                self.view.layer.shadowOffset = CGSize(width: -3, height: 0)
                self.view.layer.shadowRadius = 10
            }
        }
    }
}

//TODO:----- override superMethod
extension UINavigationController{
    
    override open class func initialize(){
        struct Static {
            static let _onceToken = NSUUID().uuidString+"1"
        }
        
        // 确保不是子类
        if self !== UINavigationController.self {
            return
        }
        DispatchQueue.once(token: Static._onceToken) { () in
            let originalSelectors = [
                #selector(viewDidLoad),
                #selector(pushViewController(_: animated:)),
                #selector(popToViewController(_:animated:)),
                #selector(popToRootViewController(animated:)),
                #selector(popViewController(animated:))
            ]
            
            let swizzledSelectors = [#selector(bar_viewDidLoad),#selector(bar_pushViewController(_:animated:)),#selector(bar_popToViewController(_:animated:)),#selector(bar_popToRootViewController(animated:)),#selector(bar_popViewController(animated:))
            ]
            
            for index in 0..<originalSelectors.count {
                let originalSelector = originalSelectors[index]
                let swizzledSelector = swizzledSelectors[index]
                let originalMethod = class_getInstanceMethod(self, originalSelector)!
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
                
                let success = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
                if success{
                    class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
                } else{
                    method_exchangeImplementations(originalMethod, swizzledMethod);
                }
            }
        }
    }
    
    func bar_viewDidLoad(){
        self.bar_viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.bar_viewControllerBasedNavigationBarAppearanceEnabled = true
        self.viewOffsetScale = CGFloat(1/3.0)
        self.viewOffset = self.viewOffsetScale*SCREEN_WIDTH
        self.screenShotView().isHidden = true
        self.popGestureStyle = .BARFullscreenPopGestureGradientStyle
        let popRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragging(_:)))
        popRecognizer.delegate = self
        self.view.addGestureRecognizer(popRecognizer)
    }
    
    func bar_pushViewController(_ viewController:UIViewController,animated:Bool){
        if self.childViewControllers.count > 0 {
            self.createScreenShot()
        }
        self.bar_setupViewControllerBasedNavigationBar(viewController)
        if !self.viewControllers.contains(viewController) {
            self.bar_pushViewController(viewController, animated: animated)
        }
    }
    
    func bar_popViewController(animated:Bool) -> UIViewController? {
        self.childVCImages.removeLast()
        return self.bar_popViewController(animated: animated)
        self.bar_popToMovieViewControllerBlock?(self,animated)
    }
    
    func bar_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?{
        let viewControllers = self.bar_popToViewController(viewController, animated: animated)
        if self.childVCImages.count >= (viewControllers?.count)! {
            for _ in 0 ..< (viewControllers?.count)!{
                self.childVCImages.removeLast()
            }
        }
        return viewControllers
    }
    
    func bar_popToRootViewController(animated: Bool) -> [UIViewController]?{
        self.childVCImages.removeAll()
        return self.bar_popToRootViewController(animated: animated)
    }
    
}

//TODO: --- UIGestureRecognizerDelegate
extension UINavigationController:UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (self.visibleViewController?.bar_interactivePopDisabled)! {
            return false
        }
        if self.viewControllers.count <= 1 {
            return false
        }
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
            let point = touch.location(in: gestureRecognizer.view)
            if point.x < PAN_ENABEL_DISTANCe {
                return true
            }
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.visibleViewController?.bar_recognizeSimultaneouslyEnable)! {
            if otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!)||otherGestureRecognizer.isKind(of: NSClassFromString("UIPanGestureRecognizer")!) {
                return true
            }
        }
        return false
    }
}

//TODO: ---  Dragging and CreatrShot

extension UINavigationController{
    func dragging(_ recognizer:UIPanGestureRecognizer) {
        if self.viewControllers.count <= 1 {
            return
        }
        let topX = recognizer.translation(in: self.view).x
        var width_scale:CGFloat
        if recognizer.state == UIGestureRecognizerState.began {
            width_scale = 0
            self.screenShotView().isHidden = false
            self.screenShotView().imageView?.image = self.childVCImages.last
            self.screenShotView().imageView?.transform = CGAffineTransform.identity.translatedBy(x: -self.viewOffset, y: 0)
            self.screenShotView()._maskView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        } else if(recognizer.state == UIGestureRecognizerState.changed){
            if topX < 0 {
                return
            }
            width_scale = topX/SCREEN_WIDTH
            self.view.transform = CGAffineTransform.identity.translatedBy(x: topX, y: 0)
            self.screenShotView()._maskView?.backgroundColor = UIColor.black.withAlphaComponent(0.4-width_scale*0.5)
            self.screenShotView().imageView?.transform = CGAffineTransform.identity.translatedBy(x: -self.viewOffset+topX*self.viewOffsetScale, y: 0)
        } else if(recognizer.state == UIGestureRecognizerState.ended){
            let velocity = recognizer.velocity(in: self.view)
            let reset = velocity.x < 0
            if (topX >= CGFloat(MAX_PAN_DISTANCE)) && !reset {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.screenShotView()._maskView?.backgroundColor = UIColor.clear
                    self.screenShotView().imageView?.transform = reset ? CGAffineTransform.identity.translatedBy(x: -self.viewOffset, y: 0) : CGAffineTransform.identity
                    self.view.transform = reset ? CGAffineTransform.identity : CGAffineTransform.identity.translatedBy(x: SCREEN_WIDTH, y: 0)
                }, completion: { (finished:Bool) in
                    
                    self.popViewController(animated: false)
                    self.screenShotView().isHidden = true
                    self.view.transform = CGAffineTransform.identity
                    self.screenShotView().imageView?.transform = CGAffineTransform.identity
                })
            } else {
                width_scale = topX / SCREEN_WIDTH;
                UIView.animate(withDuration: 0.25, animations: {
                    self.screenShotView()._maskView?.backgroundColor = UIColor.black.withAlphaComponent(0.4+width_scale*0.5)
                    self.view.transform = CGAffineTransform.identity
                    self.screenShotView().imageView?.transform = CGAffineTransform.identity.translatedBy(x: -self.viewOffset, y: 0)
                }, completion: { (finished:Bool) in
                    self.screenShotView().imageView?.transform = CGAffineTransform.identity
                })
            }
        }
        
        
    }
    
    func createScreenShot(){
        if self.childViewControllers.count == self.childVCImages.count+1 {
            UIGraphicsBeginImageContextWithOptions(APP_WINDOW.bounds.size, true, 0)
            APP_WINDOW.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.childVCImages.append(image!)
        }
    }
}

