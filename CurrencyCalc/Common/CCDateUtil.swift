//
//  CCDateUtil.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation

struct CCDateUtil {
    func getStrNow() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = CConstants.Common.dateFormat
        return dateFormatter.string(from: Date())
    }
}
