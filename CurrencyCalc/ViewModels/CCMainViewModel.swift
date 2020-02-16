//
//  CCMainViewModel.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 13/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxOptional
import CoreData

enum CCMainViewModelEvent: Equatable {
    case getCurrenciesData(_ group: CConstants.API.DataType)
    case networkFailure
    case requestDataSuccess
    case requestDataFailure(_ error: CCServiceError?)
    case calculateExchangeCurrency(_ value: Float, _ exchange: String)
    case resultCalculation(_ result: Float)

    static func == (lhs: CCMainViewModelEvent, rhs: CCMainViewModelEvent) -> Bool {
        switch (lhs, rhs) {
        case (getCurrenciesData, getCurrenciesData),
             (networkFailure, networkFailure),
             (requestDataSuccess, requestDataSuccess),
             (requestDataFailure, requestDataFailure),
             (calculateExchangeCurrency, calculateExchangeCurrency):
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
    var currencyLayerResponse: CCurrencyLayerResponse? {
        didSet {
            saveToCoreData()
        }
    }

    private let disposeBag = DisposeBag()
    private let service = QCCurrencyLayerService()
    private var coreDataObjects: [NSManagedObject]?

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
            case let .calculateExchangeCurrency(value, exchange):
                self.calculateExchangeCurrency(value, exchange: exchange)
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

    private func calculateExchangeCurrency(_ value: Float, exchange: String) {
        guard let currencyResponse = currencyLayerResponse,
            let quote = currencyResponse.quotes else { return }
        var multiplier: Float = 0
        switch exchange {
        case "AUD":
            multiplier = Float(quote.aud ?? "0")!
        case "CAD":
            multiplier = Float(quote.cad ?? "0")!
        case "MXN":
            multiplier = Float(quote.mxn ?? "0")!
        case "PLN":
            multiplier = Float(quote.pln ?? "0")!
        default:
            break
        }
        uiEvents.onNext(.resultCalculation(value * multiplier))
    }

    private func saveToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: "Currency")

        do {
            coreDataObjects = try managedContext.fetch(fetchRequest)
            let managedObject = coreDataObjects?.first
            if let response = currencyLayerResponse {
                managedObject?.setValue(response.responseString, forKeyPath: "responseJSON")
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not update attribute. \(error), \(error.userInfo)")
        }
    }
}
