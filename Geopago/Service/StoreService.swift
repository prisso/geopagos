//
//  StoreService.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation
import Combine

protocol StoreService {
    
    func paymentMethods() -> AnyPublisher<[PaymentMethod], Never>
    
    func cardIssuers(for paymentMethodId: String) -> AnyPublisher<[CardIssuer], Never>
    
    func installments(amount: Float, issuerId: String, paymentMethod: String) -> AnyPublisher<[Installments], Never>
}
