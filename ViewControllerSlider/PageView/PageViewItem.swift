//
//  PageViewItem.swift
//  ViewControllerSlider
//
//  Created by Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu] on 28.02.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//

import Foundation
import UIKit
class PageViewItem: UIView {
    let circleRadius: CGFloat
    let selectedCircleRadius: CGFloat
    let lineWidth: CGFloat
    let itemColor: UIColor
    var isSelected: Bool
    var centerView: UIView?
    var imageView: UIImageView?
    var circleLayer: CAShapeLayer?
    var tickIndex: Int = 0
    
    init(radius: CGFloat, itemColor: UIColor, selectedRadius: CGFloat, lineWidth: CGFloat = 3, isSelected: Bool = false){
        self.circleRadius = radius
        self.itemColor = itemColor
        self.lineWidth = lineWidth
        self.isSelected = isSelected
        self.selectedCircleRadius = selectedRadius
        
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Public

extension PageViewItem {
    func animationSelected(_ selected: Bool, duration: Double, fillColor: Bool ) {
        let toAlpha: CGFloat = selected == true ? 1 : 0
        imageAlphaAnimation(toAlpha, duration: duration)
        let currentRadius = selected == true ? selectedCircleRadius : circleRadius
        let scaleAnimation = circleScaleAnimation(toRadius: currentRadius - lineWidth / 2.0, duration: duration)
        let toColor = fillColor == true ? itemColor : UIColor.clear
        let colorAnimation = circleBackgroundAnimation(toColor: toColor, duration: duration)
        circleLayer?.add(scaleAnimation, forKey: nil)
        circleLayer?.add(colorAnimation, forKey: nil)
    }
}

//MARK: configuration

extension PageViewItem {
    fileprivate func commonInit(){
        centerView = createBorderView()
    }
    
    fileprivate func createBorderView() -> UIView{
        let view = Init(UIView(frame: CGRect.zero)) {
            $0.backgroundColor = .blue
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(view)
        
        //Create circle layer
        let currentRadius = isSelected ? selectedCircleRadius : circleRadius
        let circleLayer = createCircleLayer(currentRadius, lineWidth: lineWidth)
        view.layer.addSublayer(circleLayer)
        self.circleLayer = circleLayer
        
        //Add constraints
        [NSLayoutConstraint.Attribute.centerX, NSLayoutConstraint.Attribute.centerY].forEach { attribute in
            (self, view) >>>- {
                $0.attribute = attribute
                return
            }
        }
        [NSLayoutConstraint.Attribute.height, NSLayoutConstraint.Attribute.width].forEach { attribute in
            view >>>- {
                $0.attribute = attribute
                return
            }
        }
        return view
    }
    
    //DRAWING CIRCLE
    fileprivate func createCircleLayer(_ radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius - lineWidth / 2.0, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        let layer = Init(CAShapeLayer()) {
            $0.path = path.cgPath
            $0.lineWidth = lineWidth
            $0.strokeColor = itemColor.cgColor
            $0.fillColor = UIColor.clear.cgColor
        }
        return layer
    }
}



//MARK: Animations

extension PageViewItem {
    
    //Animation to make circle bigger.
    fileprivate func circleScaleAnimation(toRadius: CGFloat, duration: Double) -> CABasicAnimation {
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: toRadius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        let animation = Init(CABasicAnimation(keyPath: "path")) { (anim) in
            anim.duration = duration
            anim.toValue = path.cgPath
            anim.isRemovedOnCompletion = false
            anim.fillMode = .forwards
        }
        return animation
    }
    
    fileprivate func circleBackgroundAnimation(toColor: UIColor, duration: Double) -> CABasicAnimation {
        let animation = Init(CABasicAnimation(keyPath: "fillColor")) { (anim) in
            anim.duration = duration
            anim.toValue = toColor.cgColor
            anim.isRemovedOnCompletion = false
            anim.fillMode = .forwards
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        }
        return animation
    }
    
    //Alpha animation
    fileprivate func imageAlphaAnimation(_ toValue: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.imageView?.alpha = toValue
        }, completion: nil)
    }
}
