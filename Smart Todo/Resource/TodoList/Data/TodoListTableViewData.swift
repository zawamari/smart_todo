//
//  TodoListTableViewData.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/12.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
final class TodoListTableViewData {
    private(set) var cellTypes: [TodoListCellType] = []
    
    func refresh(model: Int?) {
        cellTypes.removeAll()
        
        if let count = model {
            if count == 0 {
                cellTypes.append(.none)
                return
            }
            for _ in 0..<count {
                cellTypes.append(.todo)
            }
        } else {
            
        }
    }
}

extension TodoListTableViewData: TableDataSource {
    func sectionCount() -> Int {
        return 1
    }
    
    func rowCount(section: Int) -> Int {
        return cellTypes.count
    }
    
    func cellType(index: IndexPath) -> TodoListCellType {
        return cellTypes[index.row]
    }
}
