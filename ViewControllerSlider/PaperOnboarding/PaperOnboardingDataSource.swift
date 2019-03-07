//
//  PaperOnboardingDataSource.swift
//  ViewControllerSlider
//
//  Created by Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu] on 28.02.2019.
//  Copyright © 2019 Aydin Unal [Uygulama Gelistirme - Mobil Bankacilik Uygulamalari Bolumu]. All rights reserved.
//

import Foundation
import UIKit

/**
 *  The PaperOnboardingDataSource protocol is adopted by an object that mediates the application’s data model for a PaperOnboarding object.
 The data source information it needs to construct and modify a PaperOnboarding.
 */
public protocol PaperOnboardingDataSource {
    
    /**
     Asks the data source to return the number of items.
     
     - parameter index: An index of item in PaperOnboarding.
     - returns: The number of items in PaperOnboarding.
     */
    func onboardingItemsCount() -> Int
    
    /**
     Asks the data source for configureation item.
     
     - parameter index: An index of item in PaperOnboarding.
     - returns: configuration info for item
     */
    func onboardingItem(at index: Int) -> OnboardingItemInfo
    
    /**
     Asks the color for PageView item
     
     - parameter index: An index of item in PaperOnboarding.
     - returns: color PageView Item
     */
    func onboardingPageItemColor(at index: Int) -> UIColor
    
    /// Asks for the radius of the PageView item
    ///
    /// - Returns: radius of the PageView Item
    func onboardinPageItemRadius() -> CGFloat
    
    /// Asks for the selected state radius of the PageView item
    ///
    /// - Returns: selected state radius of the PageView Item
    func onboardingPageItemSelectedRadius() -> CGFloat
    
    func onboardingPageItemChanged(newStoryboardID: String)
}

public extension PaperOnboardingDataSource {
    
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return .white
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return 8
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 22
    }
    
}
