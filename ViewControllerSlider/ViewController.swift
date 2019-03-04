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
        OnboardingItemInfo(storyBoardID: "FirstVC",title: "First Page", backgroundColor: .appleBlue1),
        OnboardingItemInfo(storyBoardID: "SecondVC", title: "Second Page", backgroundColor: .appleYellow),
        OnboardingItemInfo(storyBoardID: "SecondVC", title: "Second Page", backgroundColor: .applePink),
        OnboardingItemInfo(storyBoardID: "SecondVC", title: "Second Page", backgroundColor: .applePurple)
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPaperOnboardingView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .appleRed
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
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
    }
    
}


// MARK: PaperOnboardingDataSource
extension ViewController: PaperOnboardingDataSource {
    
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
