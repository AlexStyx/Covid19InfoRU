//
//  TestData.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/28/21.
//

import Foundation


func generateTestData() -> Statistics {
    var statuses = [Status]()
    var date = Date()
    for _ in 1...365 {
        let confirmed = Int.random(in: 1...5)
        let deatsh = Int.random(in: 1...5)
        let recovered = Int.random(in: 1...5)
        let status = Status(confirmed: confirmed, deaths: deatsh, recovered: recovered, date: date)
        statuses.append(status)
        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    let statistics = Statistics(allTimeStatistics: statuses)
    return statistics
}
