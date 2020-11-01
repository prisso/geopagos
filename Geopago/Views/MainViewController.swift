//
//  MainViewController.swift
//  Geopago
//
//  Created by Lion User on 12/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import UIKit
import Combine


class MainViewController : UIViewController {
    
    private let amount = PassthroughSubject<Float, Never>()
    private let paymentType = PassthroughSubject<PaymentType, Never>()
    private let paymentMethod = PassthroughSubject<String, Never>()
    private var cancellabes = Set<AnyCancellable>()
    private let viewModel: MainViewModelType
    private var paymentTypes: [PaymentType] = []
    private var paymentMethods: [PaymentMethod] = []
    
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var nextStepBtn: UIButton!
    @IBOutlet weak var paymentMethodTable: UITableView!
    @IBOutlet weak var paymentTypePicker: UIPickerView!
    
    init(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountText.delegate = self
        paymentTypePicker.delegate = self
        paymentMethodTable.delegate = self
        paymentMethodTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        bindToModal()
    }
    
    private func updateUI() {
        paymentMethodTable.isHidden = true
        paymentTypePicker.isHidden = true
    }
    
    private func bindToModal() {
        cancellabes.forEach { $0.cancel() }
        cancellabes.removeAll()
        
        amount.sink(receiveValue: { [weak self] value in
            let hide = !(value > 0.0)
            self?.paymentTypePicker.isHidden = hide
            self?.paymentMethodTable.isHidden = hide
        }).store(in: &cancellabes)
        if let text = amountText.text?.dropFirst() {
            amount.send( Float( text ) ?? 0.0 )
        }
        
        let output = MainViewModelInput(amount: amount.eraseToAnyPublisher(), paymentType: paymentType.eraseToAnyPublisher(), paymentMethod: paymentMethod.eraseToAnyPublisher())
        viewModel.bind(input: output).sink(receiveValue: { input in
                self.paymentMethods = input.paymentMethods
                self.paymentMethodTable.reloadData()
                self.paymentTypes = input.paymentTypes
                self.paymentTypePicker.reloadAllComponents()
            }).store(in: &cancellabes)
    }
}

extension MainViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "\n" { textField.resignFirstResponder(); return false }
        if let text = (textField.text as NSString?) {
            let newText = text.replacingCharacters(in: range, with: string)
            if string == "" && newText.count == 1 {
                amount.send(0.0)
                textField.text = ""
                return true
            } else if !newText.hasPrefix("$") {
                amount.send(Float(string) ?? 0.0)
                textField.text = "$" + string
                return false
            } else {
                let fIndex = newText.firstIndex(of: "$")!
                let number = newText[newText.index(after: fIndex)...]
                amount.send(Float(number) ?? 0.0)
            }
        }
        return true
    }
}

extension MainViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.paymentTypes.count
    }
}

extension MainViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentTypes[row].description()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if amountText.isFirstResponder { amountText.resignFirstResponder() }
        paymentType.send(paymentTypes[row])
    }
}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if amountText.isFirstResponder { amountText.resignFirstResponder() }
        paymentMethod.send(paymentMethods[indexPath.row].id)
    }
}

extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.paymentMethods[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.prepareForReuse()
        cell.textLabel?.text = model.name
        
        return cell
    }
    
    
}
