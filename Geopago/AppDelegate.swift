//
//  AppDelegate.swift
//  Geopago
//
//  Created by Lion User on 12/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let token = Bundle.main.object(forInfoDictionaryKey: "mercadopago_token_id") as? String
        guard let utoken = token else {
            fatalError("Token ID wasn't set inside bundle")
        }
        
        let store = MercadoPagoService(token: utoken, resources: Resources())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let app = AppFlowCoordinator(window: window, dataProvider: AppDataProvider(store: store))
        app.start()
        
        return true
    }

}

