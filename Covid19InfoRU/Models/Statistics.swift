//
//  Status.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import Foundation


struct Statistics {
    
    init(allTimeStatistics: [Status]) {
        self.allTimeStatistics = allTimeStatistics
        for index in allTimeStatistics.indices.reversed() {
            let status = allTimeStatistics[index]
            if index > allTimeStatistics.count - 1 - 30 {
                monthStatistics.append(status)
                if index > allTimeStatistics.count - 1 - 7 {
                    weekStatistics.append(status)
                }
            }
        }
        self.weekStatistics.reverse()
        self.monthStatistics.reverse()
        updatePeriodicValues()
    }
    
    public var confirmed = 0
    public var deaths = 0
    public var recovered = 0
    
    private(set) var allTimeStatistics = [Status]()
    private(set) var monthStatistics = [Status]()
    private(set) var weekStatistics = [Status]()
    
    private mutating func updatePeriodicValues() {
        confirmed = allTimeStatistics.filter{$0.confirmed != 0}.last?.confirmed ?? 0
        deaths = allTimeStatistics.filter{$0.deaths != 0}.last?.deaths ?? 0
        recovered = allTimeStatistics.filter{$0.recovered != 0}.last?.recovered ?? 0
    }
}

struct Status {
    let confirmed: Int
    let deaths: Int
    let recovered: Int
    let date: Date?
}
