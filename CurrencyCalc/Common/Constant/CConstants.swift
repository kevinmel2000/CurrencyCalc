// swiftlint:disable nesting
//
//  CConstants.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation

struct CConstants {
    struct Common {
        static let dateFormat = "YYYY-MM-dd"
    }
    struct API {
        static let accessKey = "f22339d3c9a04da3652d945a52f048f0"
        static let url = "http://api.currencylayer.com/"
        enum DataType: String {
            case live
            case historical
        }
        static let currencyArr = ["AUD", "CAD", "PLN", "MXN"]
        enum Format: Int {
            case plain = 0, prettyPrinted
        }
    }

    struct APIParameters {
        static let accessKey = "access_key"
        static let currencies = "currencies"
        static let format = "format"
        static let date = "date"
    }
}
