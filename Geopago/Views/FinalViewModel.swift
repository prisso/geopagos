//
//  FinalViewModel.swift
//  Geopago
//
//  Created by Lion User on 14/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Combine
import UIKit

class FinalViewModel: FinalViewModelType {
    
    private let dataProvider: DataProvider
    private let navigator: StepsNavigator
    private var cancellables = Set<AnyCancellable>()
    private let output = PassthroughSubject<FinalViewModelOutput, Never>()
    
    private var name = ""
    private var documentNumber = ""
    private var documentType = ""
    private var cardNumber = ""
    private var cardSecurity = ""
    private var info: SimpleInfo
    
    init(dataProvider: DataProvider, navigator: StepsNavigator) {
        self.dataProvider = dataProvider
        self.navigator = navigator
        
        guard let buy = dataProvider.purchase else {
            self.info = SimpleInfo(amount: 0.0, issuerName: "Unknown", installmentMsg: "")
            return
        }
        self.info = SimpleInfo(amount: buy.amount, issuerName: buy.cardIssuer?.name ?? "Unknown", installmentMsg: buy.installments?.recommendedMessage ?? "Unknown")
    }
    
    func bind(input: FinalViewModelInput) -> AnyPublisher<FinalViewModelOutput, Never> {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.cardNumberLoad.sink(receiveValue: { self.cardNumber = $0 } ).store(in: &cancellables)
        input.nameLoad.sink(receiveValue: { self.name = $0 }).store(in: &cancellables)
        input.documentTypeLoad.sink(receiveValue: { self.documentType = $0 }).store(in: &cancellables)
        input.documentNumberLoad.sink(receiveValue: { self.documentNumber = $0 }).store(in: &cancellables)
        input.cardSecurityLoad.sink(receiveValue: { self.cardSecurity = $0 }).store(in: &cancellables)
        input.buyBtnPressed.sink(receiveValue: {
            self.checkData()
        }).store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            self.output.send(FinalViewModelOutput(status: .idle, data: self.info))
        })
        
        return self.output.eraseToAnyPublisher()
    }
    
    private func checkData() {
        if !checkAdditionalInfo() {
            output.send(FinalViewModelOutput(status: .someDataIsMissed, data: self.info))
            return
        }
        
        if !checkCardData() {
            output.send(FinalViewModelOutput(status: .wrongNumberLong, data: self.info))
            return
        }
        
        if !checkCardPattern() {
            output.send(FinalViewModelOutput(status: .wrongCardIssuer, data: self.info))
            return
        }

        output.send(FinalViewModelOutput(status: .successFul, data: self.info))
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) {_ in 
            self.navigator.gotoIni()
        }
    }
    
    private func checkAdditionalInfo() -> Bool {
        // Other checks --
        return true
    }
    
    private func checkCardData() -> Bool {
        if let settings = dataProvider.purchase?.paymentMethod?.settings[0] {
            return settings.cardNumber.length == self.cardNumber.count && settings.securityCode.length == self.cardSecurity.count
        }
        return false
    }
    
    private func checkCardPattern() -> Bool {
        if let settings = dataProvider.purchase?.paymentMethod?.settings[0] {
            let range = NSRange(location: 0, length: settings.bin.pattern.utf16.count)
            let regex = try! NSRegularExpression(pattern: settings.bin.pattern)
            let r = regex.firstMatch(in: self.cardNumber, options: [], range: range)
                return r != nil
        }
        return false
    }
}
