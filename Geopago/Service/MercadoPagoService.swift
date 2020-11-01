//
//  MercadoPagoService.swift
//  Geopago
//
//  Created by Lion User on 12/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation
import Combine


class MercadoPagoService: StoreService {
    
    private static let baseUrl = "https://api.mercadopago.com/v1"
    
    private var token: String
    private var resourcesProvider: ResourcesService
    
    init(token: String, resources: ResourcesService) {
        self.token = token
        self.resourcesProvider = resources
    }
    
    func paymentMethods() -> AnyPublisher<[PaymentMethod], Never> {
        let url = MercadoPagoService.baseUrl + "/payment_methods?public_key=\(token)"
        let pusher: AnyPublisher<[PaymentMethod], ConnectionError> = resourcesProvider.getData(url: url)
        return pusher.catch { error in
            return Just([])
        }.eraseToAnyPublisher()
    }
    
    func cardIssuers(for paymentMethodId: String) -> AnyPublisher<[CardIssuer], Never> {
        let url = MercadoPagoService.baseUrl + "/payment_methods/card_issuers?public_key=\(token)&payment_method_id=\(paymentMethodId)"
        let pusher: AnyPublisher<[CardIssuer], ConnectionError> = resourcesProvider.getData(url: url)
        return pusher.catch { errpr in
            return Just([])
        }.eraseToAnyPublisher()
    }
    
    func installments(amount: Float, issuerId: String, paymentMethod: String) -> AnyPublisher<[Installments], Never> {
        let url = MercadoPagoService.baseUrl + "/payment_methods/installments?public_key=\(token)&payment_method_id=\(paymentMethod)&amount=\(String(amount))&issuer.id=\(issuerId)"
        let pusher: AnyPublisher<[Installments], ConnectionError> = resourcesProvider.getData(url: url)
        return pusher.catch { errpr in
            return Just([])
        }.eraseToAnyPublisher()
    }
}
