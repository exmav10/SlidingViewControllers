//
//  PaperOnboarding.swift
//  ViewControllerSlider
//
//  Created by Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu] on 28.02.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//

import Foundation
import UIKit

public struct OnboardingItemInfo {
    public let title: String
    public let backgroundColor: UIColor
    public let storyBoardID: String
    public init (storyBoardID: String, title: String, backgroundColor: UIColor) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.storyBoardID = storyBoardID
    }
}

open class PaperOnboarding: UIView { //Burasi degisebilir
    
    ///  The object that acts as the data source of the  PaperOnboardingDataSource.
    @IBOutlet weak open var dataSource: AnyObject? {
        didSet {
            commonInit()
        }
    }
    
    /// The object that acts as the delegate of the PaperOnboarding. PaperOnboardingDelegate protocol
    @IBOutlet weak open var delegate: AnyObject?
    
    open fileprivate(set) var currentIndex: Int = 0
    fileprivate(set) var itemsCount: Int = 0
    
    fileprivate var itemsInfo: [OnboardingItemInfo]?
    
    //Şuanlık gereksiz
    fileprivate let pageViewBottomConstant: CGFloat
    fileprivate var pageViewSelectedRadius: CGFloat = 22
    fileprivate var pageViewRadius: CGFloat = 8
    
//    fileprivate var fillAnimationView: FillAnimationView?
    fileprivate var pageView: PageView?
    fileprivate var gestureControl: GestureControl?
//    fileprivate var contentView: OnboardingContentView?
    
    public init(pageViewBottomConstant: CGFloat = 32) {
        self.pageViewBottomConstant = pageViewBottomConstant
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.pageViewBottomConstant = 32
        self.pageViewSelectedRadius = 22
        self.pageViewRadius = 8
        super.init(coder: aDecoder)
    }
    
    /**
     Scrolls through the PaperOnboarding until a index is at a particular location on the screen.
     - parameter index:    Scrolling to a current index item.
     - parameter animated: True if you want to animate the change in position; false if it should be immediate.
     */
    //SELECTED ITEM IS CHANGED
    func currentIndex(_ index: Int, animated: Bool) {
        if 0 ..< itemsCount ~= index {  //Checks if index is between 0 and itemsCount
            (delegate as? PaperOnboardingDelegate)?.onboardingWillTransitonToIndex(index)
            currentIndex = index
            print("CURRENT INDEX: \(currentIndex)")
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                (self.delegate as? PaperOnboardingDelegate)?.onboardingDidTransitonToIndex(index)
            })
            if let position = pageView?.positionItemIndex(index, onView: self) {
//                fillAnimationView?.fillAnimation(backgroundColor(currentIndex), centerPosition: postion, duration: 0.5)
            }
            pageView?.currentIndex(index, animated: animated)
            if let selectedItem = itemsInfo?[index] {
                changeCurrentController(controllerIdentifier: selectedItem.storyBoardID)
            }
//            contentView?.currentItem(index, animated: animated)
            CATransaction.commit()
        } else if index >= itemsCount {
            (delegate as? PaperOnboardingDelegate)?.onboardingWillTransitonToLeaving()
        }
    }
    
    func changeCurrentController(controllerIdentifier: String){
        if case let dataSource as PaperOnboardingDataSource = dataSource {
            dataSource.onboardingPageItemChanged(newStoryboardID: "firstVC", oldStoryboardID: "secondVC")
        }
    }
    
    
    func commonInit(){
        if case let dataSource as PaperOnboardingDataSource = dataSource {
            itemsCount = dataSource.onboardingItemsCount()
        }
        if case let dataSource as PaperOnboardingDataSource = dataSource {
            pageViewRadius = dataSource.onboardinPageItemRadius()
        }
        if case let dataSource as PaperOnboardingDataSource = dataSource {
            pageViewSelectedRadius = dataSource.onboardingPageItemSelectedRadius()
        }
        
        itemsInfo = createItemsInfo()
        translatesAutoresizingMaskIntoConstraints = false
//        fillAnimationView = FillAnimationView.animationViewOnView(self, color: backgroundColor(currentIndex))
//        contentView = OnboardingContentView.contentViewOnView(self,
//                                                              delegate: self,
//                                                              itemsCount: itemsCount,
//                                                              bottomConstant: pageViewBottomConstant * -1 - pageViewSelectedRadius)
        pageView = createPageView()
        gestureControl = GestureControl(view: self, delegate: self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func tapAction(_ sender: UITapGestureRecognizer) {
        guard
            (delegate as? PaperOnboardingDelegate)?.enableTapsOnPageControl == true,
            let pageView = self.pageView,
            let pageContainer = pageView.pageContainer
            else { return }
        let touchLocation = sender.location(in: self)
        let convertedLocation = pageContainer.convert(touchLocation, from: self)
        guard let pageItem = pageView.hitTest(convertedLocation, with: nil) else { return }
        let index = pageItem.tag - 1
        guard index != currentIndex else { return }
        currentIndex(index, animated: true)
        (delegate as? PaperOnboardingDelegate)?.onboardingWillTransitonToIndex(index)
    }
    
    fileprivate func createPageView() -> PageView {
        let pageView = PageView.pageViewOnView(
            self,
            itemsCount: itemsCount,
            bottomConstraint: pageViewBottomConstant * -1,
            radius: pageViewRadius,
            selectedRadius: pageViewSelectedRadius,
            itemColor: { [weak self] in
                guard let dataSource = self?.dataSource as? PaperOnboardingDataSource else { return .white }
                return dataSource.onboardingPageItemColor(at: $0)
        })

        pageView.configuration = { [weak self] item, index in
            //item.imageView?.image = self?.itemsInfo?[index].pageIcon
            //item.backgroundColor = self?.itemsInfo?[index].backgroundColor
        }

        return pageView
    }
    
    //Creates new items array.
    fileprivate func createItemsInfo() -> [OnboardingItemInfo] {
        guard case let dataSource as PaperOnboardingDataSource = self.dataSource else {
            fatalError("set dataSource")
        }
        
        var items = [OnboardingItemInfo]()
        for index in 0 ..< itemsCount {
            let info = dataSource.onboardingItem(at: index)
            items.append(info)
        }
        return items
    }
    
  
    
}
// MARK: helpers
extension PaperOnboarding {
    fileprivate func backgroundColor(_ index: Int) -> UIColor {
        guard let color = itemsInfo?[index].backgroundColor else {
            return .appleGreen
        }
        return color
    }
}

// MARK: GestureControlDelegate
extension PaperOnboarding: GestureControlDelegate {
    
    func gestureControlDidSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case UISwipeGestureRecognizer.Direction.right:
            currentIndex(currentIndex - 1, animated: true)
        case UISwipeGestureRecognizer.Direction.left:
            currentIndex(currentIndex + 1, animated: true)
        default:
            fatalError()
        }
    }
}


//// MARK: OnboardingDelegate
//extension PaperOnboarding: OnboardingContentViewDelegate {
//
//    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo? {
//        return itemsInfo?[index]
//    }
//
//    @objc func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
//        (delegate as? PaperOnboardingDelegate)?.onboardingConfigurationItem(item, index: index)
//    }
//}
