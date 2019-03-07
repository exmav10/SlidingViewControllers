//
//  ViewController.swift
//  ViewControllerSlider
//
//  Created by Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu] on 28.02.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PaperOnboardingDelegate {


    fileprivate let items = [
        OnboardingItemInfo(storyBoardID: "firstVC",title: "First Page", backgroundColor: .appleBlue1),
        OnboardingItemInfo(storyBoardID: "secondVC", title: "Second Page", backgroundColor: .appleYellow),
        OnboardingItemInfo(storyBoardID: "thirdVC", title: "Second Page", backgroundColor: .applePink),
    ]
    
    fileprivate var currentViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPaperOnboardingView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .appleRed
    }
    
    let onboarding = PaperOnboarding()
    private func setupPaperOnboardingView() {
        
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(onboarding)
        addChildViewController(viewControllerID: items[0].storyBoardID)
        // Add constraints
       
        
        
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
        currentViewController.view.addSubview(onboarding)
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        currentViewController.didMove(toParent: self)
    }
    
}


// MARK: PaperOnboardingDataSource
extension ViewController: PaperOnboardingDataSource {
    
    func onboardingPageItemChanged(newStoryboardID: String) {
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
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
    
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
    
}
