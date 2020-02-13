//
//  CCNetworkEvent.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum CCNetworkEvent<ResponseType> {
    case waiting
    case succeeded(ResponseType)
    case failed(CCServiceError)
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func parseResponse<T>(_ parse: @escaping (String) throws -> T) -> Observable<CCNetworkEvent<T>> {
        return parseResponse({ (response: Response) in
            let responseString = String(data: response.data, encoding: String.Encoding.utf8)!

            return try parse(responseString)
        })
    }

    func parseDataResponse<T>(_ parse: @escaping (Data) throws -> T) -> Observable<CCNetworkEvent<T>> {
        return parseResponse({ (response: Response) in
            return try parse(response.data)
        })
    }

    func parseResponse<T>(_ parse: @escaping (Response) throws -> T) -> Observable<CCNetworkEvent<T>> {
        return self
            .map { response -> CCNetworkEvent<T> in
                if response.is2xx() {
                    do {
                        return try .succeeded(parse(response))
                    } catch let error {
                        var serviceError = CCServiceError()
                        serviceError.responseString = error.localizedDescription

                        return .failed(serviceError)
                    }
                } else {
                    guard let responseString = String(data: response.data, encoding: String.Encoding.utf8) else {
                        return .failed(CCServiceError())
                    }

                    var serviceError = CCServiceError()
                    serviceError.status = .failure
                    serviceError.responseString = responseString

                    return .failed(serviceError)
                }
            }
            .asObservable()
            .startWith(.waiting)
    }
}

extension Observable where Element == CCNetworkEvent<Any> {
    func mapFailures<T>(_ failure: @escaping (CCServiceError) -> CCNetworkEvent<T>) -> Observable<CCNetworkEvent<T>> {
        return self
            .map { event -> CCNetworkEvent<T> in
                switch event {
                case .succeeded(let val):
                    guard let tval = val as? T else {
                        let serviceError = CCServiceError()
                        return .failed(serviceError)
                    }

                    return .succeeded(tval)

                case .waiting:
                    return .waiting

                case .failed(let error):
                    return failure(error)
                }
            }
    }
}

extension CCNetworkEvent: Equatable {
    public static func == (lhs: CCNetworkEvent, rhs: CCNetworkEvent) -> Bool {
        switch (lhs, rhs) {
        case (.waiting, .waiting):
            return true

        case (.succeeded, .succeeded):
            return true

        case (.failed(let errorLHS), .failed(let errorRHS)):
            return errorLHS == errorRHS

        default:
            return false
        }
    }
}
