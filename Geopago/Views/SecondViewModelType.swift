//
//  SecondViewModelType.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Combine


struct SecondViewModelInput<T> {
    let selectedCardIssuer: AnyPublisher<String, Never>
    let selectedInstallment: AnyPublisher<T, Never>
}


struct SecondViewModelOutput {
    let listCardIssuers: [CardIssuer]
    let listInstallments: [Installments.PayerCosts]
}

protocol SecondViewModelType {
    func bind(input: SecondViewModelInput<Int>) -> AnyPublisher<SecondViewModelOutput, Never>
}
