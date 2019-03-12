//
//  TableDataSource.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/12.
//  Copyright © 2019 Marie. All rights reserved.
//

import Foundation
protocol TableDataSource {
    associatedtype CellType: TableDataType
    
    func sectionCount() -> Int
    func rowCount(section: Int) -> Int
    func cellType(index: IndexPath) -> CellType
}
