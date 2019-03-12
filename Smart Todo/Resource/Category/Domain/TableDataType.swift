//
//  TableDataType.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/12.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
import UIKit

protocol TableDataType {
    func cacheKey() -> String
    func estimatedHeight() -> CGFloat
}
