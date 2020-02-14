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

    static func == (lhs: CCMainViewModelEvent, rhs: CCMainViewModelEvent) -> Bool {
        switch (lhs, rhs) {
        case (getCurrenciesData, getCurrenciesData):
            return true
        }
    }
}

protocol CCMainViewModelViewModelType {
    var uiEvents: PublishSubject<CCMainViewModelEvent> { get }
    var viewModelEvents: PublishSubject<CCMainViewModelEvent> { get }
}

final class CCMainViewModel: CCMainViewModelViewModelType {
    let uiEvents = PublishSubject<CCMainViewModelEvent>()
    let viewModelEvents = PublishSubject<CCMainViewModelEvent>()
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
            }
        }).disposed(by: disposeBag)
    }

    private func getCurrenciesData(_ group: CConstants.API.DataType) {
        service.getCurrencyData(group)
            .asObservable()
            .subscribe(onNext: { event in
                switch event {
                case .waiting: break
                case .failed(let error):
                    print("error = \(error)")
                case .succeeded(let response):
                    print("response = \(response)")
                }
            }).disposed(by: disposeBag)
    }
}
