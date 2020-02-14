//
//  Extension+UILabel.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setup(with customData: UISetupModel?) {
        guard let customData = customData else { return }
        text = customData.text
        font = customData.font ?? UIFont.systemFont(ofSize: 32)
        textAlignment = customData.textAlignment ?? .left
        textColor = customData.textColor ?? .black
        if let chp = customData.contentHuggingPrio {
            setContentHuggingPriority(chp.prio, for: chp.axis)
        }
    }
}
