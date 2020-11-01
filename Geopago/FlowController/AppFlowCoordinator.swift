//
//  AppFlowCoordinator.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation
import UIKit

protocol FlowCoordinator {
    func start()
}
class AppFlowCoordinator: FlowCoordinator{
    
    let navController = UINavigationController()
    
    private var stepsManager: StepManager? = nil
    private let window: UIWindow?
    private let dataProvider: AppDataProvider
    
    init(window: UIWindow?, dataProvider: AppDataProvider) {
        self.window = window
        self.dataProvider = dataProvider
    }
    
    func start() {
        stepsManager = StepManager(root: self, dataProvider: dataProvider)
        stepsManager?.start()
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
