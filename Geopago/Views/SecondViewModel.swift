//
//  SecondViewModel.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Combine

class SecondViewModel: SecondViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    private var cardIssuers: [CardIssuer] = []
    private var currentPayerCosts: [Installments.PayerCosts] = []
    private let output = PassthroughSubject<SecondViewModelOutput, Never>()
    private let dataProvider: DataProvider
    private let navigator: StepsNavigator
    
    
    init(dataProvider: DataProvider, navigator: StepsNavigator) {
        self.dataProvider = dataProvider
        self.navigator = navigator
    }

    func bind(input: SecondViewModelInput<Int>) -> AnyPublisher<SecondViewModelOutput, Never> {
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let publish: AnyPublisher<[CardIssuer], Never> = self.dataProvider.store.cardIssuers(for: self.dataProvider.purchase?.paymentMethod?.id ?? "")
        publish.sink(
            receiveCompletion: {
                print($0); print("Getting card issuers ... ")
            }, receiveValue: { cardIssuers in
                self.cardIssuers = cardIssuers
                let out = SecondViewModelOutput(listCardIssuers: self.cardIssuers, listInstallments: [])
                self.output.send( out )
            })
            .store(in: &cancellables)
        
        input.selectedCardIssuer
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { value in
                    let provider = self.dataProvider
                    guard let purchase = provider.purchase, let method = purchase.paymentMethod else { return }
                    purchase.cardIssuer = self.cardIssuers.first { value == $0.id }
                    let publish: AnyPublisher<[Installments], Never> = provider.store.installments(amount: purchase.amount, issuerId: value, paymentMethod: method.id)
                        publish.sink(receiveCompletion: {
                                        print($0) },
                                 receiveValue: { (installments) in
                                    self.currentPayerCosts = installments[0].payerCosts
                                    let out = SecondViewModelOutput(listCardIssuers: self.cardIssuers, listInstallments: self.currentPayerCosts)
                                    self.output.send( out )
                                })
                            .store(in: &self.cancellables)
            }).store(in: &self.cancellables)
        
        input.selectedInstallment.sink(receiveValue: { id in
                guard let purchase = self.dataProvider.purchase else { return }
                purchase.installments = self.currentPayerCosts.first { $0.installments == id }
                self.navigator.showFinalStep()
            }).store(in: &cancellables)

        return self.output.eraseToAnyPublisher()
    }
}
