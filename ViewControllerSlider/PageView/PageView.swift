//
//  PageView.swift
//  ViewControllerSlider
//
//  Created by Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu] on 28.02.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//  Credit to: https://github.com/Ramotion/paper-onboarding

import Foundation
import UIKit


//INITILIAZING
class PageView: UIView {
    
    var itemsCount = 3
    var itemRadius: CGFloat = 8.0
    var selectedItemRadius: CGFloat  = 22.0
    var duration: Double = 0.7
    var space: CGFloat = 20 // Space between lines
    var itemColor: (Int) -> UIColor
    
    // configure items set image or chage color for border view
    var configuration: ((_ item: PageViewItem, _ index: Int) -> Void)? {
        didSet {
            configurePageItems(pageContainer?.items)
        }
    }
    
    fileprivate var containerX: NSLayoutConstraint?
    var pageContainer: PageContainer?
    
    init(frame: CGRect, itemsCount: Int, radius: CGFloat, selectedRadius: CGFloat, itemColor: @escaping(Int) -> UIColor){
        self.itemsCount = itemsCount
        itemRadius = radius
        selectedItemRadius = selectedRadius
        self.itemColor = itemColor
        super.init(frame: frame)
        pageContainer = createContainerView()
        currentIndex(0, animated: false)
        backgroundColor = .clear
    }
    
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func hitTest(_ point: CGPoint, with _: UIEvent?) -> UIView? {
        guard let containerView = self.pageContainer, let items = containerView.items else {return nil}
        for item in items {
            let frame = item.frame.insetBy(dx: -10, dy: -10)
            guard frame.contains(point) else {continue}
            return item
        }
        return nil
    }
}


//MARK: public

//This is where we create a new pageview
extension PageView{
    class func pageViewOnView(_ view: UIView, itemsCount: Int, bottomConstraint: CGFloat, radius: CGFloat, selectedRadius: CGFloat, itemColor: @escaping (Int) -> UIColor) -> PageView {
        let pageView = PageView(frame: CGRect.zero, itemsCount: itemsCount, radius: radius, selectedRadius: selectedRadius, itemColor: itemColor)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.alpha = 0.4
        view.addSubview(pageView)
        
        let layoutAttribs:[(NSLayoutConstraint.Attribute, Int)] =  [(NSLayoutConstraint.Attribute.left, 0), (NSLayoutConstraint.Attribute.right, 0), (NSLayoutConstraint.Attribute.bottom, Int(bottomConstraint))]
        
        // add constraints
        for (attribute, const) in layoutAttribs {
            (view, pageView) >>>- {
                $0.constant = CGFloat(const)
                $0.attribute = attribute
                return
            }
        }
        pageView >>>- {
            $0.attribute = .height
            $0.constant = 30
            return
        }
        
        return pageView
    }
    
    func currentIndex(_ index: Int, animated: Bool) {
        pageContainer?.currentIndex(index, duration: duration * 0.5, animated: animated)
        moveContainerTo(index, animated: animated, duration: duration)
    }
    
    func positionItemIndex(_ index: Int, onView: UIView) -> CGPoint? {
        if let currentItem = pageContainer?.items?[index].centerView {
            let pos = currentItem.convert(currentItem.center, to: onView)
            return pos
        }
        return nil
    }
    
}

// MARK: create

extension PageView {
    fileprivate func createContainerView() -> PageContainer {
        let pageControl = PageContainer(radius: itemRadius,
                                         selectedRadius: selectedItemRadius,
                                         space: space,
                                         itemsCount: itemsCount,
                                         itemColor: itemColor)
        let container = Init(pageControl) {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(container)
        
        // add constraints
        for attribute in [NSLayoutConstraint.Attribute.top, NSLayoutConstraint.Attribute.bottom] {
            (self, container) >>>- { $0.attribute = attribute; return }
        }
        
        containerX = (self, container) >>>- { $0.attribute = .centerX; return }
        
        container >>>- {
            $0.attribute = .width
            $0.constant = selectedItemRadius * 2 + CGFloat(itemsCount - 1) * (itemRadius * 2) + space * CGFloat(itemsCount - 1)
            return
        }
        return container
    }
    
    fileprivate func configurePageItems(_ items: [PageViewItem]?) {
        guard let items = items else {
            return
        }
        for index in 0 ..< items.count {
            configuration?(items[index], index)
        }
    }
}

// MARK: animation
extension PageView {
    fileprivate func moveContainerTo(_ index: Int, animated:Bool = true, duration: Double = 0){
        guard let containerX = self.containerX else {
            return
        }
        let containerWidth = CGFloat(itemsCount + 1) * selectedItemRadius + space * CGFloat(itemsCount - 1)
        let toValue = containerWidth / 2.0 - selectedItemRadius - (selectedItemRadius + space) * CGFloat(index)
        containerX.constant = toValue
        
        if animated == true {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: UIView.AnimationOptions(),
                           animations: {
                            self.layoutIfNeeded()
            },
                           completion: nil)
        } else {
            layoutIfNeeded()
        }
    }
}
