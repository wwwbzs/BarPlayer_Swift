//
//  PlayerSlider.swift
//  PlayerDemo
//
//  Created by Barray on 2017/5/9.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit
import Foundation

class PlayerSlider: UISlider {
    
    var popUpViewColor:UIColor?
    
    var popUpViewAnimatedColors:Array<UIColor>?
    var popUpViewCornerRadius = 4.0
    var popUpViewArrowLength = 13.0
    var popUpViewWidthPaddingFactor = 1.15
    var popUpViewHeightPaddingFactor = 1.1
    
    var popUpView:BARCutPopView?{
        get{
            return self.getPopUpView()
        }
    }
    fileprivate var _popUpView:BARCutPopView?
    fileprivate func getPopUpView()->BARCutPopView? {
        return self._popUpView
    }
    fileprivate func set(popUpView:BARCutPopView){
        self._popUpView = popUpView
    }
    
    var autoAdjustTrackColor:Bool?
    weak var delegate:PlayerSliderDelegate?
    
    fileprivate var popUpViewAlwaysOn:Bool = false
    fileprivate var keyTimes:Array<Any>?
    fileprivate var valueRange:Float?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
//        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.autoAdjustTrackColor = true
        valueRange = self.maximumValue - self.minimumValue
        
    }
    
    func set(image:UIImage) {
        
    }
    
    func set(text:String) {
        
    }
    
    func set(popUpViewAnimatedColors colors:Array<UIColor>,with positions:Array<Any>?) {
        if positions != nil {
            assert(colors.count == positions?.count, "popUpViewAnimatedColors and locations should contain the same number of items")
        }
        popUpViewAnimatedColors = colors
        
    }

}

fileprivate extension PlayerSlider{
    func keyTimesFromSliderPositions(positions:NSArray?)-> NSArray? {
        if positions == nil {
            return nil
        }
        _ = NSMutableArray()
//        for num in (positions?.sortedArray(using: #selector(compareNum(_:)))!{
//            
//        }
        return nil
    }
}

extension PlayerSlider{
    func showpopUpView(animated:Bool) {
        
    }
    
    func hidePopUpView(animated:Bool) {
        
    }
}

protocol  PlayerSliderDelegate:NSObjectProtocol{
    
}
