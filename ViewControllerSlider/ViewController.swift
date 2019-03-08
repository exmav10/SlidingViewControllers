//
//  ViewController.swift
//  ViewControllerSlider
//
//  Created by Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu] on 28.02.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    fileprivate let items = [
        OnboardingItemInfo(storyBoardID: "firstVC",title: "First Page", backgroundColor: .appleBlue1),
        OnboardingItemInfo(storyBoardID: "secondVC", title: "Second Page", backgroundColor: .appleYellow),
        OnboardingItemInfo(storyBoardID: "thirdVC", title: "Second Page", backgroundColor: .applePink),
    ]
    
    
    fileprivate var currentIndex: Int = 0 // Index of selected viewcontroller.
    
    fileprivate let pageViewBottomConstant: CGFloat = 32
    fileprivate let pageViewSelectedRadius: CGFloat = 16
    fileprivate let pageViewRadius: CGFloat = 8
    
    fileprivate var fillAnimationView: FillAnimationView?
    fileprivate var currentViewController = UIViewController()
    fileprivate var pageView: PageView?
    fileprivate var gestureControl: GestureControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        // FillAnimation - ViewController - PageView - Gesture Control
        fillAnimationView = FillAnimationView.animationViewOnView(self.view, color: items[0].backgroundColor)
        self.addChildViewController(viewControllerID: items[0].storyBoardID)
        pageView = createPageView()
        gestureControl = GestureControl(view: self.view, delegate: self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .clear
    }
    
    @objc fileprivate func tapAction(_ sender: UITapGestureRecognizer) {
        guard
            let pageView = self.pageView,
            let pageContainer = pageView.pageContainer
            else { return }
        let touchLocation = sender.location(in: self.view)
        let convertedLocation = pageContainer.convert(touchLocation, from: self.view)
        guard let pageItem = pageView.hitTest(convertedLocation, with: nil) else { return }
        let index = pageItem.tag - 1
        guard index != currentIndex else { return }
        currentIndex(index, animated: true)
    }
    
    func currentIndex(_ index: Int, animated: Bool){
        if 0 ..< items.count ~= index { //Checks if index is between 0 and itemsCount
            //(delegate as? PaperOnboardingDelegate)?.onboardingWillTransitonToIndex(index)
            currentIndex = index
            print("CURRENT INDEX: \(currentIndex)")
            if let position = pageView!.positionItemIndex(index, onView: self.view){
                fillAnimationView?.fillAnimation(items[index].backgroundColor, centerPosition: position, duration: 0.5)
            }
            pageView?.currentIndex(index, animated: animated)
            itemChanged(newStoryboardID: items[index].storyBoardID)
        }
    }
    
    fileprivate func createPageView() -> PageView {
        let pageView = PageView.pageViewOnView(
            self.view,
            itemsCount: items.count,
            bottomConstraint: pageViewBottomConstant * -1,
            radius: pageViewRadius,
            selectedRadius: pageViewSelectedRadius,
            itemColor: { _ in UIColor.red
        })
        pageView.configuration = { [weak self] item, index in
            //item.imageView?.image = self?.itemsInfo?[index].pageIcon
            //item.backgroundColor = self?.itemsInfo?[index].backgroundColor
        }
        return pageView
    }

    func itemChanged(newStoryboardID: String) {
        //Removing old viewcontroller
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.addChildViewController(viewControllerID: newStoryboardID)
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.currentViewController.view.removeFromSuperview()
        }
        CATransaction.commit()
        CATransaction.commit()
    }
    
    private func addChildViewController(viewControllerID: String){
        currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerID)
        self.addChild(currentViewController)
        currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        currentViewController.view.backgroundColor = .clear
        self.view.addSubview(currentViewController.view)
        NSLayoutConstraint.activate([
            currentViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            currentViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            currentViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            currentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)])
        currentViewController.didMove(toParent: self)
    }
    
    fileprivate func backgroundColor(_ index: Int) -> UIColor {
        return items[index].backgroundColor
    }
    
}

// MARK: GestureControlDelegate
extension ViewController: GestureControlDelegate {
    
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
