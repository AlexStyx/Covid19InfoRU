//
//  ChartViewViewModel.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/28/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChartViewViewModelType {
    var items: PublishSubject<[Int]> { get }
    var statuses: PublishSubject<[Status]> { get}
    var period: Period { get set }
    var category: TypeOfChart { get set }
    var publishedCategory: TypeOfChart? { get set }
    mutating func update(period: Period)
    mutating func setup(statisctics: Statistics, period: Period)
}

struct ChartViewViewModel: ChartViewViewModelType {
    
    private(set) var statistics: Statistics = Statistics(allTimeStatistics: [])
    
    var period: Period = .week {
        willSet(newPeriod) {
            updateStatuses(for: newPeriod, with: category)
        }
    }
    
    var category: TypeOfChart = .confirmed {
        willSet(newCategory) {
            updateStatuses(for: period, with: newCategory)
            publishedCategory = newCategory
        }
    }
    
    var publishedCategory: TypeOfChart?
    
    public var statuses = PublishSubject<[Status]>()
    public var items = PublishSubject<[Int]>()
    
    public mutating func setup(statisctics: Statistics, period: Period) {
        self.statistics = statisctics
        self.period = period
        
    }
    
    public mutating func update(period: Period) {
        self.period = period
    }
    
    public mutating func update(category: TypeOfChart) {
        self.category = category
    }
    
    private mutating func updateStatuses(for period: Period, with category: TypeOfChart) {
        switch (period, category) {
        case (.week, .confirmed): items.onNext(statistics.weekStatistics.map{$0.confirmed})
        case (.week, .deaths): items.onNext(statistics.weekStatistics.map{$0.deaths})
        case (.week, .recovered): items.onNext(statistics.weekStatistics.filter{$0.recovered != 0}.map{$0.recovered})
        case (.month, .confirmed): items.onNext(statistics.monthStatistics.map{$0.confirmed})
        case (.month, .deaths): items.onNext(statistics.monthStatistics.map{$0.deaths})
        case (.month, .recovered): items.onNext(statistics.monthStatistics.filter{$0.recovered != 0}.map{$0.recovered})
        case (.allTime, .confirmed): items.onNext(statistics.allTimeStatistics.map{$0.confirmed})
        case (.allTime, .deaths): items.onNext(statistics.allTimeStatistics.map{$0.deaths})
        case (.allTime, .recovered): items.onNext(statistics.allTimeStatistics.filter{$0.recovered != 0}.map{$0.recovered})
        }
    }
}

enum Period: String, CaseIterable {
    case week
    case month
    case allTime
}

enum TypeOfChart: String, CaseIterable {
    case confirmed
    case deaths
    case recovered
}
