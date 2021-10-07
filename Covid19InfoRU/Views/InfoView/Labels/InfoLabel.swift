//
//  InfoLabel.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import UIKit

class InfoLabel: UILabel {
    
    var categoryName: String { "" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        textColor = .black
        font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(value: Int) {
        if value >= 0 {
            text = "\(categoryName): \(value)"
        } else {
            fatalError("\(categoryName) number less than zero")
        }
    }
}
