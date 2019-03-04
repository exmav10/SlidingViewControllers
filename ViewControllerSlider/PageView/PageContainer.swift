//
//  PageViewContainer.swift
//  ViewControllerSlider
//
//  Created by Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu] on 28.02.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//

import Foundation
import UIKit

class PageContainer: UIView {
    var items: [PageViewItem]?
    let space: CGFloat // Space between items
    var currentIndex = 0
    
    fileprivate let itemRadius: CGFloat
    fileprivate let selectedItemRadius: CGFloat
    fileprivate let itemsCount: Int
    fileprivate let animationKey = "animationKey"
    
    init(radius: CGFloat, selectedRadius: CGFloat, space: CGFloat, itemsCount: Int, itemColor: (Int) -> UIColor) {
        self.itemsCount = itemsCount
        self.space = space
        self.itemRadius = radius
        self.selectedItemRadius = selectedRadius
        super.init(frame: CGRect.zero)
        items = createItems(itemsCount, radius: radius, selectedRadius: selectedRadius, itemColor: itemColor)
    }
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: public

extension PageContainer{
    func currentIndex(_ index: Int, duration: Double, animated _:Bool){
        guard let items = self.items, index != currentIndex else {return}
        //New current index turns to true
        animationItem(items[index], selected: true, duration: duration)
        let fillColor = index > currentIndex ? true : false
        //Old currentindex turns to false
        animationItem(items[currentIndex], selected: false, duration: duration, fillColor: fillColor)
        currentIndex = index
    }
}

//MARK: animations

extension PageContainer {
    fileprivate func animationItem(_ item: PageViewItem, selected: Bool, duration: Double, fillColor: Bool = false) {
        let toValue = selected ? selectedItemRadius * 2 : itemRadius * 2
        item.constraints.filter{$0.identifier == "animationKey"}.forEach{$0.constant = toValue}
        UIView.animate(withDuration: duration,delay: 0,options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        item.animationSelected(selected, duration: duration, fillColor: fillColor)
    }
}

//MARK: create

extension PageContainer{
    fileprivate func createItems(_ count: Int, radius: CGFloat, selectedRadius: CGFloat, itemColor: (Int) -> UIColor) -> [PageViewItem] {
        var items = [PageViewItem]()
        var tag = 1
        var item = createItem(radius, selectedRadius: selectedRadius, isSelected: true, itemColor: itemColor(tag - 1))
        item.tag = tag
        addConstraintsToView(item, radius: selectedRadius)
        items.append(item)
        
        for _ in 1 ..< count {
                tag += 1
                let nextItem = createItem(radius, selectedRadius: selectedRadius, itemColor: itemColor(tag - 1))
                addConstraintsToView(nextItem, leftItem: item, radius: radius)
                items.append(nextItem)
                item = nextItem
                item.tag = tag
        }
        
        return items
    }
    
    fileprivate func createItem(_ radius: CGFloat, selectedRadius: CGFloat, isSelected: Bool = false, itemColor: UIColor) -> PageViewItem {
        let item = Init(PageViewItem(radius: radius, itemColor: itemColor, selectedRadius: selectedRadius, isSelected: isSelected)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        addSubview(item)
        
        return item
    }
    
    //Configuration for the left most circle
    fileprivate func addConstraintsToView(_ item: UIView, radius: CGFloat) {
        [NSLayoutConstraint.Attribute.left, NSLayoutConstraint.Attribute.centerY].forEach { attribute in
            (self, item) >>>- { $0.attribute = attribute; return }
        }
        
        [NSLayoutConstraint.Attribute.width, NSLayoutConstraint.Attribute.height].forEach { attribute in
            item >>>- {
                $0.attribute = attribute
                $0.constant = radius * 2.0
                $0.identifier = animationKey
                return
            }
        }
    }
    
    //Configuration for other circles
    fileprivate func addConstraintsToView(_ item: UIView, leftItem: UIView, radius: CGFloat) {
        (self, item) >>>- { $0.attribute = .centerY; return }
        (self, item, leftItem) >>>- {
            $0.attribute = .leading
            $0.secondAttribute = .trailing
            $0.constant = space
            return
        }
        [NSLayoutConstraint.Attribute.width, NSLayoutConstraint.Attribute.height].forEach { attribute in
            item >>>- {
                $0.attribute = attribute
                $0.constant = radius * 2.0
                $0.identifier = animationKey
                return
            }
        }
    }
}
