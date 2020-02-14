//
//  CCurrencyLayerTarget.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Moya

enum CCurrencyLayerTarget {
    case getCurrencyData(_ group: CConstants.API.DataType)
}

extension CCurrencyLayerTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .getCurrencyData:
            return URL(string: CConstants.API.url) ?? URL(string: "")!
        }
    }

    var path: String {
        switch self {
        case .getCurrencyData(let group):
            switch group {
            case .live:
                return CConstants.API.DataType.live.rawValue
            case .historical:
                return CConstants.API.DataType.historical.rawValue
            }
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .getCurrencyData(let group):
            return .requestParameters(parameters: getParameters(group),
                                      encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return nil
    }
}

extension CCurrencyLayerTarget {
    func getParameters(_ group: CConstants.API.DataType) -> [String: Any] {
        var params = [String: Any]()

        params[CConstants.APIParameters.accessKey] = CConstants.API.accessKey
        params[CConstants.APIParameters.currencies] = CConstants.API.currencyArr.joined(separator: ",")
        params[CConstants.APIParameters.format] = CConstants.API.Format.plain.rawValue

        switch group {
        case .historical:
            params[CConstants.APIParameters.date] = CCDateUtil().getStrNow()
        default: break
        }

        return params
    }
}
