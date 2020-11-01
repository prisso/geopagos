//
//  StepManager.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import UIKit


class StepManager {
    
    private let root: AppFlowCoordinator
    private let dataProvider: AppDataProvider
    
    init(root: AppFlowCoordinator, dataProvider: AppDataProvider) {
        self.root = root
        self.dataProvider = dataProvider
    }
}

extension StepManager : FlowCoordinator {
    func start() {
        let mainViewModel = MainViewModel(dataProvider: dataProvider, navigator: self)
        root.navController.setViewControllers([MainViewController(viewModel: mainViewModel)], animated: false)
    }
}

extension StepManager : StepsNavigator {
    func gotoIni() {
        // Clean provider
        dataProvider.clean()
        start()
        /*let viewModel = MainViewModel(dataProvider: dataProvider, navigator: self)
        root.navController.setViewControllers([MainViewController(viewModel: viewModel)], animated: true)*/
    }
    
    func showSecondStep() {
        let secondViewModel = SecondViewModel(dataProvider: self.dataProvider, navigator: self)
        root.navController.pushViewController(SecondViewController(viewModel: secondViewModel), animated: false)
    }
    
    func showFinalStep() {
        let viewModel = FinalViewModel(dataProvider: self.dataProvider, navigator: self)
        root.navController.pushViewController(FinalViewController(viewModel: viewModel), animated: true)
    }
    
}
