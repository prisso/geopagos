//
//  Purchase.swift
//  Geopago
//
//  Created by Lion User on 12/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation

class Purchase {
    var amount: Float
    var paymentMethod: PaymentMethod? = nil
    var cardIssuer: CardIssuer? = nil
    var installments: Installments.PayerCosts? = nil
    var countInstallments: Int = 0
    
    init(value: Float) {
        amount = value
    }
}
