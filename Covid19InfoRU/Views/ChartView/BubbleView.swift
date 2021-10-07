//
//  BubbleView.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 10/6/21.
//

import UIKit

class BubbleView: UIView {
    
    var period: Period? {
        willSet(newPeriod) {
            if let newPeriod = newPeriod {
                switch newPeriod {
                case .week: items = daysOfTheWeek
                case .month: items = daysOfTheMonth
                case .allTime: items = months
                }
                setNeedsDisplay();
                setNeedsLayout();
            }
        }
    }
    
    private var daysOfTheWeek = [String]()
    private var daysOfTheMonth = [String]()
    private var months = [String]()
    private var items = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        calculateValues()
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        for view in subviews {
            view.removeFromSuperview()
        }
        setupUI()
    }
    
    private func calculateValues() {
        let now = Date()
        let components = Calendar.current.dateComponents([.month, .weekday], from: now)
        guard
            let month = components.month,
            let weekday = components.weekday
        else { return }
        for index in (12 - abs(month - 12))..<12{
            months.append(DateFormatter().monthSymbols[index])
        }
        for index in 0..<month {
            months.append(DateFormatter().monthSymbols[index])
        }
        for index in (7 - abs(weekday - 7))..<7 {
            daysOfTheWeek.append(DateFormatter().weekdaySymbols[index])
        }
        for index in 0..<weekday {
            daysOfTheWeek.append(DateFormatter().weekdaySymbols[index])
        }
        for day in 1...30 {
            if day % 5 == 0 || day == 1 {
                daysOfTheMonth.append(String(day))
            }
        }
        items = daysOfTheWeek
    }
    
    private func setupUI() {
        var xPosition: CGFloat = 0
        for text in items {
            let label = UILabel(frame: CGRect(origin: CGPoint(x: xPosition, y: 0), size: CGSize(width: bounds.width/CGFloat(items.count), height: bounds.height)))
            label.text = String(text.prefix(3)).uppercased()
            label.font = UIFont.preferredFont(forTextStyle: .footnote).withSize(10)
            label.textAlignment = .center
            addSubview(label)
            xPosition += bounds.width/CGFloat(items.count)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
