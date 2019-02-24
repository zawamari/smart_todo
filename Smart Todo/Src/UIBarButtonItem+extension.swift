//
//  UIBarButtonItem+extension.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/30.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    enum HiddenItem: Int {
        case Arrow = 100
        case Back = 101
        case Forward = 102
        case Up = 103
        case Down = 104
    }
    
    convenience init(barButtonHiddenItem: HiddenItem, target: AnyObject?, action: Selector?) {
        let systemItem = UIBarButtonItem.SystemItem(rawValue: barButtonHiddenItem.rawValue)
        self.init(barButtonSystemItem: systemItem!, target: target, action: action)
    }
}
