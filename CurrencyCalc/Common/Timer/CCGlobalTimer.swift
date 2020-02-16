//
//  CCGlobalTimer.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 16/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation

final class CCGlobalTimer: NSObject {
    static let shared = CCGlobalTimer()
    private var timer: Timer?

    func startTimer() {
        timer = Timer(timeInterval: 180.0,
                      target: self,
                      selector: #selector(timerAction),
                      userInfo: nil,
                      repeats: true)
    }

    func stopTimer() {
        guard timer != nil else { return }
        self.timer!.invalidate()
    }
}

extension CCGlobalTimer {
    @objc private func timerAction() {
        CCMainViewModel().viewModelEvents.onNext(.getCurrenciesData(.historical))
    }
}
