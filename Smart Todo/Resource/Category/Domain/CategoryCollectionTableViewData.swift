//
//  CategoryCollectionTableViewData.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/12.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation

final class CategoryCollectionTableViewData {
    private(set) var cellTypes: [CategoryCellType] = []
    
    func refresh(model: Int?) {
        cellTypes.removeAll()
        
        if let count = model {
            for _ in 0..<count {
                cellTypes.append(.category)
            }
        } else {
            cellTypes.append(.category)
        }

        cellTypes.append(.create)
    }
}

extension CategoryCollectionTableViewData: TableDataSource {
    func sectionCount() -> Int {
        return 1
    }
    
    func rowCount(section: Int) -> Int {
        return cellTypes.count
    }
    
    func cellType(index: IndexPath) -> CategoryCellType {
        return cellTypes[index.row]
    }
}
