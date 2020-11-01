//
//  FinalViewController.swift
//  Geopago
//
//  Created by Lion User on 14/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import UIKit
import Combine

class FinalViewController: UIViewController {
    
    @IBOutlet weak var cardNameEdit: UITextField!
    @IBOutlet weak var cardNumberEdit: UITextField!
    @IBOutlet weak var cardTypeEdit: UITextField!
    @IBOutlet weak var cardIssuerLbl: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var installmentsLbl: UILabel!
    @IBOutlet weak var cardCardNumberEdit: UITextField!
    @IBOutlet weak var cardSecurityEdit: UITextField!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var successfulImage: UIImageView!
    
    private var cancellables = Set<AnyCancellable>()
    private let buyBtnPressed = PassthroughSubject<Void, Never>()
    private let viewModel: FinalViewModelType
    
    init(viewModel: FinalViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "FinalViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        successfulImage.isHidden = true
        cardCardNumberEdit.text = ""
        cardSecurityEdit.text = ""
        
        buyButton.addTarget(self, action: #selector(buyTouched), for: .touchDown)
        
        let input = FinalViewModelInput(nameLoad: cardNameEdit.p(), documentNumberLoad: cardNumberEdit.p(), documentTypeLoad: cardTypeEdit.p(), cardNumberLoad: cardCardNumberEdit.p(), cardSecurityLoad: cardSecurityEdit.p(), buyBtnPressed: self.buyBtnPressed.eraseToAnyPublisher())
        
        self.viewModel.bind(input: input).sink(receiveValue: { output in
            DispatchQueue.main.async {
                self.cardIssuerLbl.text = (NSLocale.current.currencySymbol ?? "$") + String(output.data.amount)
                self.paymentMethodLbl.text = output.data.issuerName
                self.installmentsLbl.text = output.data.installmentMsg
                switch output.status {
                case .successFul:
                    self.successfulImage.isHidden = false
                default:
                    print("Idle or worng info ...")
                }
            }
        }).store(in: &cancellables)
    }
    
    @objc private func buyTouched() {
        self.buyBtnPressed.send(())
        self.view.endEditing(true)
    }
}

extension UITextField {
    func p() -> AnyPublisher<String, Never> {
        return self.publisher(for: \.text).map{ $0 ?? "" }.eraseToAnyPublisher()
    }
}
