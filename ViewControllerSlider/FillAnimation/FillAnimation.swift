//
//  FillAnimation.swift
//  ViewControllerSlider
//
//  Created by Aydın ÜNAL on 7.03.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//

import Foundation
import UIKit

class FillAnimationView: UIView{
    fileprivate struct Constant {
        static let path = "path"
        static let circle = "circle"
    }
    
    class func animationViewOnView(_ view: UIView, color: UIColor) -> FillAnimationView{
        let animationView = Init(FillAnimationView(frame: CGRect.zero)) {
            $0.backgroundColor = color
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(animationView)
        for attribute in [NSLayoutConstraint.Attribute.top, NSLayoutConstraint.Attribute.bottom, NSLayoutConstraint.Attribute.left, NSLayoutConstraint.Attribute.right] {
            (view, animationView) >>>- {$0.attribute = attribute; return}
        }
        
        return animationView
    }
    
    func fillAnimation(_ color: UIColor, centerPosition: CGPoint, duration: Double){
        let radius = max(bounds.size.width, bounds.size.height) * 1.5
        let circle = createCircleLayer(centerPosition, color: color)
        let animation = animationToRadius(radius, center: centerPosition, duration: duration)
        animation.setValue(circle, forKey: Constant.circle)
        circle.add(animation, forKey: nil)
        
    }
    
    fileprivate func createCircleLayer(_ centerPosition: CGPoint, color: UIColor) -> CAShapeLayer{
        let path = UIBezierPath(arcCenter: centerPosition, radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi * 2) , clockwise: true)
        let layer = Init(CAShapeLayer()){
            $0.path = path.cgPath
            $0.fillColor = color.cgColor
            $0.shouldRasterize = true
        }
        self.layer.addSublayer(layer)
        return layer
    }
    
}

extension FillAnimationView: CAAnimationDelegate {
    fileprivate func animationToRadius(_ radius: CGFloat, center: CGPoint, duration: Double) -> CABasicAnimation {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        let animation = Init(CABasicAnimation(keyPath: Constant.path)) {
            $0.duration = duration
            $0.toValue = path.cgPath
            $0.isRemovedOnCompletion = false
            $0.fillMode = .forwards
            $0.delegate = self
            $0.timingFunction = CAMediaTimingFunction(name: .easeIn)
        }
        return animation
    }
    
    func animationDidStop(_ anim: CAAnimation, finished _: Bool) {
        
        guard let circleLayer = anim.value(forKey: Constant.circle) as? CAShapeLayer else {
            return
        }
        layer.backgroundColor = circleLayer.fillColor
        circleLayer.removeFromSuperlayer()
    }
}

