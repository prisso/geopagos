//
//   paymentmethod.swift
//  Geopago Challenge
//
//  Created by Lion User on 11/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation

//https://api.mercadopago.com/v1/payment_methods?public_key=TEST-951a4ee2-2516-4f98-9337-ebe93e3e45d7

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let paymentTypeId: String
    let thumbnail: String
    let settings: [Settings]
    let additionalInfoNeeded: [String]
    let maxAllowedAmount: Float
    
    struct Settings: Decodable {
        let cardNumber: CardNumberSetting
        let bin: BinSetting
        let securityCode: SecuritySetting
        
        struct CardNumberSetting: Decodable {
            let length: Int
        }
        
        struct BinSetting: Decodable {
            let pattern: String
        }
        
        struct SecuritySetting: Decodable {
            let length: Int
            let cardLocation: String
        }
    }

}

enum AdditionalInfo: String {
    case number = "cardholder_identification_number"
    case type = "cardholder_identification_type"
    case name = "cardholder_name"
    case issuerId =  "issuer_id"
}

enum PaymentType: String, CaseIterable {
    case all
    case credit = "credit_card"
    case debit = "debit_card"
    case prepaid = "prepaid_card"
    case ticket = "ticket"
    
    func description() -> String {
        switch self {
        case .credit:
            return "Credit card"
        case .debit:
            return "Debit card"
        case .prepaid:
            return "Prepaid card"
        case .ticket:
            return "Ticket"
        default:
            return "All"
        }
    }
}
