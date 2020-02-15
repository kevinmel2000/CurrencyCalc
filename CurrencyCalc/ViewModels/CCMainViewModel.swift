//
//  CCMainViewModel.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 13/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

enum CCMainViewModelEvent: Equatable {
    case getCurrenciesData(_ group: CConstants.API.DataType)
    case networkFailure
    case requestDataSuccess
    case requestDataFailure(_ error: CCServiceError?)

    static func == (lhs: CCMainViewModelEvent, rhs: CCMainViewModelEvent) -> Bool {
        switch (lhs, rhs) {
        case (getCurrenciesData, getCurrenciesData),
             (networkFailure, networkFailure),
             (requestDataSuccess, requestDataSuccess),
             (requestDataFailure, requestDataFailure):
            return true
        default: return false
        }
    }
}

protocol CCMainViewModelViewModelType {
    var uiEvents: PublishSubject<CCMainViewModelEvent> { get }
    var viewModelEvents: PublishSubject<CCMainViewModelEvent> { get }
    var currencyLayerResponse: CCurrencyLayerResponse? { get }
}

final class CCMainViewModel: CCMainViewModelViewModelType {
    let uiEvents = PublishSubject<CCMainViewModelEvent>()
    let viewModelEvents = PublishSubject<CCMainViewModelEvent>()
    var currencyLayerResponse: CCurrencyLayerResponse?

    private let disposeBag = DisposeBag()
    private let service = QCCurrencyLayerService()

    init() {
        setupEvents()
    }
}

// MARK: - Private Methods
extension CCMainViewModel {
    private func setupEvents() {
        viewModelEvents.subscribe(onNext: { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .getCurrenciesData(let group):
                self.getCurrenciesData(group)
            default: break
            }
        }).disposed(by: disposeBag)
    }

    private func getCurrenciesData(_ group: CConstants.API.DataType) {
        service.getCurrencyData(group)
            .asObservable()
            .subscribe(onNext: { [weak self] event in
                guard let `self` = self else { return }
                switch event {
                case .waiting: break
                case .failed(let error):
                    self.uiEvents.onNext(.requestDataFailure(error))
                case .succeeded(let response):
                    self.currencyLayerResponse = response
                    if response.error != nil {
                        self.uiEvents.onNext(.requestDataFailure(nil))
                    } else {
                        self.uiEvents.onNext(.requestDataSuccess)
                    }
                }
            }).disposed(by: disposeBag)
    }
}
