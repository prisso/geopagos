//
//  AppDataProvider.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation


protocol DataProvider : AnyObject {
    var purchase: Purchase? {get set}
    
    var store: StoreService {get}
    
    func clean()
}


class AppDataProvider : DataProvider {
    
    private(set) var store: StoreService
    var purchase: Purchase?
    
    init(store: StoreService) {
        self.store = store
    }
    
    func clean() {
        self.purchase = nil
    }
}
