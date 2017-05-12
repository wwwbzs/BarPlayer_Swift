//
//  BARCutPopView.swift
//  Player
//
//  Created by Barray on 2017/5/2.
//  Copyright © 2017年 Barray. All rights reserved.
//

import UIKit

protocol BARCutPopViewDelegate:NSObjectProtocol {
    func currentCutOffset() -> CGFloat
    func colorDidUpdate(_ opaqueColor:UIColor)
}

enum BARCutPopViewStyle {
    case centre
    case top
}

fileprivate extension CALayer{
    func animate(key animationName:String,from value:Any?,_ toValue:Any?,customize block:(_ animation:CABasicAnimation)->Void){
        self.setValue(toValue, forKey: animationName)
        let anim = CABasicAnimation(keyPath: animationName)
        anim.fromValue = value == nil ? nil: self.presentation()?.value(forKey: animationName)
        anim.toValue = toValue
        block(anim)
        self .add(anim, forKey: animationName)
    }
}

let SliderFillColorAnim = "fillColor";

class BARCutPopView: UIView {
    weak var delegate:BARCutPopViewDelegate?
    var cornerRadius:CGFloat = 0.0
    var arrowLength:CGFloat = 0.0
    var widthPaddingFactor:CGFloat = 0.0
    var heightPaddingFactor:CGFloat = 0.0
    
    private var _shouldAnimate:Bool?
    private var _animDuration:CFTimeInterval?
    private var _pathLayer:CAShapeLayer?
    private var _timeLabe:UILabel?
    private var _imageView:UIImageView?
    private var _colorAnimLayer:CAShapeLayer?
    
    override static var layerClass:AnyClass{
        get{
            return CAShapeLayer.classForCoder()
        }
    }
    
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if _shouldAnimate! {
            let anim = CABasicAnimation(keyPath: event)
            anim.beginTime = CACurrentMediaTime()
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            anim.fromValue = layer.presentation()?.value(forKey: event)
            anim.duration = _animDuration!
            return anim
        } else{
            return NSNull() as CAAction
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _shouldAnimate = false
        _pathLayer = self.layer as? CAShapeLayer
        cornerRadius = 4.0;
        arrowLength = 13.0;
        widthPaddingFactor = 1.15;
        heightPaddingFactor = 1.1;
        _colorAnimLayer = CAShapeLayer()
        _timeLabe = UILabel.init()
        
        _timeLabe?.text = "10:00"
        _timeLabe?.font = UIFont.systemFont(ofSize: 10.0)
        _timeLabe?.textColor = UIColor.white
        self.addSubview(_timeLabe!)
        _imageView = UIImageView.init(frame: CGRect.zero)
        self.addSubview(_imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func color() -> UIColor {
        return UIColor(cgColor: (_pathLayer?.presentation()?.fillColor)!)
    }
    func setColor(_ color:UIColor) {
        _pathLayer?.fillColor = color.cgColor
        _colorAnimLayer?.removeAnimation(forKey: SliderFillColorAnim)
    }
    func opaqueColor() -> UIColor? {
        return opaqueUIColorFromCGColor(col: (_colorAnimLayer?.presentation()?.fillColor) == nil ? nil : _pathLayer?.fillColor)
    }
    
    func setText(_ text:String) {
        _timeLabe?.text = text
    }
    
    func setImage(_ image:UIImage?) {
        _imageView?.image = image
    }

}

func opaqueUIColorFromCGColor(col:CGColor?) -> UIColor? {
    if col == nil {
        return nil
    }
    var color:UIColor?
    let components = col?.components
    if col?.numberOfComponents == 2 {
        color = UIColor(white: (components?[0])!, alpha: 1.0)
    } else{
        color = UIColor(red: (components?[0])!, green: (components?[1])!, blue: (components?[2])!, alpha: 1.0)
    }
    return color
}
