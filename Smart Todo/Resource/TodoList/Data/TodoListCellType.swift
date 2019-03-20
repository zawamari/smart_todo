//
//  TodoListCellType.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/12.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
import UIKit

enum TodoListCellType: TableDataType {
    
    case todo
    case create
    case none
    
    func cacheKey() -> String {
        switch self {
        case .todo:
            return "todoListItem"
        case .create:
            return "create"
        case .none:
            return "none"
        }
    }
    func estimatedHeight() -> CGFloat {
        switch self {
        case .todo:
            return 44.0
        case .create:
            return 44.0
        case .none:
            return 44.0
        }
    }
}
