//
//  CategoryCellType.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/12.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
import UIKit

enum CategoryCellType: TableDataType {
    case category
    case create
    
    func cacheKey() -> String {
        switch self {
        case .category:
            return "categoryCell"
        case .create:
            return "create"
        }
    }
    
    func estimatedHeight() -> CGFloat {
        switch self {
        case .category:
            return 44.0
        case .create:
            return 58.0
        }
    }
}
