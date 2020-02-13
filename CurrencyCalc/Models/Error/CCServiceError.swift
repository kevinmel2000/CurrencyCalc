//
//  CCServiceError.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import HandyJSON
import Moya

enum CCResponseStatus: String {
    case success
    case failure
}

struct CCServiceError: HandyJSON {
    var responseString: String?
    var status: CCResponseStatus
    var error: MoyaError?

    init() {
        status = .failure
        error = nil
        responseString = nil
    }
}

extension CCServiceError: Equatable {
    public static func == (lhs: CCServiceError, rhs: CCServiceError) -> Bool {
        return lhs.responseString == rhs.responseString &&
            lhs.status == rhs.status
    }
}
