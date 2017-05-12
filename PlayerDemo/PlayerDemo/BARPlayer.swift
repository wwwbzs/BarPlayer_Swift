//
//  BARPlayer.swift
//  Player
//
//  Created by Barray on 2017/4/27.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation
import UIKit

let kBar_ObserverPVCOffset = "contentOffset"

let APP_WINDOW:UIWindow! = (UIApplication.shared.delegate?.window)!
let SCREEN_BOUNDS = UIScreen.main.bounds
let SCREEN_WIDTH = SCREEN_BOUNDS.size.width
let SCREEN_HEIGHT = SCREEN_BOUNDS.size.height


func BARSrcName(bundle:String,file:String) -> String {
    let fileBundle:NSMutableString = NSMutableString(string: bundle)
    
    if !bundle.contains("bundle") {
        fileBundle.append(".bundle")
    }
    
    
    return fileBundle.appendingPathComponent(file)
}

//TODO: ---- 以后修改
func BARFrameworkSrcName(file:String) -> String {
    let path:NSString = NSString(string: "Frameworks/ZFPlayer.framework/ZFPlayer.bundle")
    return path.appendingPathComponent(file)
}

func BARImage(file:String) -> UIImage? {
    return UIImage(named: BARSrcName(bundle: "ZFPlayer", file: file)) != nil ? UIImage(named: BARSrcName(bundle: "ZFPlayer", file: file)) : UIImage(named: BARFrameworkSrcName(file: file))
}
		
