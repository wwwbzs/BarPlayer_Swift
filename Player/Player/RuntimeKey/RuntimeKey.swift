//
//  RuntimeKey.swift
//  Player
//
//  Created by Barray on 2017/4/26.
//  Copyright © 2017年 Barray. All rights reserved.
//

import Foundation


public struct RuntimeKey {
    static let bar_prefersNavigationBarHiddenKey = UnsafeRawPointer.init(bitPattern: "bar_prefersNavigationBarHiddenKey".hashValue)
    static let bar_interactivePopDisabledKey = UnsafeRawPointer.init(bitPattern: "bar_interactivePopDisabledKey".hashValue)
    static let bar_recognizeSimultaneouslyEnableKey = UnsafeRawPointer.init(bitPattern: "bar_recognizeSimultaneouslyEnableKey".hashValue)
    static let _BARViewControllerWillAppearInjectBlockKey = UnsafeRawPointer.init(bitPattern: "_BARViewControllerWillAppearInjectBlockKey".hashValue)
    static let _BARPopToMovieViewContollerBlockKey = UnsafeRawPointer.init(bitPattern: "_BARPopToMovieViewContollerBlock".hashValue)
    static let bar_viewControllerBasedNavigationBarAppearanceEnabledKey = UnsafeRawPointer.init(bitPattern: "bar_viewControllerBasedNavigationBarAppearanceEnabledKey".hashValue)
    static let viewOffsetKey = UnsafeRawPointer.init(bitPattern: "viewOffsetKey".hashValue)
    static let viewOffsetScaleKey = UnsafeRawPointer.init(bitPattern: "viewOffScaleKey".hashValue)
    static let childVCImagesKey = UnsafeRawPointer.init(bitPattern: "childVCImagesKey".hashValue)
    static let screenShotViewKey = UnsafeRawPointer.init(bitPattern: "screenShotViewKey".hashValue)
    static let popGestureStyleKey = UnsafeRawPointer.init(bitPattern: "popGestureStyleKey".hashValue)
    
}
