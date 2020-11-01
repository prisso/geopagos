//
//  ResourcesService.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import UIKit
import Combine


protocol ResourcesService {
    
    func getData<T : Decodable>(url: String) -> AnyPublisher<T, ConnectionError>
    
    func loadImage(url: String) -> AnyPublisher<UIImage?, ConnectionError>
    
}
