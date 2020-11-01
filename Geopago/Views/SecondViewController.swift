//
//  SecondViewController.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import UIKit
import Combine

class SecondViewController: UIViewController {
    
    @IBOutlet weak var cardIssuersTable: UITableView!
    
    private var cardIssuers: [CardIssuer] = []
    private var payerCosts: [Installments.PayerCosts] = []
    private let selectedInstallment = PassthroughSubject<Int, Never>()
    private let selectedCardIssuer = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SecondViewModelType
    private var selectedSection: Int = -1
    
    init(viewModel: SecondViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "SecondViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardIssuersTable.delegate = self
        cardIssuersTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = SecondViewModelInput<Int>(selectedCardIssuer: selectedCardIssuer.eraseToAnyPublisher(), selectedInstallment: selectedInstallment.eraseToAnyPublisher())
        
        viewModel.bind(input: input).sink(receiveCompletion: {
            print($0)
        },
            receiveValue: { (output) in
            print("On controller ... going to show items")
                self.cardIssuers = output.listCardIssuers
                self.payerCosts = output.listInstallments
                DispatchQueue.main.async {
                     self.cardIssuersTable.reloadData()
                }
            }).store(in: &cancellables)
    }
}

extension SecondViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cardIssuers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedSection == section) ? self.payerCosts.count : 0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = payerCosts[indexPath.row]

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell2")
        cell.prepareForReuse()
        cell.textLabel?.text = data.recommendedMessage

        return cell
    }
}

extension SecondViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = payerCosts[indexPath.row]
        selectedInstallment.send(data.installments)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect.init(x: 0, y: 0, width: cardIssuersTable.bounds.width, height: 60))
        header.tag = section
        let label = UILabel(frame: header.bounds)
        label.backgroundColor = section % 2 == 0 ? .gray : .lightGray
        label.text = cardIssuers[section].name
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionTapped(_:))))
        header.addSubview(label)
        
        return header
    }
     
    @objc func sectionTapped(_ gesture: UITapGestureRecognizer) {
        let tmp = gesture.view?.tag ?? 0
        if (tmp == selectedSection) {
            selectedSection = -1
            self.cardIssuersTable.reloadData()
        } else {
            selectedCardIssuer.send(cardIssuers[tmp].id)
            selectedSection = tmp
        }
    }
}
