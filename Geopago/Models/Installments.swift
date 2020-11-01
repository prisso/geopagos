//
//  Installments.swift
//  Geopago Challenge
//
//  Created by Lion User on 11/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation

// https://api.mercadopago.com/v1/payment_methods/installments?public_key=TEST-951a4ee2-2516-4f98-9337-ebe93e3e45d7&payment_method_id=amex&amount=100&issuer.id=303

struct Installments: Decodable {
    
    let payerCosts: [PayerCosts]
    
    enum InstallmentsKeys: String, CodingKey {
        case payerCosts = "payer_costs"
    }
    
    struct PayerCosts: Decodable {
        let installments: Int
        let installmentRate: Float
        let discountRate: Float
        let labels: [String]
        let recommendedMessage: String
        let installmentAmount: Float
        let totalAmount: Float
        
        enum PayerCostsKeys: String, CodingKey {
            case installments = "installments"
            case installmentRate = "installment_rate"
            case discountRate = "discount_rate"
            case labels
            case recommendedMsg = "recommended_message"
            case installmentAmount = "installment_amount"
            case totalAmount = "total_amount"
        }
    }
    
    /*init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: InstallmentsKeys.self)
        let payers = try values.nestedContainer(keyedBy: PayerCostsKeys.self, forKey: .payerCosts)
        
        installments = try payers.decode(Int.self, forKey: .installments)
        installmentRate = try payers.decode(Float.self, forKey: .installmentRate)
        discountRate = try payers.decode(Float.self, forKey: .discountRate)
        labels = try payers.decode([String].self, forKey: .labels)
        recommendedMessage = try payers.decode(String.self, forKey: .recommendedMsg)
        installmentAmount = try payers.decode(Float.self, forKey: .installmentAmount)
        totalAmount = try payers.decode(Float.self, forKey: .totalAmount)
    }*/
}
