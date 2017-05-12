//
//  UIWindow_CurrentViewController.swift
//  Player
//
//  Created by Barray on 2017/4/27.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow{
    
    /// 获取当前视图控制器
    ///
    /// - Returns: currentViewController
    func bar_currentViewController() -> UIViewController? {
        var topVC = self.rootViewController
        while true {
            if topVC?.presentedViewController != nil {
                topVC = topVC?.presentedViewController
            } else if (topVC?.isKind(of: UINavigationController.classForCoder()))! && (topVC as! UINavigationController).topViewController != nil {
                topVC = (topVC as! UINavigationController).topViewController
            } else if (topVC?.isKind(of: UITabBarController.classForCoder()))!{
                topVC = (topVC as! UITabBarController).selectedViewController
            } else{
                break
            }
        }
        return topVC
    }
}
