//
//  CCurrencyLayerResponse.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 14/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import Foundation
import HandyJSON
import Moya

struct CCurrencyLayerResponse: HandyJSON {
    var responseString: String?
    var status: CCResponseStatus
    var moyaEerror: MoyaError?

    var success: Bool = false
    var terms: String?
    var privacy: String?
    var date: String?
    var timestamp: Double?
    var source: String?
    var quotes: CCurrencyLayerQuotes?
    var error: CCurrencyLayerError?

    init() {
        status = .failure
        error = nil
        responseString = nil
    }

    enum QuoteType: String, HandyJSONEnum {
        case usd = "USDUSD"
        case aud = "USDAUD"
        case cad = "USDCAD"
        case pln = "USDPLN"
        case mxn = "USDMXN"
    }

    struct CCurrencyLayerQuotes: HandyJSON {
        var usd: String?
        var aud: String?
        var cad: String?
        var pln: String?
        var mxn: String?

        mutating func mapping(mapper: HelpingMapper) {
            mapper <<<
                self.usd <-- "USDUSD"
            mapper <<<
                self.aud <-- "USDAUD"
            mapper <<<
                self.cad <-- "USDCAD"
            mapper <<<
                self.pln <-- "USDPLN"
            mapper <<<
                self.mxn <-- "USDMXN"
        }
    }

    struct CCurrencyLayerError: HandyJSON {
        var code: Int?
        var info: String?
    }

    func getQuoteArr() -> [String?] {
        guard let quotes = quotes else { return [nil] }
        return [quotes.usd, quotes.aud, quotes.cad, quotes.mxn, quotes.pln]
    }
}
