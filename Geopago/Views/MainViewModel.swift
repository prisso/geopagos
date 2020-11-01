//
//  MainViewModel.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Combine


class MainViewModel: MainViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    private var paymentMethods = [PaymentMethod]()
    private var paymentTypes = Set<PaymentType>()
    private let publisher = PassthroughSubject<MainViewModelOutput, Never>()
    private var currentAmout: Float = 0.0
    private let navigator: StepsNavigator
    private let dataProvider: DataProvider
    
    init(dataProvider: DataProvider, navigator: StepsNavigator) {
        self.navigator = navigator
        self.dataProvider = dataProvider
    }
    
    func bind(input: MainViewModelInput<Float, String>) ->
        AnyPublisher<MainViewModelOutput, Never> {
            
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
            
        let publisher: AnyPublisher<[PaymentMethod], Never> = dataProvider.store.paymentMethods()
        
        publisher.sink(receiveCompletion: { print($0); print("Getting payment methods ... ") },
            receiveValue: { methods in
                self.paymentMethods = methods
                self.paymentTypes = self.validMethodsTypes(amount: 0.0, methodIds: methods)
            })
            .store(in: &cancellables)
        
        let output1 = input.amount.debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .map { (value: Float) -> MainViewModelOutput in
                self.currentAmout = value
                let validMethods = self.paymentMethods.filter {
                    $0.maxAllowedAmount > value
                }
                self.paymentTypes = self.validMethodsTypes(amount: value, methodIds: validMethods)
                return self.buildOutput(types: self.paymentTypes, methods: validMethods)
        }.eraseToAnyPublisher()
        
        let output2 = input.paymentType.map { (value: PaymentType) -> MainViewModelOutput in
            if value == .all {
                return self.buildOutput(types: self.paymentTypes, methods: self.paymentMethods)
            }
            let validMethods = self.paymentMethods.filter { $0.maxAllowedAmount > self.currentAmout && $0.paymentTypeId == value.rawValue }
            return self.buildOutput(types: self.paymentTypes, methods: validMethods)
        }.eraseToAnyPublisher()
        
        input.paymentMethod
            .sink(receiveValue: { value in
                if let paymentMethod = self.paymentMethods.first(where: { $0.id == value }) {
                    self.dataProvider.purchase = Purchase(value: self.currentAmout)
                    self.dataProvider.purchase?.paymentMethod = paymentMethod
                    self.navigator.showSecondStep()
                }
            }).store(in: &cancellables)
        
        return Publishers.Merge(output1, output2).eraseToAnyPublisher()
    }
    
    private func buildOutput(types: Set<PaymentType>, methods: [PaymentMethod]) -> MainViewModelOutput {
        return MainViewModelOutput(paymentTypes: Array(types).sorted { $0.description() < $1.description() },
                                   paymentMethods: methods.sorted { $0.name < $1.name } )
    }
    
    private func validMethodsTypes(amount: Float, methodIds: [PaymentMethod]) -> Set<PaymentType> {
        var tmp = Set<PaymentType>()
        methodIds.forEach {
            let type = PaymentType(rawValue: $0.paymentTypeId)
            if let t = type {
                tmp.insert( t ) }
        }
        if (tmp.count > 1) {
            tmp.insert(PaymentType.all)
        }
        return tmp
    }
}
