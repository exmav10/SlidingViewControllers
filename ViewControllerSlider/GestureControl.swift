//
//  GestureControl.swift
//  ViewControllerSlider

import Foundation
import UIKit

protocol GestureControlDelegate: class {
    func gestureControlDidSwipe(_ direction: UISwipeGestureRecognizer.Direction)
}


class GestureControl: UIView {
    
    weak var delegate: GestureControlDelegate!
    
    init(view: UIView, delegate: GestureControlDelegate) {
        
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        view.addSubview(self)
        
        //Constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            (view, self) >>>- {
                $0.attribute = attribute
                return
            }
        }
    }
    
    //Dont try to understand
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Captures swipe action
    @objc dynamic func swipeHandler(_ gesture: UISwipeGestureRecognizer){
        print("SWIPED : \(gesture.direction)")
        delegate.gestureControlDidSwipe(gesture.direction)
    }
    
}
