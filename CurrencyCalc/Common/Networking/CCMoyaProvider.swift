//
//  CCMoyaProvider.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import Moya

class CCMoyaProvider<T>: MoyaProvider<T> where T: TargetType {
    override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
                  requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                  stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = MoyaProvider<T>.defaultAlamofireManager(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        var appendedPlugins = plugins
        let networkLogEnabled = true
        let showNetworkResponse = false
        let cURLEnabled = true

        if _isDebugAssertConfiguration() && networkLogEnabled {
            appendedPlugins.append(NetworkLoggerPlugin(verbose: showNetworkResponse, cURL: cURLEnabled))
        }

        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   manager: manager,
                   plugins: appendedPlugins,
                   trackInflights: trackInflights)
    }
}
