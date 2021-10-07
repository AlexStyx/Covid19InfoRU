//
//  AboutLabel.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 10/6/21.
//

import UIKit

class AboutLabel: InfoLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "Main digits for today"
        font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
