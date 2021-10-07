//
//  DeathsLabel.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import UIKit

class DeathsLabel: InfoLabel {
    
    override var categoryName: String { "Deaths" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "Deaths: 0"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
