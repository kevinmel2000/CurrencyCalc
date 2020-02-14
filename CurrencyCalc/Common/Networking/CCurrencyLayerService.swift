//
//  CCurrencyLayerService.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import RxSwift
import Moya

protocol HQCCurrencyLayerType {
    func getCurrencyData(_ group: CConstants.API.DataType) -> Observable<CCNetworkEvent<CCurrencyLayerResponse>>
}

struct QCCurrencyLayerService: HQCCurrencyLayerType {
    private let provider: MoyaProvider<CCurrencyLayerTarget>

    init() {
        provider = HQMoyaProvider<CCurrencyLayerTarget>()
    }

    init(provider: HQMoyaProvider<CCurrencyLayerTarget>) {
        self.provider = provider
    }

    func getCurrencyData(_ group: CConstants.API.DataType) -> Observable<CCNetworkEvent<CCurrencyLayerResponse>> {
        return provider.rx.request(.getCurrencyData(group))
            .parseResponse({ (responseString: String) in
                guard var response = CCurrencyLayerResponse.deserialize(from: responseString) else {
                    return CCurrencyLayerResponse()
                }

                response.status = .success
                response.responseString = responseString

                return response
            })
            .mapFailures { error in
                return .failed(error)
            }
    }
}
