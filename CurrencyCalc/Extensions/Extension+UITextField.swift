//
//  Extension+UITextField.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setup(with custom: UISetupModel?) {
        guard let custom = custom else { return }
        backgroundColor = .lightGray
        borderStyle = .bezel
        textAlignment = custom.textAlignment ?? .left
        keyboardType = custom.keyboardType ?? .default
        placeholder = custom.placeholderText
        font = .systemFont(ofSize: 32)
        if let chp = custom.contentHuggingPrio {
            setContentHuggingPriority(chp.prio, for: chp.axis)
        }
    }
}
