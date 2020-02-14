//
//  UISetupModel.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import UIKit

struct UISetupModel {
    var text: String?
    var textColor: UIColor?
    var placeholderText: String?
    var font: UIFont?
    var contentHuggingPrio: ContentHuggingPrio?
    var keyboardType: UIKeyboardType?
    var textAlignment: NSTextAlignment?
}

struct ContentHuggingPrio {
    var prio: UILayoutPriority
    var axis: NSLayoutConstraint.Axis
}
