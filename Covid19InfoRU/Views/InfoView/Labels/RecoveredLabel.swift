//
//  RecoveredLabel.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import UIKit

class RecoveredLabel: InfoLabel {
    
    override var categoryName: String { "Recovered" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "Recovered: 0"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
