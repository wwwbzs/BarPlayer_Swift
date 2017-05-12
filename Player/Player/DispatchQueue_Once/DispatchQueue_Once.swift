//
//  DispatchQueue_Once.swift
//  Player
//
//  Created by Barray on 2017/4/26.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    
    /// dispatxh_once
    ///
    /// - Parameters:
    ///   - token: onceToken
    ///   - block: todo
    public class func once(token: String, block: (Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
