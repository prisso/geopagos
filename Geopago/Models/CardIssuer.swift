//
//  CardIssuer.swift
//  Geopago Challenge
//
//  Created by Lion User on 11/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation

// https://api.mercadopago.com/v1/payment_methods/card_issuers?public_key=TEST-951a4ee2-2516-4f98-9337-ebe93e3e45d7&payment_method_id=amex#json

struct CardIssuer: Decodable {
    let id: String
    let name: String
    let thumbnail: String
}
