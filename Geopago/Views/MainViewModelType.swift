//
//  MainViewModelInterface.swift
//  Geopago
//
//  Created by Lion User on 12/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Combine

struct MainViewModelInput<T: Numeric, U> {
    let amount: AnyPublisher<T, Never>
    let paymentType: AnyPublisher<PaymentType, Never>
    let paymentMethod: AnyPublisher<U, Never>
}

struct MainViewModelOutput {
    let paymentTypes: [PaymentType]
    let paymentMethods: [PaymentMethod]
}

protocol MainViewModelType {
    func bind(input: MainViewModelInput<Float, String>) -> AnyPublisher<MainViewModelOutput, Never>
}
