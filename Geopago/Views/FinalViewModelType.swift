//
//  FinalViewModelType.swift
//  Geopago
//
//  Created by Lion User on 14/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation
import Combine

struct SimpleInfo {
    let amount: Float
    let issuerName: String
    let installmentMsg: String
}

struct FinalViewModelInput {
    let nameLoad: AnyPublisher<String, Never>
    let documentNumberLoad: AnyPublisher<String, Never>
    let documentTypeLoad: AnyPublisher<String, Never>
    let cardNumberLoad: AnyPublisher<String, Never>
    let cardSecurityLoad: AnyPublisher<String, Never>
    let buyBtnPressed: AnyPublisher<Void, Never>
}


enum ProcessBuyStatus {
    case idle
    case someDataIsMissed
    case wrongNumberLong
    case wrongCardIssuer
    case successFul
}

struct FinalViewModelOutput {
    let status: ProcessBuyStatus
    let data: SimpleInfo
}

protocol FinalViewModelType {
    func bind(input: FinalViewModelInput) -> AnyPublisher<FinalViewModelOutput, Never>
}
